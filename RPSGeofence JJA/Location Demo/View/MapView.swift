import SwiftUI
import MapKit

struct MapView: View {
    // Define POI class
    class POI: NSObject, MKAnnotation, Identifiable {
        let id = UUID() // Provide an identifier for each annotation
        let title: String?
        let coordinate: CLLocationCoordinate2D

        init(title: String?, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }
    
    // Map of category names to their respective colors
    let categoryColors: [String: Color] = [
        "Administration": .red,
        "Athletics": .orange,
        "Lower School": .cyan,
        "Upper School": Color(red: 0, green: 0, blue: 0.5), // Darkest blue
        "Pre-K": Color(red: 0.7, green: 0.7, blue: 1.0), // Light blue
        "Parking": .purple,
        "Shared": Color(red: 0, green: 0, blue: 0.5) // Assuming the same blue as Upper and Lower School
    ]
    
    // Annotations arrays
    let annotationsAdministration = [
        POI(title: "Elm Farm", coordinate: CLLocationCoordinate2D(latitude: 40.5266114675831, longitude: -74.49484615914133)),
        POI(title: "Ms. Bautista Burk", coordinate: CLLocationCoordinate2D(latitude: 40.52549864307898, longitude: -74.49528739435694)),
    ]
    
    let annotationsUpperSchool = [
        POI(title: "LC Building", coordinate: CLLocationCoordinate2D(latitude: 40.526477584345336, longitude: -74.49575110793025)),
        POI(title: "100s & 200s Classrooms", coordinate: CLLocationCoordinate2D(latitude: 40.52574918796507, longitude: -74.49545133133232)),
        POI(title: "Science Classrooms & Labs", coordinate: CLLocationCoordinate2D(latitude: 40.52544886409003, longitude: -74.49551182580761)),
        POI(title: "Lounges", coordinate: CLLocationCoordinate2D(latitude: 40.52551564923057, longitude: -74.4951866880565)),
        POI(title: "Science Rotunda", coordinate: CLLocationCoordinate2D(latitude: 40.52578581046838, longitude: -74.4946002699422)),
        POI(title: "Art Building", coordinate: CLLocationCoordinate2D(latitude: 40.526929891691324, longitude: -74.49486204003054)),
        POI(title: "LC Building", coordinate: CLLocationCoordinate2D(latitude: 40.526477584345336, longitude: -74.49575110793025)),
    ]
    
    let annotationsLowerSchool = [
        POI(title: "Lower School Building 2", coordinate: CLLocationCoordinate2D(latitude: 40.52597977426216, longitude: -74.49441491004708)),
        POI(title: "Lower School Playground", coordinate: CLLocationCoordinate2D(latitude: 40.525778660281595, longitude: -74.49416223282958)),
        POI(title: "Lower School Parking Lot", coordinate: CLLocationCoordinate2D(latitude: 40.52515957120931, longitude: -74.49403898338379)),
        POI(title: "Lower School", coordinate: CLLocationCoordinate2D(latitude: 40.52539857458023, longitude: -74.49431921272304)),
        POI(title: "Lower School Playground", coordinate: CLLocationCoordinate2D(latitude: 40.5267812766059, longitude: -74.49526247127407)),
    ]
    
    let annotationsPreK = [
        POI(title: "Early Childhood Center", coordinate: CLLocationCoordinate2D(latitude: 40.52638435760687, longitude: -74.49524074430474)),
    ]
    
    let annotationsShared = [
        POI(title: "Library", coordinate: CLLocationCoordinate2D(latitude: 40.52546136509074, longitude: -74.49493844069052)),
        POI(title: "Dining Commons", coordinate: CLLocationCoordinate2D(latitude: 40.52652646226053, longitude: -74.49546784889039)),
        POI(title: "Upper Gym", coordinate: CLLocationCoordinate2D(latitude: 40.52444783297784, longitude: -74.49518879018342)),
        POI(title: "Lower Gym", coordinate: CLLocationCoordinate2D(latitude: 40.524613216279434, longitude: -74.49478606857105)),
        POI(title: "Dining Commons", coordinate: CLLocationCoordinate2D(latitude: 40.52652646226053, longitude: -74.49546784889039)),
    ]
    
    let annotationsParking = [
        POI(title: "Senior Parking Lot", coordinate: CLLocationCoordinate2D(latitude: 40.52669283126312, longitude: -74.49705297541401)),
        POI(title: "Parents and Teachers Parking Lot", coordinate: CLLocationCoordinate2D(latitude: 40.52544553138436, longitude: -74.49619643988311)),
        POI(title: "Visitors Parking Lot", coordinate: CLLocationCoordinate2D(latitude: 40.52511649928172, longitude: -74.49541189178612)),
    ]
    
