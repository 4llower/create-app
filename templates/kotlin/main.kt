fun main() {
    var q = getInteger()
    while (q-- > 0) {
        val (n, k) = getIntegers()
        var binary = (readLine()!!).toCharArray()
        var zeroPrefix = 0
        var rest = k
        
        for (i in 0 until n.toInt()) {
        	if (binary[i] == '0') {
                if (rest >= i - zeroPrefix) {
                    rest -= (i - zeroPrefix)
                    zeroPrefix++
                } else {
                    break
                }
            }
        }
             
        var current = 0
        
        if (zeroPrefix > 0) {
            for (i in 0 until n.toInt()) {
                if (binary[i] == '0') {
                    if (current >= n) break;
                    var temp = binary[current]
                 
                    binary[current] = binary[i]
                    binary[i] = temp
                    zeroPrefix--
                    current++
                    if (zeroPrefix == 0) break
                }
            }
        }
        
        if (rest > 0 && current < n) {
            for (i in current until n.toInt()) {
                if (binary[i] == '0') {
                    if (i - rest >= 0) {
                        var temp = binary[(i - rest).toInt()]
                        binary[(i - rest).toInt()] = binary[i]
                        binary[i] = temp
                    }
                    break
                }
            }
        }
 
        println(binary)
    }
}
 
fun getIntegers(): List<Long> {
    var input = (readLine()!!).split(' ')
    return input.map{it.toLong()}
}
 
fun getInteger(): Long {
    return (readLine()!!).toLong()
}