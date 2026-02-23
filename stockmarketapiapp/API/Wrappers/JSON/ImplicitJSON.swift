//
//  ImplicitJSON.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 2/23/26.
//


//
//  ImplicitJSON.swift
//  ImplicitJSON
//

import SwiftUI


// this json reader solution is intentionally made to silently fail.
// if something goes wrong, the earliest error message is passed around, and can be seen via the .value and .succeeded variables


struct ImplicitJSON {
    var json : String
    var jsonData : Data
    var jsonObject : NSDictionary?
    var success : Bool = false
    
    // too annoying to make optional
    var failMessage : String = ""
    
    // error messages
    static let jsonDataConversionError = "Error converting JSON string to data in ImplicitJSON initializer"
    
    
    init(json: String) {
        self.json = json
        
        // easy way to convert it to data
        //jsonData = json.data(using: .utf8) ?? ImplicitJSON.jsonDataConversionError
        if let a = json.data(using: .utf8) {
            jsonData = a
        } else {
            failMessage = ImplicitJSON.jsonDataConversionError
            jsonData = ImplicitJSON.jsonDataConversionError.data(using: .utf8)!
        }
        
        
        if let a = try? JSONSerialization.jsonObject(with: jsonData) as? NSDictionary {
            jsonObject = a
        } else {
            // uhh return idk
            failMessage = "Failed to serialize JSON Object, could not cast to NSDictionary."
            
            return
        }
        
        
        success = true
    }
    
    
    func index(key: String) -> JSONValue {
        if !success {
            return JSONValue(
                value: failMessage,
                succeeded: false
            )
        }
        
        // maybe make this an error actually
        if (jsonObject == nil) {
            return JSONValue(value: "nil")
        }
        
        if let val = jsonObject?.value(forKey: key) {
            return JSONValue(value: val)
        }
        
        return JSONValue(value: "Failed to index key: \(key). Does this value exist?", succeeded: false)
    }
}

struct JSONValue {
    var value : Any
    var succeeded : Bool
    
    init(value: Any) {
        self.value = value
        succeeded = true
    }
    
    init(value: Any, succeeded: Bool) {
        self.value = value
        self.succeeded = succeeded
    }
    
    
    // index
    
    func index(key: String) -> JSONValue {
        if !succeeded {
            return JSONValue(
                value: value,
                succeeded: false
            )
        }
        
        if value is NSDictionary {
            if let val = (value as! NSDictionary).value(forKey: key) {
                return JSONValue(value: val)
            }
            
            return JSONValue(value: "Could not index \(key). Does this key and value exist?")
        }
        
        return JSONValue(value: "Failed to index key: \(key). Does this value exist?", succeeded: false)
    }
    
    
    
    // the method:
    
    func getValueAsString() -> String {
        return "\(value)"
    }
    
    // Returns the value (or error message) 
    func getValue() -> Any {
        return value
    }
    
    // Returns nil if something went wrong at any time while reading the data.
    // Useful in cases where you'll have default/backup values.
    func requestValue() -> Any? {
        if (succeeded == false) {
            return nil
        }
        
        return value
    }
    
    
}