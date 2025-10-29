package com.example.track_expenses

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.Intent
import android.app.PendingIntent


class InputWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray)  {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.input_income_layout)

            val intent = Intent(context,QuickIncomeActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context,0,intent,PendingIntent.FLAG_IMMUTABLE)

            views.setOnClickPendingIntent(R.id.widget_container,pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}