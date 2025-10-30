> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari Relationships With INLINE Attributes Example

> **Demonstrates INLINE mapping for storing child object attributes in parent's table row (performance optimization)**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains an example showing how to use Gilhari's **INLINE mapping** feature, where attribute values of a contained (referenced) object are stored in the same database table row as the containing (referencing) object, providing performance benefits by eliminating joins.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_relationships_inline_attribs_example) that can run as a RESTful microservice (server) to persist app specific JSON objects with optimized storage.

This example can be used **standalone as a RESTful microservice** or optionally with the ORMCP Server.

**Related:**
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples) - Comprehensive list of examples

**Note:** This example is also included in the Gilhari SDK distribution. If you have the SDK installed, you can use it directly from the `examples/gilhari_relationships_inline_attribs_example` directory without cloning.

## Example Overview

The example showcases a JSON object model with two types of objects: **D** and **E**

**Object Model Overview:**
- **D**: Parent object that contains an E object stored INLINE
- **E**: Child object whose attributes are stored in the same table row as D (when contained by D)
- **Attributes**: 
  - D: dId (int), dString (string), dE (E object - stored INLINE)
  - E: eId (int), eString (string)
- **Database Tables**: 
  - D table: Contains columns for both D and E attributes (when E is part of D)
  - E table: Can store standalone E objects (not part of any D object)

### What Makes This Example Different?

This example demonstrates the **INLINE mapping** feature for performance optimization:

**INLINE Mapping Feature:**
- E object attributes are stored **in the same table row** as the D object that contains them
- **No separate table join required** when querying D objects with their E objects
- **Significant performance improvement** for one-to-one relationships
- Shallow queries (`deep=false`) **still return the INLINE E attributes** (unlike normal relationships)
- Standalone E objects can still be stored independently in the E table

**Key Benefits:**
- **Better query performance**: No joins needed to retrieve the complete D+E object
- **Simplified database schema**: Fewer tables and relationships to manage
- **Reduced database roundtrips**: Single query retrieves all data
- **Shallow query behavior**: INLINE attributes always retrieved, even with `deep=false`
- **Flexibility**: Can still have standalone E objects in separate table

**When to Use INLINE:**
- One-to-one relationships where child object is always accessed with parent
- Child object has few attributes (doesn't make parent table too wide)
- Performance is critical and join elimination is beneficial
- Child object is logically part of parent (tight coupling)

**Configuration:**
See `config/gilhari_relationships_inline_attribs_example.jdx` for how to configure INLINE mapping using the INLINE directive.

### D Object Structure (with contained E object)
```json
{
  "dId": 1,
  "dString": "dString_1",
  "dE": {
    "eId": 100,
    "eString": "eString_100"
  }
}
```

### Database Storage

**Without INLINE (normal approach):**
- D table: `dId`, `dString`
- E table: `eId`, `eString`, `dId` (foreign key)
- Requires JOIN to get D with E

**With INLINE (this example):**
- D table: `dId`, `dString`, `dE_eId`, `dE_eString` (E attributes stored inline)
- E table: `eId`, `eString` (for standalone E objects only)
- No JOIN needed to get D with E

### Path Expression Difference

**Important:** When using INLINE, path expressions use underscore notation:
```bash
# Normal relationship:
filter=jdxObject.dE.eId>100

# INLINE relationship:
filter=jdxObject.dE_eId>100  # Note: underscore instead of dot
```

## Project Structure

```
gilhari_relationships_inline_attribs_example/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...      # D.java, E.java
├── config/                        # Configuration files
│   ├── gilhari_relationships_inline_attribs_example.jdx  # ORM specification with INLINE
│   └── classnames_map_example.js
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommands.cmd / .sh         # API testing scripts
└── curlCommandsPopulate.cmd / .sh # Sample data population scripts
```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., D, E) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **D and E classes**: Simple shell (container) classes (.java files) corresponding to the domain-specific JSON object model classes of related entities (Container domain model classes)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_relationships_inline_attribs_example.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables, **including the INLINE mapping configuration**.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model classes (like D, E) corresponding to the conceptual domain-specific JSON object model classes are defined as subclasses of the JDX_JSONObject class
- Appropriate mappings for the domain-specific JSON object model classes are defined in the ORM specification file using the corresponding container domain model classes
- **INLINE mapping configuration** stores child object attributes in parent's table for performance optimization

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### INLINE Mapping Configuration

The key to this example is in the ORM specification file (`config/gilhari_relationships_inline_attribs_example.jdx`), where the relationship is configured using INLINE directive.

**Parent Class (D) with INLINE Relationship:**
```
CLASS .D TABLE D
    VIRTUAL_ATTRIB dId ATTRIB_TYPE int
    VIRTUAL_ATTRIB dString ATTRIB_TYPE java.lang.String
    
    PRIMARY_KEY dId  
    RELATIONSHIP dE REFERENCES .E INLINE AUTO_INSTANTIATE
    
    // If the referenced object dE could be null, we need to specify 
    // the corresponding attributes to be nullable in the underlying table
    SQLMAP FOR dE.eId NULLABLE
    SQLMAP FOR dE.eString NULLABLE
;
```

