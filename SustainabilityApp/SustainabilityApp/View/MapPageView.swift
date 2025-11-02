//
//  MapPageView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import SwiftUI
import MapKit

//struct MapPageView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629), // Center on India
//        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
//    )
//
//    @State private var friends: [FriendLocation] = [
//        FriendLocation(name: "Utkarsh", coordinate: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)), // Delhi
//        FriendLocation(name: "Riya", coordinate: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777)),   // Mumbai
//        FriendLocation(name: "Aarav", coordinate: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946))   // Bengaluru
//    ]
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            Map(
//                initialPosition: .region(
//                    MKCoordinateRegion(
//                        center: region.center,
//                        span: region.span
//                    )
//                )
//            ) {
//                ForEach(friends) { friend in
//                    Annotation(friend.name, coordinate: friend.coordinate) {
//                        VStack(spacing: 4) {
//                            Image(systemName: "person.circle.fill")
//                                .font(.system(size: 36))
//                                .foregroundColor(.blue)
//                            Text(friend.name)
//                                .font(.caption2)
//                                .foregroundColor(.primary)
//                        }
//                    }
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//            
//            // Search Bar UI mock (non-functional)
//            HStack {
//                Image(systemName: "magnifyingglass")
//                Text("Around me")
//                    .fontWeight(.medium)
//                Spacer()
//                Image(systemName: "square.and.arrow.up")
//                Image(systemName: "location.fill")
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .padding(.horizontal)
//            .padding(.top, 12)
//            
//            // Bottom mock panel
//            VStack {
//                Spacer()
//                VStack(spacing: 10) {
//                    Capsule()
//                        .frame(width: 40, height: 4)
//                        .foregroundColor(.gray.opacity(0.4))
//                    
//                    HStack {
//                        Label("Accommodations", systemImage: "bed.double.fill")
//                            .padding(8)
//                            .background(Color.white)
//                            .clipShape(Capsule())
//                        
//                        Label("Tours", systemImage: "ticket.fill")
//                            .padding(8)
//                            .background(Color.white)
//                            .clipShape(Capsule())
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
//                    HStack {
//                        Text("Travelers at this place")
//                            .font(.headline)
//                        Spacer()
//                        Image(systemName: "chevron.right")
//                    }
//                    .padding(.horizontal)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 16) {
//                            ForEach(friends) { friend in
//                                VStack {
//                                    Image(systemName: "person.circle.fill")
//                                        .font(.system(size: 50))
//                                        .foregroundColor(.blue)
//                                    Text(friend.name)
//                                        .font(.caption)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//                .padding()
//                .background(.ultraThinMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 25))
//                .padding(.bottom, 8)
//            }
//        }
//    }
//}


// MARK: - MapPageView
struct MapPageView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
        span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
    )
    
    @State private var friends: [FriendLocation] = [
        FriendLocation(name: "Utkarsh", coordinate: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)),
        FriendLocation(name: "Riya",   coordinate: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946)),
        FriendLocation(name: "Aarav",  coordinate: CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777))
    ]
    
    // Search state
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State private var searchResults: [MKMapItem] = []
    @State private var searchTask: Task<Void, Never>? = nil
    private let searchService = MapSearchService()
    
    // UI state
    @State private var showResults = false
    @State private var selectedMapItem: MKMapItem? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            // Map
            Map(initialPosition: .region(region)) {
                ForEach(friends) { friend in
                    Annotation(friend.name, coordinate: friend.coordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.red)
                            Text(friend.name)
                                .font(.caption2)
                                .fixedSize()
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestPermission()
                locationManager.startUpdating()
            }
            .onReceive(locationManager.$lastLocation) { location in
                // center the map once on first location
                if let loc = location {
                    region.center = loc.coordinate
                }
            }
            
            // Top search area
            VStack(spacing: 8) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                        TextField("Search places, addresses...", text: $searchText, onEditingChanged: { editing in
                            withAnimation { showResults = editing || !searchText.isEmpty }
                        })
                        .submitLabel(.search)
                        .onSubmit {
                            Task { await performSearch() }
                        }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                withAnimation {
                                    searchText = ""
                                    searchResults.removeAll()
                                    showResults = false
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Button(action: {
                        // Recenter to user location if available
                        if let loc = locationManager.lastLocation {
                            withAnimation(.easeInOut) {
                                region.center = loc.coordinate
                                region.span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                            }
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Search results overlay
                if showResults {
                    resultsList
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Spacer()
            }
            
            // Bottom sheet mock (keeps your UI similar to screenshot)
            VStack {
                Spacer()
                bottomPanel
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            // Debounce manual: cancel previous task and start new short task
            searchTask?.cancel()
            if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                withAnimation { searchResults.removeAll(); showResults = false }
                return
            }
            // small debounce delay (300ms)
            isSearching = true
            let currentText = newValue
            searchTask = Task.detached(priority: .userInitiated) {
                try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
                await MainActor.run {
                    if Task.isCancelled { return }
                    Task {
                        await performSearch(for: currentText)
                    }
                }
            }
        }
    }
    
    // MARK: - Search logic
    @MainActor
    private func performSearch(for text: String? = nil) async {
        let q = (text ?? searchText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            withAnimation { self.searchResults.removeAll(); self.isSearching = false; self.showResults = false }
            return
        }
        isSearching = true
        do {
            let items = try await searchService.search(query: q, region: region)
            withAnimation {
                self.searchResults = items
                self.showResults = true
                self.isSearching = false
            }
        } catch {
            print("Search error:", error)
            withAnimation {
                self.searchResults = []
                self.isSearching = false
            }
        }
    }
    
    // MARK: - Results List View
    private var resultsList: some View {
        VStack(spacing: 0) {
            if isSearching {
                HStack {
                    ProgressView()
                    Text("Searching...")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(10)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(searchResults, id: \.self) { item in
                        Button(action: {
                            // center map + optionally add to pins
                            let coord = item.placemark.coordinate
                            withAnimation {
                                region.center = coord
                                region.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                // optionally add as friend pin
                                let title = item.name ?? (item.placemark.title ?? "Place")
                                friends.append(FriendLocation(name: title, coordinate: coord))
                                searchText = item.name ?? ""
                                searchResults.removeAll()
                                showResults = false
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name ?? item.placemark.title ?? "Unknown")
                                        .font(.subheadline).bold()
                                    Text(subtitle(for: item.placemark))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 6)
            }
            .frame(maxHeight: 240)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Bottom mock panel
    private var bottomPanel: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 60, height: 5)
                .foregroundColor(Color.gray.opacity(0.4))
            
            HStack(spacing: 12) {
                Label("Accommodations", systemImage: "bed.double.fill")
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Capsule())
                Label("Tours", systemImage: "ticket.fill")
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Capsule())
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text("Travelers at this place")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(friends) { friend in
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            Text(friend.name)
                                .font(.caption)
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.bottom, 8)
    }
    
    // Helper to create subtitle text
    private func subtitle(for placemark: MKPlacemark) -> String {
        var parts: [String] = []
        if let locality = placemark.locality { parts.append(locality) }
        if let admin = placemark.administrativeArea { parts.append(admin) }
        if let country = placemark.country { parts.append(country) }
        return parts.joined(separator: ", ")
    }
}


#Preview {
    MapPageView()
}
