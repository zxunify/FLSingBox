package com.flsingbox.flsingbox

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import java.io.File

class SingBoxVpnService : VpnService() {
    companion object {
        const val CHANNEL_ID = "flsingbox_vpn"
        const val NOTIFICATION_ID = 1
        const val ACTION_START = "com.flsingbox.START_VPN"
        const val ACTION_STOP = "com.flsingbox.STOP_VPN"
        const val EXTRA_CONFIG_PATH = "config_path"

        var isRunning = false
            private set
    }

    private var vpnInterface: ParcelFileDescriptor? = null
    private var singBoxProcess: Process? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                stopVpn()
                return START_NOT_STICKY
            }
            ACTION_START -> {
                val configPath = intent.getStringExtra(EXTRA_CONFIG_PATH)
                if (configPath != null) {
                    startVpn(configPath)
                }
            }
        }
        return START_STICKY
    }

    private fun startVpn(configPath: String) {
        // 建立 VPN 接口
        val builder = Builder()
            .setSession("FLSingBox")
            .setMtu(9000)
            .addAddress("172.19.0.1", 30)
            .addRoute("0.0.0.0", 0)
            .addDnsServer("1.1.1.1")
            .addDnsServer("8.8.8.8")

        // 排除自身应用
        try {
            builder.addDisallowedApplication(packageName)
        } catch (_: Exception) {}

        vpnInterface = builder.establish()

        if (vpnInterface == null) {
            stopSelf()
            return
        }

        // 启动 sing-box 进程
        startSingBox(configPath)

        isRunning = true
        startForeground(NOTIFICATION_ID, createNotification("VPN 运行中"))
    }

    private fun startSingBox(configPath: String) {
        val singBoxBinary = File(applicationInfo.nativeLibraryDir, "libsingbox.so")
        if (!singBoxBinary.exists()) {
            // Fallback: check assets extracted path
            val dataDir = filesDir.absolutePath
            val altBinary = File("$dataDir/sing-box")
            if (!altBinary.exists()) {
                stopSelf()
                return
            }
        }

        val binaryPath = if (File(applicationInfo.nativeLibraryDir, "libsingbox.so").exists()) {
            File(applicationInfo.nativeLibraryDir, "libsingbox.so").absolutePath
        } else {
            "${filesDir.absolutePath}/sing-box"
        }

        try {
            val fd = vpnInterface?.fd ?: return
            val processBuilder = ProcessBuilder(
                binaryPath, "run", "-c", configPath
            )
            processBuilder.environment()["SING_BOX_TUN_FD"] = fd.toString()
            processBuilder.redirectErrorStream(true)
            singBoxProcess = processBuilder.start()
        } catch (e: Exception) {
            e.printStackTrace()
            stopVpn()
        }
    }

    private fun stopVpn() {
        singBoxProcess?.destroy()
        singBoxProcess = null
        vpnInterface?.close()
        vpnInterface = null
        isRunning = false
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }

    override fun onRevoke() {
        stopVpn()
        super.onRevoke()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "FLSingBox VPN",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "VPN 服务运行状态"
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(text: String): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val stopIntent = Intent(this, SingBoxVpnService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 1, stopIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("FLSingBox")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setContentIntent(pendingIntent)
            .addAction(
                Notification.Action.Builder(
                    null, "停止", stopPendingIntent
                ).build()
            )
            .setOngoing(true)
            .build()
    }
}
