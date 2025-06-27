import Foundation

struct Prime {
    /// Checks if a number is prime
    /// - Parameter number: The number to check
    /// - Returns: True if the number is prime, false otherwise
    static func isPrime(_ number: Int) -> Bool {
        if number <= 1 {
            return false
        }
        if number <= 3 {
            return true
        }
        if number % 2 == 0 || number % 3 == 0 {
            return false
        }
        
        var i = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
    
    /// Finds the nth prime number
    /// - Parameter n: The position of the prime number to find (1-based)
    /// - Returns: The nth prime number
    static func nth(_ n: Int) -> Int {
        if n <= 0 {
            return -1
        }
        
        var count = 0
        var number = 2
        
        while true {
            if isPrime(number) {
                count += 1
                if count == n {
                    return number
                }
            }
            number += 1
        }
    }
    
    /// Gets all prime numbers up to a given limit
    /// - Parameter limit: The upper limit to find primes up to
    /// - Returns: Array of prime numbers up to the limit
    static func primesUpTo(_ limit: Int) -> [Int] {
        guard limit >= 2 else { return [] }
        
        var numbers = Array(repeating: true, count: limit + 1)
        numbers[0] = false
        numbers[1] = false
        
        for i in 2...Int(Double(limit).squareRoot()) {
            if numbers[i] {
                for j in stride(from: i * i, through: limit, by: i) {
                    numbers[j] = false
                }
            }
        }
        
        return numbers.enumerated().compactMap { index, isPrime in
            isPrime ? index : nil
        }
    }
} 