package com.example.track_expenses

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

class SaveTransactionWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {

    override fun doWork(): Result {
        val transactionId = inputData.getString("transactionId") ?: return Result.failure()

        return Result.success()
    }
}
