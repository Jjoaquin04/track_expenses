package com.example.track_expenses

import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.*

class QuickEntryActivity : AppCompatActivity() {

    private lateinit var etName: EditText
    private lateinit var etAmount: EditText
    private lateinit var spinnerCategory: Spinner
    private lateinit var btnSave: Button
    private lateinit var btnCancel: Button

    private val categories = arrayOf('Alimentación',
    "Transporte",
    "Vivienda",
    "Servicios",
    "Salud",
    "Educación",
    "Entretenimiento",
    "Ropa y Calzado",
    "Cuidado Personal",
    "Otros Gastos")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_quick_entry)

        // Inicializar vistas
        etName = findViewById(R.id.et_name)
        etAmount = findViewById(R.id.et_amount)
        spinnerCategory = findViewById(R.id.spinner_category)
        btnSave = findViewById(R.id.btn_save)
        btnCancel = findViewById(R.id.btn_cancel)

        // Configurar spinner
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, categories)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinnerCategory.adapter = adapter

        // Configurar botones
        btnSave.setOnClickListener { saveExpense() }
        btnCancel.setOnClickListener { finish() }
    }

    private fun saveExpense() {
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

        // Guardar en SharedPreferences (para que Flutter lo lea)
        val prefs: SharedPreferences = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val editor = prefs.edit()

        // Crear ID único para el gasto
        val expenseId = UUID.randomUUID().toString()
        val currentDate = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(Date())

        // Guardar datos del gasto
        editor.putString("expense_${expenseId}_name", name)
        editor.putString("expense_${expenseId}_amount", amount.toString())
        editor.putString("expense_${expenseId}_category", category)
        editor.putString("expense_${expenseId}_date", currentDate)
        editor.putString("expense_${expenseId}_type", "expense") // o "income"
        editor.apply()

        // Notificar a Flutter (opcional - puedes usar un BroadcastReceiver)
        val intent = Intent("com.example.track_expenses.EXPENSE_ADDED")
        sendBroadcast(intent)

        // Mostrar mensaje y cerrar
        Toast.makeText(this, "Gasto guardado correctamente", Toast.LENGTH_SHORT).show()
        finish()
    }
}