    let annotationsAthletics = [
        POI(title: "Lower Soccer Field", coordinate: CLLocationCoordinate2D(latitude: 40.52756118519681, longitude: -74.49579238739997)),
        POI(title: "Upper Soccer Field", coordinate: CLLocationCoordinate2D(latitude: 40.52709075148023, longitude: -74.49647730246204)),
        POI(title: "Tennis Courts", coordinate: CLLocationCoordinate2D(latitude: 40.52856357679404, longitude: -74.49703989102626)),
        POI(title: "Baseball Fields", coordinate: CLLocationCoordinate2D(latitude: 40.52378494705343, longitude: -74.4942636854682)),
        POI(title: "Right Side Soccer Field", coordinate: CLLocationCoordinate2D(latitude: 40.524208977646445, longitude: -74.49347759263036)),
    ]
    
    @State private var delta: Double = 0.005 // Initial value for delta
    @State private var selectedCategories: Set<String> = ["Shared"] // Selected categories
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 40.526053, longitude: -74.495094),
                span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            )), showsUserLocation: true, annotationItems: selectedAnnotations()) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    // Annotation view
                    VStack {
                        Image(systemName: "mappin")
                            .foregroundColor(pinColor(for: annotation.title ?? ""))
                        Text(annotation.title ?? "")
                            .foregroundColor(textColor(for: annotation.title ?? ""))
                            .font(.custom("Avenir", size: 12))
                    }
                    .onTapGesture {
                        openMapsForDirections(to: annotation.coordinate)
                    }
                }
            }
            .ignoresSafeArea(.all)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(annotationsCategories, id: \.self) { category in
                            Button(action: {
                                toggleCategory(category)
                            }) {
                                Text(category)
                                    .padding()
                                    .foregroundColor(selectedCategories.contains(category) ? Color.white : (categoryColors[category] ?? .black) .opacity(1))
                                    .background(
                                        ZStack {
                                            if !selectedCategories.contains(category) {
//                                                VisualEffectBlur(blurStyle: .systemMaterial)
//                                                    .cornerRadius(10)
//                                                    .opacity(0.25)
//                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                Rectangle()
                                                    .foregroundColor(.white.opacity(0.2))
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            } else {
                                                (categoryColors[category] ?? .black).opacity(0.8) // Change to color of category
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            }
                                        }
                                    )
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
    
    struct VisualEffectBlur: UIViewRepresentable {
        /// The style of the blur effect.
        var blurStyle: UIBlurEffect.Style

        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    }
    
    private func selectedAnnotations() -> [POI] {
        var selectedAnnotations: [POI] = []
        for category in selectedCategories {
            selectedAnnotations.append(contentsOf: annotations(for: category))
        }
        return selectedAnnotations
    }
    
    private func annotations(for category: String) -> [POI] {
        switch category {
        case "Administration":
            return annotationsAdministration
        case "Upper School":
            return annotationsUpperSchool
        case "Lower School":
            return annotationsLowerSchool
        case "Pre-K":
            return annotationsPreK
        case "Shared":
            return annotationsShared
        case "Parking":
            return annotationsParking
        case "Athletics":
            return annotationsAthletics
        default:
            return []
        }
    }
    
    private func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    private func openMapsForDirections(to coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    // Get the list of categories
    private var annotationsCategories: [String] {
        let categories: [String] = ["Athletics", "Parking", "Administration", "Upper School", "Lower School", "Pre-K", "Shared"]
        return categories
    }
    
    // Function to get pin color based on category
    // TODO: REWRITE!!!! THIS IS THE SHITTIEST CODE IVE EVER WRITTEN
    private func pinColor(for category: String) -> Color {
        if annotationsAdministration.contains(where: { $0.title == category }) {
            return categoryColors["Administration"] ?? .black // Return category color if found
        }
        if annotationsUpperSchool.contains(where: { $0.title == category }) {
            return categoryColors["Upper School"] ?? .black // Return category color if found
        }
        if annotationsLowerSchool.contains(where: { $0.title == category }) {
            return categoryColors["Lower School"] ?? .black // Return category color if found
        }
        if annotationsPreK.contains(where: { $0.title == category }) {
            return categoryColors["Pre-K"] ?? .black // Return category color if found
        }
        if annotationsShared.contains(where: { $0.title == category }) {
            return categoryColors["Shared"] ?? .black // Return category color if found
        }
        if annotationsParking.contains(where: { $0.title == category }) {
            return categoryColors["Parking"] ?? .black // Return category color if found
        }
        if annotationsAthletics.contains(where: { $0.title == category }) {
            return categoryColors["Athletics"] ?? .black // Return category color if found
        }
        return .black // Default pin color if category not found
    }


    // Function to get text color based on category
    private func textColor(for category: String) -> Color {
        return pinColor(for: category) // Text color matches pin color
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
