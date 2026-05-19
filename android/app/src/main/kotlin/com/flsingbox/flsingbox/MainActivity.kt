package com.flsingbox.flsingbox

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.flsingbox/vpn"
        private const val VPN_REQUEST_CODE = 1001
    }

    private var pendingConfigPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startVpn" -> {
                    val configPath = call.argument<String>("configPath")
                    if (configPath != null) {
                        startVpnService(configPath)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARG", "configPath is required", null)
                    }
                }
                "stopVpn" -> {
                    stopVpnService()
                    result.success(true)
                }
                "isVpnRunning" -> {
                    result.success(SingBoxVpnService.isRunning)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startVpnService(configPath: String) {
        val vpnIntent = VpnService.prepare(this)
        if (vpnIntent != null) {
            pendingConfigPath = configPath
            startActivityForResult(vpnIntent, VPN_REQUEST_CODE)
        } else {
            launchVpnService(configPath)
        }
    }

    private fun launchVpnService(configPath: String) {
        val intent = Intent(this, SingBoxVpnService::class.java).apply {
            action = SingBoxVpnService.ACTION_START
            putExtra(SingBoxVpnService.EXTRA_CONFIG_PATH, configPath)
        }
        startService(intent)
    }

    private fun stopVpnService() {
        val intent = Intent(this, SingBoxVpnService::class.java).apply {
            action = SingBoxVpnService.ACTION_STOP
        }
        startService(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            pendingConfigPath?.let { launchVpnService(it) }
            pendingConfigPath = null
        }
    }
}
