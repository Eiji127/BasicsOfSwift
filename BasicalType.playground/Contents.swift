// MARK: - 論理演算

// 1. 論理積
func indicateIntersection() {
    let a = false && false // false
    let b = false && true // false
    let c = true && false // false
    let d = true && true // true
    print(a, b, c, d)
}

indicateIntersection()

// 2. 論理和
func indicateDisjunction() {
    let a = false || false // false
    let b = false || true // true
    let c = true || false // true
    let d = true || true // true
    print(a, b, c, d)
}

indicateDisjunction()

// MARK: - 数値型

// 1. 浮動小数点型
func indicateFloatingPointType() {
    let a: Double = 12345678.9 // 12345678.9
    let b: Float = 12345678.9 // 1.234568e+07
    print(a, b) // 12345678.9 12345679.0
}

indicateFloatingPointType()

/*
 [Point]
 ・Float型とDouble型はCocoaでは用途によって使い分ける
 ・
 */

// MARK: -


// MARK: -

// MARK: -

// MARK: -

// MARK: -


// MARK: -


// MARK: -
