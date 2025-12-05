//
//  ContentView.swift
//  RippleView
//
//  Created by Lara Aksoy on 4.12.2025.
//

import SwiftUI
import SwiftData

import SwiftUI

struct Ripple: Identifiable {
    let id = UUID()
    let point: CGPoint
    let createdAt = Date()
}

struct RippleView: View {
    let point: CGPoint
    // local state for animation
    @State private var animate = false
    var body: some View {
        Circle()
            .stroke(lineWidth: 4)
            .frame(width: animate ? 120 : 16, height: animate ? 120 : 16)
            .opacity(animate ? 0 : 0.9)
            .position(point)
            .onAppear {
                // animate expansion + fade-out
                withAnimation(.easeOut(duration: 0.8)) {
                    animate = true
                }
            }
    }
}

struct ContentView: View {
    @State private var ripples: [Ripple] = []
    // throttle: son ekleme zamanı
    @State private var lastAdded: Date = Date.distantPast

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Arka planınız veya içerik (örnek)
                LinearGradient(gradient: Gradient(colors: [.black, .orange]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                // İçerik üstüne ripple'ları çiz
                ForEach(ripples) { r in
                    RippleView(point: r.point)
                        .onAppear {
                            // cleanup her ripple için: animasyon süresi kadar sonra sil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                                ripples.removeAll { $0.id == r.id }
                            }
                        }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        // throttle ekliyoruz: çok sık eklemeyi önlemek için (örnek: 40 ms)
                        let now = Date()
                        if now.timeIntervalSince(lastAdded) > 0.04 {
                            lastAdded = now
                            let loc = value.location
                            // sınırlandırmak isterseniz geo frame içine clamp edin
                            ripples.append(Ripple(point: loc))
                            // isteğe bağlı: ripples.count kontrolü ile pool büyüklüğünü sınırlayın
                            if ripples.count > 80 {
                                ripples.removeFirst(ripples.count - 80)
                            }
                        }
                    }
                    .onEnded { _ in
                        // isteğe bağlı: sürükleme bittiğinde hızlı temizleme veya başka bir efekt
                    }
            )
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
