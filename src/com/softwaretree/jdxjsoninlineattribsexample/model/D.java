package com.softwaretree.jdxjsoninlineattribsexample.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.softwaretree.jdx.JDX_JSONObject;

/**
 * A shell (container) class parallel to a domain model object class for objects of type D 
 * based on the class JSONObject.  This class needs to define just two constructors.
 * Most of the processing is handled by the superclass JDX_JSONObject.
 * <p> 
 * @author Damodar Periwal
 *
 */
public class D extends JDX_JSONObject {

    public D() {
        super();
    }

    public D(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
    
    // The following attribute (dE) is defined to mimic the underlying JSON object structure and 
    // are used for defining the JDX ORM specification. There is no need to define their setters/getters.

    public E dE;   // dE is an object of type E that is contained in a D object

}
