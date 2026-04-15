//
//  CountryDetailView.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 2/20/26.
//

import SwiftUI
import MapKit

struct CountryDetailView: View {
    
    var countryCode: String
    @State var countryData: NSDictionary? = nil
    
    // region for the map
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    
    // capital location pin
    @State var capitalCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Country Information")
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    loadCountry()
                }) {
                    Text("Load Country Info")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if let data = countryData {
                    
                    Text(getFlag(data))
                        .font(.system(size: 80))
                    
                    // basics of a country
                    Text("Essentials")
                        .font(.title2)
                        .bold()
                    
                    infoBox(title: "Official Name", value: getOfficialName(data))
                    infoBox(title: "Capital City", value: getCapital(data))
                    infoBox(title: "Currency", value: getCurrency(data))
                    
                    // land and ppl
                    Text("Geography & People")
                        .font(.title2)
                        .bold()
                    
                    infoBox(title: "Region", value: getRegion(data))
                    infoBox(title: "Subregion", value: getSubregion(data))
                    infoBox(title: "Population", value: getPopulation(data))
                    infoBox(title: "Area (km²)", value: getArea(data))
                    infoBox(title: "Languages", value: getLanguages(data))
                    
                    // government
                    Text("Government & Status")
                        .font(.title2)
                        .bold()
                    
                    infoBox(title: "Independent", value: getIndependent(data))
                    infoBox(title: "Timezones", value: getTimezones(data))
                    
                    // map section
                    Text("Location")
                        .font(.title2)
                        .bold()
                    
                    // gets and puts a red dot on capital to see where the country is that and its capital
                    Map(coordinateRegion: $region, annotationItems: [CapitalPlace(coordinate: capitalCoordinate)]) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 10))
                        }
                    }
                    .frame(height: 250)
                    .cornerRadius(10)
                    
                }
                else {
                    Text("No data loaded")
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // loading a country
    // calls the API service and loads country data
    // after 1 second, it updates countryData
    // updating countryData refreshes the UI
    func loadCountry() {
        CountryService().loadCountry(countryCode: countryCode.uppercased())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.countryData = CountryService.countryData
            
            // update map coordinates
            if let data = countryData,
               let capitalInfo = data["capitalInfo"] as? NSDictionary,
               let coords = capitalInfo["latlng"] as? [Double],
               coords.count == 2 {
                
                capitalCoordinate = CLLocationCoordinate2D(
                    latitude: coords[0],
                    longitude: coords[1]
                )
                
                region.center = capitalCoordinate
                
                region.span = MKCoordinateSpan(
                    latitudeDelta: 3,
                    longitudeDelta: 3
                )
            }
        }
    }
    
    // struct for capital pin
    struct CapitalPlace: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    // infobox which helps alot
    // creates a reusable styled box for displaying the information
    // instead of repeating design code many times
    // we reuse this function to keep everything clean
    func infoBox(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    // getting information and returning it
    // each function extracts a specific piece of data
    // from the JSON dictionary safely
    // this keeps everything clean and separates logic from layout
    
    func getFlag(_ data: NSDictionary) -> String {
        if let flag = data["flag"] as? String {
            return flag
        }
        return ""
    }
    
    func getOfficialName(_ data: NSDictionary) -> String {
        if let name = data["name"] as? NSDictionary {
            return name["official"] as? String ?? "N/A"
        }
        return "N/A"
    }
    
    func getCapital(_ data: NSDictionary) -> String {
        if let capitals = data["capital"] as? [String], capitals.count > 0 {
            return capitals[0]
        }
        return "N/A"
    }
    
    func getRegion(_ data: NSDictionary) -> String {
        return data["region"] as? String ?? "N/A"
    }
    
    func getSubregion(_ data: NSDictionary) -> String {
        return data["subregion"] as? String ?? "N/A"
    }
    
    func getPopulation(_ data: NSDictionary) -> String {
        if let pop = data["population"] as? Int {
            return String(pop)
        }
        return "N/A"
    }
    
    func getArea(_ data: NSDictionary) -> String {
        if let area = data["area"] as? Double {
            return String(area)
        }
        return "N/A"
    }
    
    func getCurrency(_ data: NSDictionary) -> String {
        if let currencies = data["currencies"] as? NSDictionary {
            for (_, value) in currencies {
                if let obj = value as? NSDictionary {
                    return obj["name"] as? String ?? "N/A"
                }
            }
        }
        return "N/A"
    }
    
    func getLanguages(_ data: NSDictionary) -> String {
        if let languages = data["languages"] as? NSDictionary {
            
            var list: [String] = []
            
            for (_, value) in languages {
                if let lang = value as? String {
                    list.append(lang)
                }
            }
            
            return list.joined(separator: ", ")
        }
        return "N/A"
    }
    
    func getIndependent(_ data: NSDictionary) -> String {
        if let independent = data["independent"] as? Bool {
            return independent ? "Yes" : "No"
        }
        return "N/A"
    }
    
    func getTimezones(_ data: NSDictionary) -> String {
        if let zones = data["timezones"] as? [String], zones.count > 0 {
            return zones.joined(separator: ", ")
        }
        return "N/A"
    }
}
