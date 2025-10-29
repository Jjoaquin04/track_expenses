package com.example.track_expenses

import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.*

class QuickIncomeActivity : AppCompatActivity() {

    private lateinit var etName: EditText
    private lateinit var etAmount: EditText
    private lateinit var spinnerCategory: Spinner
    private lateinit var datePicker: DatePicker
    private lateinit var btnSave: Button

    private val categories = arrayOf(
        "Salario",
        "Salario Extra",
        "Freelance",
        "Negocio Propio",
        "Inversiones",
        "Alquileres",
        "Ventas",
        "Reembolsos",
        "Regalos/Ayuda",
        "Otros Ingresos"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_quick_income)

        // Inicializar vistas
        etName = findViewById(R.id.et_name)
        etAmount = findViewById(R.id.et_amount)
        spinnerCategory = findViewById(R.id.spinner_category)
        datePicker = findViewById(R.id.date_picker)
        btnSave = findViewById(R.id.btn_save)

        // Configurar spinner
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, categories)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinnerCategory.adapter = adapter

        // Configurar botón guardar
        btnSave.setOnClickListener { saveIncome() }
    }

    private fun saveIncome() {
        val name = etName.text.toString().trim()
        val amountText = etAmount.text.toString().trim()
        val category = spinnerCategory.selectedItem.toString()

        // Validación
        if (name.isEmpty()) {
            etName.error = "El nombre es requerido"
            return
        }

        if (amountText.isEmpty()) {
            etAmount.error = "El monto es requerido"
            return
        }

        val amount = amountText.toDoubleOrNull()
        if (amount == null || amount <= 0) {
            etAmount.error = "Ingrese un monto válido"
            return
        }

        // Obtener fecha del DatePicker
        val year = datePicker.year
        val month = datePicker.month
        val day = datePicker.dayOfMonth
        val calendar = Calendar.getInstance()
        calendar.set(year, month, day)
        val selectedDate = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(calendar.time)

        // Guardar en SharedPreferences (para que Flutter lo lea)
        val prefs: SharedPreferences = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val editor = prefs.edit()

        // Crear ID único para el ingreso
        val incomeId = UUID.randomUUID().toString()

        // Guardar datos del ingreso
        editor.putString("income_${incomeId}_name", name)
        editor.putString("income_${incomeId}_amount", amount.toString())
        editor.putString("income_${incomeId}_category", category)
        editor.putString("income_${incomeId}_date", selectedDate)
        editor.putString("income_${incomeId}_type", "income")
        editor.apply()

        // Notificar a Flutter (opcional - puedes usar un BroadcastReceiver)
        val intent = Intent("com.example.track_expenses.INCOME_ADDED")
        sendBroadcast(intent)

        // Mostrar mensaje y cerrar
        Toast.makeText(this, "Ingreso guardado correctamente", Toast.LENGTH_SHORT).show()
        finish()
    }
}