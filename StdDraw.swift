//
//  StdDraw.swift
//  StdDraw
//
//  Created by baize.qs on 2022/1/28.
//

import CoreGraphics
import Foundation
import CoreText

class StdDraw {
    enum TextAnchorHorizontalPosition: Int {
        case center = 0
        case left
        case right
    }
    
    private struct Constants {
        static let defaultSize = 512
        
        static let defaultPenColor = Colors.black
        static let defaultClearColor = Colors.white
        
        static let defaultPenRadius = 0.002
        
        static let border = 0.00
        static let defaultScaleMin = 0.0
        static let defaultScaleMax = 1.0
        
        static let defaultFontName = "PingFangSC-Regular"
        static let defaultFontSize = 16.0
        
        static let defaultDeviceScale = 2
    }
    
    struct Colors {
        static let black        = CGColor(gray: 0, alpha: 1)
        static let blue         = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        static let cyan         = CGColor(srgbRed: 0, green: 1, blue: 1, alpha: 1)
        static let darkGray     = CGColor(gray: 0.333, alpha: 1)
        static let gray         = CGColor(gray: 0.5, alpha: 1)
        static let green        = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
        static let lightGray    = CGColor(gray: 0.667, alpha: 1)
        static let magenta      = CGColor(srgbRed: 1, green: 0, blue: 1, alpha: 1)
        static let orange       = CGColor(srgbRed: 1, green: 0.5, blue: 0, alpha: 1)
        static let pink         = CGColor(srgbRed: 1, green: 192.0 / 255, blue: 203.0 / 255, alpha: 1)
        static let red          = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        static let white        = CGColor(gray: 1, alpha: 1)
        static let yellow       = CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1)
        
