package com.example.track_expenses

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class OutputWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray)  {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.output_expense_layout)

            // Aquí es donde leerías datos de Flutter y actualizarías el texto.
            // De momento, lo dejamos estático.
            // val title = widgetData.getString("widget_title", "Mi Primer Widget")
            // views.setTextViewText(R.id.widget_title, title)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}