# Etsy SQL Data Warehouse Project

Welcome to my end-to-end data warehouse project focused on simulating customer and sales data for a mock Etsy-style shop. This initiative demonstrates the principles of modern data engineering using a **Medallion Architecture** (Bronze, Silver, Gold), robust **ETL pipelines** with **PostgreSQL** running in **Docker**, and includes best practices in data ingestion, transformation, quality validation, and reporting. Version control is managed via **GitHub**, project planning is tracked in **Notion**, and architecture is documented with **Draw.io**.

The dataset mimics real-world **CRM** and **ERP** sources delivered as CSV files, and the project showcases how to integrate disparate data sources into a single warehouse optimized for analysis and stakeholder reporting.

---

## Project Goals

- Build a modular and scalable **data warehouse** architecture.
- Ingest raw CRM and ERP data from CSV files.
- Apply structured transformations and cleaning across layered schemas.
- Perform data quality checks at each transformation stage.
- Deliver enriched, analytics-ready data models for BI and reporting.
- Document the architecture, data model, and flow visually for stakeholders.
- Track progress, tickets, and enhancements using **Notion**.

---

## Tools & Technologies

| Tool / Tech         | Purpose                                               |
|---------------------|--------------------------------------------------------|
| **PostgreSQL**       | Core data warehouse engine                             |
| **Docker**           | Containerized environment for PostgreSQL & pgAdmin     |
| **pgAdmin**          | Web-based UI for managing PostgreSQL                   |
| **SQL**              | Data transformation, ingestion, and analysis           |
| **CSV Files**        | Simulated CRM and ERP source data                      |
| **GitHub**           | Version control for SQL scripts, documentation, and ETL|
| **Draw.io**          | Visuals for architecture, data flow, and schema design |
| **Notion**           | Task and project tracking, documentation hub           |
| **Tableau / Power BI** | BI tools for creating dashboards and final reports    |

---

## Medallion Architecture

This project follows a **three-tiered Medallion Architecture** for structured data refinement:

### 🥉 Bronze Layer – Raw Ingestion

**Purpose:**  
Load unmodified CRM and ERP CSV data into the data warehouse for traceability and reproducibility.

- Raw ingestion from persistent Docker volumes.
- Stored procedures using `COPY` for performance.
- Column types and formats preserved as-is.

---

### 🥈 Silver Layer – Clean & Standardized Data

**Purpose:**  
Transform raw data into consistent, structured formats for business use.

- Normalize fields (e.g., casing, categories).
- Handle missing values and blanks.
- Standardize date and string formats.
- De-duplicate records.
- Perform logical validations across columns.

**Quality Checks Include:**
- Duplicate or null primary keys
- Invalid date ranges (e.g., delivery before order)
- Cross-field consistency
- String format validations (e.g., no leading/trailing spaces)

---

### 🥇 Gold Layer – Business-Ready Analytics

**Purpose:**  
Generate a clean, enriched **star schema** optimized for analytics and BI tools.

- Dimension and fact tables with clear relationships.
- Surrogate keys introduced where needed.
- Designed to support self-service analytics and dashboards.

**Quality Checks Include:**
- Uniqueness of keys
- Referential integrity between tables
- Logical consistency for analytical use cases

---

## Documentation & Workflow Management

- **Version Control:**  
  All scripts, configurations, and documentation are tracked using **GitHub**, enabling team collaboration and rollback capabilities.

- **Project Management:**  
  The entire development lifecycle, including backlog grooming, active tasks, bug tracking, and delivery checkpoints, is managed using **Notion**.

- **System Design Diagrams:**  
  Architectural flowcharts, data integration diagrams, and schema visuals are created using **Draw.io** and stored in the `docs/` folder for clarity and onboarding.

---

## Final Output

The final **Gold Layer** data is designed for seamless integration with BI tools like **Tableau** or **Power BI** to produce:

- 📈 Sales performance dashboards  
- 🛍️ Product and category insights  
- 👥 Customer behavior metrics  
- 🧩 Trend and KPI visualizations  

---

## 📎 Additional Resources

For detailed transformation logic, source-to-target mapping, and quality check logic, refer to documentation in the `docs/` folder.

---

## 🛡️ License

This project is licensed under the **MIT License**.  
You are free to **use**, **modify**, and **share** this project with proper attribution.

---

## 🌟 About Me

Hi there! 👋 I'm **Remy Paul**, an IT professional and aspiring **Data Analyst** with a strong background in cloud technologies, scripting, Linux, and building data-driven systems.

This project is a hands-on example of how I approach data engineering and analysis using open-source tools. From setting up PostgreSQL in Docker, to using **pgAdmin** for database management, modeling real-world datasets, and delivering SQL insights — every step reflects my passion for turning raw data into knowledge.

---

## 📬 Let's Connect!

| [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/remyinthecloud) | [![Website](https://img.shields.io/badge/Website-Visit-4B5563?style=for-the-badge&logo=google-chrome)](https://remyinthecloud.com) |
| :-----------------------------------------------------------: | :-----------------------------------------------------------------: |

---

## Source

Credits to DataWithBara. I started this project as the last section in Bara's 30 comprehensive SQL course.
While I remixed Bara's original project to make it more like mine and learn how to use different tools
to achieve the same result, to further my core understanding of the Warehousing , DBM, and creating a pipeline.
Bara has been an extremely cruial resource and guide to this project.

---

Thanks for stopping by and exploring this project!