        static let bookBlue = CGColor(srgbRed: 9.0 / 255, green: 90.0 / 255, blue: 166.0 / 255, alpha: 1)
        static let bookLightBlue = CGColor(srgbRed: 103.0 / 255, green: 198.0 / 255, blue: 243.0 / 255, alpha: 1)
        static let bookRed = CGColor(srgbRed: 150.0 / 255, green: 35.0 / 255, blue: 31.0 / 255, alpha: 1)
        static let princetonOrange = CGColor(srgbRed: 245.0 / 255, green: 128.0 / 255, blue: 37.0 / 255, alpha: 1)
    }
    
    private var width: Int
    private var height: Int
    
    private var penColor = Constants.defaultPenColor
    private var penRadius = Constants.defaultPenRadius
    
    private var xmin = Constants.defaultScaleMin
    private var ymin = Constants.defaultScaleMin
    private var xmax = Constants.defaultScaleMax
    private var ymax = Constants.defaultScaleMax
    
    private var font: CTFont {
        get {
            let descriptor = CTFontDescriptorCreateWithNameAndSize(fontName as CFString, scaledFontSize)
            let font = CTFontCreateWithFontDescriptor(descriptor, scaledFontSize, nil)
            return font
        }
    }
    
    private var fontName = Constants.defaultFontName
    private var fontSize = Constants.defaultFontSize
    private var scaledFontSize: Double {
        return fontSize * deviceScale
    }
    
    private var deviceScale: Double
    
    private var context: CGContext
    
    init?(width: Int = Constants.defaultSize, height: Int = Constants.defaultSize, deviceScale: Int = Constants.defaultDeviceScale) {
        self.width = width
        self.height = height
        self.deviceScale = Double(deviceScale)
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        
        if let _context = CGContext(data: nil, width: width * deviceScale, height: height * deviceScale, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo) {
            context = _context
        } else {
            return nil
        }
        
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
    }
    
    func setXscale(min: Double = Constants.defaultScaleMin, max: Double = Constants.defaultScaleMax) {
        let size = max - min
        xmin = min - Constants.border * size
        xmax = max + Constants.border * size
    }
    
    func setYscale(min: Double = Constants.defaultScaleMin, max: Double = Constants.defaultScaleMax) {
        let size = max - min
        ymin = min - Constants.border * size
        ymax = max + Constants.border * size
    }
    
    func setScale(min: Double = Constants.defaultScaleMin, max: Double = Constants.defaultScaleMax) {
        setXscale(min: min, max: max)
        setYscale(min: min, max: max)
    }
    
    private func scaleX(x: Double) -> Double {
        return Double(width) * deviceScale * (x - xmin) / (xmax - xmin)
    }
    
    private func scaleY(y: Double) -> Double {
        return Double(height) * deviceScale * (y - ymin) / (ymax - ymin)
    }
    
    private func factorX(w: Double) -> Double {
        return w * Double(width) * deviceScale / abs(xmax - xmin)
    }
    
    private func factorY(h: Double) -> Double {
        return h * Double(height) * deviceScale / abs(ymax - ymin)
    }
    
    func clear(color: CGColor = Constants.defaultClearColor) {
        context.setFillColor(color)
        context.fill(CGRect(x: 0, y: 0, width: scaleX(x: Double(width)), height: scaleY(y: Double(height))))
    }
    
    func setPenRadius(_ radius: Double = Constants.defaultPenRadius) {
        penRadius = radius
        let scaledPenRadius = radius * Double(Constants.defaultSize)
        context.setLineWidth(scaledPenRadius)
        context.setLineCap(.round)
        context.setLineJoin(.round)
    }
    
    func setPenColor(color: CGColor = Constants.defaultPenColor) {
        penColor = color
        context.setStrokeColor(color)
    }
    
    func setPenColor(red: Int, green: Int, blue: Int) {
        setPenColor(color: CGColor(srgbRed: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue / 255), alpha: 1))
    }
    
    func setFont(fontName: String = Constants.defaultFontName, size: CGFloat = Constants.defaultFontSize) {
        self.fontName = fontName
        self.fontSize = size
    }
    
    func line(x0: Double, y0: Double, x1: Double, y1: Double) {
        let xs0 = scaleX(x: x0)
        let ys0 = scaleY(y: y0)
        let xs1 = scaleX(x: x1)
        let ys1 = scaleY(y: y1)
        context.strokeLineSegments(between: [CGPoint(x: xs0, y: ys0), CGPoint(x: xs1, y: ys1)])
    }
    
    private func pixel(x: Double, y: Double) {
        context.setFillColor(penColor)
        context.fill(CGRect(x: round(scaleX(x: x)), y: scaleY(y: y), width: 1 * deviceScale, height: 1 * deviceScale))
    }
    
    func point(x: Double, y: Double) {
        let scaledPenRadius = penRadius * Double(Constants.defaultSize)
        
        if scaledPenRadius <= 1 {
            pixel(x: x, y: y)
        } else {
            let xs = scaleX(x: x)
            let ys = scaleY(y: y)
            
            context.setFillColor(penColor)
            context.fillEllipse(in: CGRect(x: xs - scaledPenRadius, y: ys - scaledPenRadius, width: scaledPenRadius * 2, height: scaledPenRadius * 2))
        }
    }
    
    func circle(x: Double, y: Double, radius: Double, filled: Bool = false) {
        let xs = scaleX(x: x)
        let ys = scaleY(y: y)
        let ws = factorX(w: 2 * radius)
        let hs = factorY(h: 2 * radius)
        
        if ws <= 1 && hs <= 1 {
            pixel(x: x, y: y)
        } else {
            let color = penColor
            let rect = CGRect(x: xs - ws / 2, y: ys - hs / 2, width: ws, height: hs)
            
            
            if filled {
                context.setFillColor(color)
                context.fillEllipse(in: rect)
            } else {
                context.setStrokeColor(color)
                context.strokeEllipse(in: rect)
            }
        }
    }
    
    func ellipse(x: Double, y: Double, semiMajorAxis: Double, semiMinorAxis: Double, filled: Bool = false) {
        let xs = scaleX(x: x)
        let ys = scaleY(y: y)
        let ws = factorX(w: semiMajorAxis * 2)
        let hs = factorY(h: semiMinorAxis * 2)
        
        if ws <= 1 && hs <= 1 {
            pixel(x: x, y: y)
        } else {
            let color = penColor
            let rect = CGRect(x: xs - ws / 2, y: ys - hs / 2, width: ws, height: hs)
            
            if filled {
                context.setFillColor(color)
                context.fillEllipse(in: rect)
            } else {
                context.setStrokeColor(color)
                context.strokeEllipse(in: rect)
            }
        }
    }
    
    func arc(x: Double, y: Double, radius: Double, startAngle: Double, endAngle: Double) {
        let ws = factorX(w: 2 * radius)
        let hs = factorY(h: 2 * radius)
        
        if ws <= 1 && hs <= 1 {
            pixel(x: x, y: y)
        } else {
            var ea = endAngle
            while ea < startAngle {
                ea += 360
            }
            
            let xs = scaleX(x: x)
            let ys = scaleY(y: y)
            
            let center = CGPoint(x: xs, y: ys)
            
            context.saveGState()
            context.beginPath()
            
            context.move(to: center)
            context.addArc(center: center, radius: CGFloat(max(width, height)), startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.addLine(to: center)
            context.closePath()
            context.clip()
            
            context.setStrokeColor(penColor)
            context.strokeEllipse(in: CGRect(x: xs - ws / 2, y: ys - hs / 2, width: ws, height: hs))
            
            context.restoreGState()
        }
    }
    
    func square(x: Double, y: Double, halfLength: Double, filled: Bool = false) {
        let xs = scaleX(x: x)
        let ys = scaleY(y: y)
        let ws = factorX(w: 2 * halfLength)
        let hs = factorY(h: 2 * halfLength)
        
        if ws <= 1 && hs <= 1 {
            pixel(x: x, y: y)
        } else {
            context.beginPath()
            context.addRect(CGRect(x: xs - ws / 2, y: ys - hs / 2, width: ws, height: hs))
            
            if filled {
                context.setFillColor(penColor)
                context.fillPath()
            } else {
                context.setStrokeColor(penColor)
                context.strokePath()
            }
        }
    }
    
    func rectangle(x: Double, y: Double, halfWidth: Double, halfHeight: Double, filled: Bool = false) {
        let xs = scaleX(x: x)
        let ys = scaleY(y: y)
        let ws = factorX(w: 2 * halfWidth)
        let hs = factorY(h: 2 * halfHeight)
        
        if ws <= 1 && hs <= 1 {
            pixel(x: x, y: y)
        } else {
            context.beginPath()
            context.addRect(CGRect(x: xs - ws / 2, y: ys - hs / 2, width: ws, height: hs))
            
            if filled {
                context.setFillColor(penColor)
                context.fillPath()
            } else {
                context.setStrokeColor(penColor)
                context.strokePath()
            }
        }
    }
    
    func polygon(x: [Double], y: [Double], filled: Bool = false) {
        let n1 = x.count
        let n2 = y.count
        
        if n1 != n2 || n1 == 0 {
            return
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: scaleX(x: x[0]), y: scaleY(y: y[0])))
        
        for i in 1..<x.count {
            context.addLine(to: CGPoint(x: scaleX(x: x[i]), y: scaleY(y: y[i])))
        }
        
        context.closePath()
        
        if filled {
            context.setFillColor(penColor)
            context.fillPath()
        } else {
            context.setStrokeColor(penColor)
            context.strokePath()
        }
    }
    
    func text(x: Double, y: Double, text: String, anchorHorizontalPosition: TextAnchorHorizontalPosition = .center, degrees: Double = 0) {
        let xs = scaleX(x: x)
        let ys = scaleY(y: y)
        
        let content = text as CFString
        let attributes = [
            kCTFontNameAttribute as String: font,
            kCTForegroundColorAttributeName as String: penColor
        ] as CFDictionary
        let attrString = CFAttributedStringCreate(kCFAllocatorDefault, content, attributes)
        let line = CTLineCreateWithAttributedString(attrString!)
        let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions(rawValue: 0))
        
        var offX = lineBounds.size.width / 2
        if anchorHorizontalPosition == .left {
            offX = 0
        } else if anchorHorizontalPosition == .right {
            offX = lineBounds.size.width
        }
        
        let offY = 0.0
        
        let tx = xs - offX
        let ty = ys - offY
        
        var t = CGAffineTransform.identity
        t = t.concatenating(CGAffineTransform(translationX: -xs, y: -ys))
        t = t.concatenating(CGAffineTransform(rotationAngle: degrees * .pi / 180))
        t = t.concatenating(CGAffineTransform(translationX: xs, y: ys))
        
        context.saveGState()
        
        context.concatenate(t)
        context.textPosition = CGPoint(x: tx, y: ty)
        CTLineDraw(line, context)
        
        context.restoreGState()
    }
    
    func result() -> CGImage? {
        guard let image = context.makeImage() else {
            return nil
        }
        
        return image
    }
}
