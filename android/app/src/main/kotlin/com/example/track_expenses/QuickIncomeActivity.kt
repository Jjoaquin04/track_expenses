package com.example.track_expenses

import android.app.Activity
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.CheckBox
import android.widget.DatePicker
import android.widget.EditText
import android.widget.Spinner
import android.widget.Toast
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.UUID
import es.antonborri.home_widget.HomeWidgetPlugin

class QuickIncomeActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_quick_income)

        val nameEditText: EditText = findViewById(R.id.incomeNameEditText)
        val amountEditText: EditText = findViewById(R.id.incomeAmountEditText)
        val categorySpinner: Spinner = findViewById(R.id.incomeCategorySpinner)
        val fixedIncomeCheckBox: CheckBox = findViewById(R.id.fixedIncomeCheckBox)
        val saveButton: Button = findViewById(R.id.saveIncomeButton)

        // Configurar Spinner
        ArrayAdapter.createFromResource(
            this,
            R.array.income_categories,
            android.R.layout.simple_spinner_item
        ).also { adapter ->
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            categorySpinner.adapter = adapter
        }

        saveButton.setOnClickListener {
            saveIncome(
                nameEditText.text.toString(),
                amountEditText.text.toString(),
                categorySpinner.selectedItem.toString(),
                fixedIncomeCheckBox.isChecked
            )
        }
    }

    private fun saveIncome(
        name: String,
        amount: String,
        category: String,
        isFixed: Boolean
    ) {
        if (name.isBlank() || amount.isBlank()) {
            Toast.makeText(this, "Nombre y cantidad son obligatorios", Toast.LENGTH_SHORT).show()
            return
        }

        val incomeId = UUID.randomUUID().toString()
        val datePicker = findViewById<DatePicker>(R.id.date_picker)
        val year = datePicker.year
        val month = datePicker.month
        val day = datePicker.dayOfMonth
        val calendar = Calendar.getInstance()
        calendar.set(year, month, day)
        val date = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).format(calendar.time)
        val fixedIncome = if (isFixed) 1 else 0

        // 2. CONSTRUIR UN STRING JSON CON LOS DATOS
        // Esto es lo que Dart recibirá
        val jsonString = """
            {
                "transactionId": "$incomeId",
                "name": "$name",
                "amount": "$amount",
                "category": "$category",
                "date": "$date",
                "type": "income",
                "fixedExpense": $fixedIncome
            }
        """.trimIndent()


        // 3. USAR HOME_WIDGET PARA GUARDAR LOS DATOS Y LLAMAR AL CALLBACK
        try {
            HomeWidgetPlugin.getData(this).edit()
                .putString("expense_data", jsonString)
                .apply()

            // Esto despierta el 'backgroundCallback' en Dart
            HomeWidgetPlugin.updateWidget(this)

            Toast.makeText(this, "Ingreso guardado", Toast.LENGTH_SHORT).show()
            
        } catch (e: Exception) {
            Toast.makeText(this, "Error al guardar", Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }

        // 4. ELIMINAMOS TODA LA LÓGICA DE SHARED PREFERENCES Y WORKMANAGER

        // Terminar la actividad
        finish()
    }
}
