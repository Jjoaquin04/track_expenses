package com.example.track_expenses

import android.app.Activity
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.CheckBox
import android.widget.EditText
import android.widget.Spinner
import android.widget.Toast
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.UUID

// 1. IMPORTAR EL PLUGIN HOME_WIDGET
import es.antonborri.home_widget.HomeWidgetPlugin
// IMPORTS AÑADIDOS
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundReceiver


class QuickOutputActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_quick_output)

        val nameEditText: EditText = findViewById(R.id.expenseNameEditText)
        val amountEditText: EditText = findViewById(R.id.expenseAmountEditText)
        val categorySpinner: Spinner = findViewById(R.id.expenseCategorySpinner)
        val fixedExpenseCheckBox: CheckBox = findViewById(R.id.fixedExpenseCheckBox)
        val saveButton: Button = findViewById(R.id.saveExpenseButton)

        // Configurar Spinner
        ArrayAdapter.createFromResource(
            this,
            R.array.expense_categories,
            android.R.layout.simple_spinner_item
        ).also { adapter ->
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            categorySpinner.adapter = adapter
        }

        saveButton.setOnClickListener {
            saveExpense(
                nameEditText.text.toString(),
                amountEditText.text.toString(),
                categorySpinner.selectedItem.toString(),
                fixedExpenseCheckBox.isChecked
            )
        }
    }

    private fun saveExpense(
        name: String,
        amount: String,
        category: String,
        isFixed: Boolean
    ) {
        if (name.isBlank() || amount.isBlank()) {
            Toast.makeText(this, getString(R.string.fields_required), Toast.LENGTH_SHORT).show()
            return
        }

        val expenseId = UUID.randomUUID().toString()
        val date = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).format(Date())
        val fixedExpense = if (isFixed) 1 else 0

        // 2. CONSTRUIR UN STRING JSON CON LOS DATOS
        // Nota: "type": "expense"
        val jsonString = """
            {
                "transactionId": "$expenseId",
                "name": "$name",
                "amount": "$amount",
                "category": "$category",
                "date": "$date",
                "type": "expense",
                "fixedExpense": $fixedExpense
            }
        """.trimIndent()

        // 3. USAR HOME_WIDGET PARA GUARDAR LOS DATOS Y LLAMAR AL CALLBACK
         try {
            HomeWidgetPlugin.getData(this).edit()
                .putString("expense_data", jsonString)
                .apply()

            // MODIFICADO: Esto despierta el 'backgroundCallback' en Dart
            // Creamos un Intent para el HomeWidgetBackgroundReceiver
            val intent = Intent(this, HomeWidgetBackgroundReceiver::class.java).apply {
                action = "es.antonborri.home_widget.action.BACKGROUND"
                // Este URI será recibido por el callback de Dart para que sepa qué hacer
                data = Uri.parse("homewidget://update")
            }
            sendBroadcast(intent)

            Toast.makeText(this, getString(R.string.expense_saved), Toast.LENGTH_SHORT).show()

        } catch (e: Exception) {
            Toast.makeText(this, getString(R.string.save_error), Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }
        
        // 4. ELIMINAMOS TODA LA LÓGICA DE SHARED PREFERENCES Y WORKMANAGER

        // Terminar la actividad
        finish()
    }
}