**Child Class (E) - Can be Stored INLINE or Standalone:**
```
CLASS .E TABLE E
    VIRTUAL_ATTRIB eId ATTRIB_TYPE int
    VIRTUAL_ATTRIB eString ATTRIB_TYPE java.lang.String
    
    PRIMARY_KEY eId 
;
```

**How it works:**
1. When a D object contains an E object, E's attributes are stored in D's table row
2. The E attributes become columns in the D table (e.g., `dE_eId`, `dE_eString`)
3. Querying D objects retrieves E attributes without joins
4. `AUTO_INSTANTIATE` automatically creates an empty E object if null
5. `NULLABLE` directives allow D objects without E objects
6. Standalone E objects can still be stored in the E table independently

**Performance Impact:**
- Eliminates JOIN operations for one-to-one relationships
- Reduces query complexity and execution time
- Particularly beneficial for frequently accessed parent-child pairs

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_relationships_inline_attribs_example",
  "jdx_orm_spec_file": "./config/gilhari_relationships_inline_attribs_example.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 5,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.js",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_relationships_inline_attribs_example) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)
If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker**
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/D
http://localhost:80/gilhari/v1/E
```

### Supported HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/D` |
| POST | Create objects | `POST /gilhari/v1/D` |
| PUT | Update objects | `PUT /gilhari/v1/D` |
| PATCH | Partial update | `PATCH /gilhari/v1/D` |
| DELETE | Delete objects | `DELETE /gilhari/v1/D` |

### Example Operations

**Create D object with INLINE E object:**
```bash
curl -X POST http://localhost:80/gilhari/v1/D \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "dId": 1,
      "dString": "dString_1",
      "dE": {
        "eId": 100,
        "eString": "eString_100"
      }
    }
  }'
```

**Query all D objects (includes INLINE E attributes):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/D" \
  -H "Content-Type: application/json"
```

**Shallow query (INLINE attributes still returned!):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/D?deep=false" \
  -H "Content-Type: application/json"
```

**Important:** Unlike normal relationships, INLINE attributes are **always returned** even with `deep=false` because they're stored in the same table row.

**Query with path expression (note underscore for INLINE):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/D?filter=jdxObject.dE_eId>100" \
  -H "Content-Type: application/json"
```

**Query E objects (only standalone E objects, not those stored INLINE with D):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/E" \
  -H "Content-Type: application/json"
```

**Create standalone E object (stored in E table, not INLINE):**
```bash
curl -X POST http://localhost:80/gilhari/v1/E \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "eId": 5000,
      "eString": "eString_5000"
    }
  }'
```

**Delete D object (E attributes deleted with it since they're INLINE):**
```bash
curl -X DELETE "http://localhost:80/gilhari/v1/D?filter=dId=1"
```

### Testing the API

**Comprehensive test scripts:**

1. **curlCommands.cmd / .sh** - Demonstrates INLINE mapping behavior

   Demonstrates:
   - Creating D objects with INLINE E objects
   - Shallow queries still return INLINE E attributes
   - Path expressions with underscore notation (`dE_eId`)
   - Creating standalone E objects
   - Verifying INLINE vs standalone E object storage

2. **curlCommandsPopulate.cmd / .sh** - Population and verification

   Demonstrates:
   - Sample data population
   - Multiple D objects with INLINE E objects
   - D objects without E objects (nullable)
   - Querying E table shows only standalone E objects
   - INLINE E objects are NOT in the E table query results

Run the scripts to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommands.cmd
curlCommandsPopulate.cmd

# Linux/Mac
chmod +x curlCommands.sh curlCommandsPopulate.sh
./curlCommands.sh
./curlCommandsPopulate.sh

# Custom port
curlCommands.cmd 8899
curlCommandsPopulate.sh 8899
```

The scripts demonstrate the INLINE mapping feature, showing how E attributes are stored in the same table row as D, and how shallow queries still return INLINE attributes.

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server** (optional): Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server (Optional)

This Gilhari microservice can be used with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use ORMCP tools** to query and manipulate D and E objects through natural language

The ORMCP Server will automatically understand the INLINE storage optimization.

For more information on ORMCP Server:
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples)
- **Product Website**: [https://www.softwaretree.com/products/ormcp/](https://www.softwaretree.com/products/ormcp/)

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`
- **operationDetails Documentation**: See `operationDetails_doc.md` for GraphQL-like query capabilities

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_relationships_inline_attribs_example.jdx` for correct database URL and JDBC driver path

**Problem**: Path expressions not working with INLINE attributes
- **Solution**: Use underscore notation for INLINE attributes (e.g., `dE_eId` instead of `dE.eId`)

**Problem**: Shallow query doesn't exclude E attributes
- **Solution**: This is expected behavior! INLINE attributes are always returned with their parent, even with `deep=false`, because they're stored in the same table row

**Problem**: Querying E table returns E objects that should be INLINE with D
- **Solution**: E objects stored INLINE with D are NOT in the E table. Only standalone E objects (created directly via POST to /E) appear in the E table

## Support

For issues or questions:
- **ORMCP Documentation & Issues**: [https://github.com/softwaretree/ormcp-docs/issues](https://github.com/softwaretree/ormcp-docs/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_relationships_inline_attribs_example/issues](https://github.com/SoftwareTree/gilhari_relationships_inline_attribs_example/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!