import java.io.File

fun main() {
    // val inputStream = File("input.txt").inputStream()
    // val outputStream = File("output.txt").outputStream()
}
 
fun getNumbers(): List<Long> {
    var input = (readLine()!!).split(' ')
    return input.map{it.toLong()}
}

fun getStrings(): List<String> {
    return (readLine()!!).split(' ')
}
 
fun getNumber(): Long {
    return (readLine()!!).toLong()
}
