# 🧠 Welcome to My Data Warehouse Project

Welcome to my data warehouse project focused on customer and sales data for a mock **Etsy-style shop**. This project demonstrates my ability to build a modern data warehouse using **PostgreSQL** (running in a **Docker container**), perform **ETL processes**, design a scalable **data model**, and develop insightful **analytics**. 

The data simulates **ERP** and **CRM** systems, providing a real-world scenario for integrating disparate sources into a unified warehouse to support data-driven decision-making.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### 🎯 Objective

Develop a modern data warehouse using **PostgreSQL** (deployed via Docker) to consolidate sales data, enabling analytical reporting and informed decision-making.

#### 📋 Specifications

- **Data Sources**: Import data from two source systems (**ERP** and **CRM**) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Environment**: PostgreSQL database and **pgAdmin** running inside Docker containers for isolated, reproducible deployment.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## 🧰 Tools & Technologies

- **PostgreSQL** — Primary data warehouse database.
- **Docker** — Containerized deployment for PostgreSQL and pgAdmin.
- **pgAdmin** — Browser-based UI for managing the PostgreSQL instance, running in its own Docker container.
- **SQL** — Data transformations and analytics.
- **CSV Files** — Source system exports (ERP and CRM).

---

## 📊 BI: Analytics & Reporting (Data Analysis)

#### 🎯 Objective

Develop **SQL-based analytics** to deliver detailed insights into:

- 📊 **Customer Behavior**
- 🛍️ **Product Performance**
- 📈 **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

> 📄 For more details, refer to [`docs/requirements.md`](docs/requirements.md)

---

## 🖥️ Accessing the Warehouse with pgAdmin

pgAdmin is included in this project as a Docker service to easily connect and manage the PostgreSQL instance.

Once your Docker containers are running, follow these steps:

1. Open your browser and go to: `http://localhost:5050`
2. Log in with the default pgAdmin credentials (set in `docker-compose.yml`).
3. Add a new server:
   - **Host**: `postgres`
   - **Port**: `5432`
   - **Username**: `postgres`
   - **Password**: (set in `.env` or `docker-compose.yml`)
4. Explore and manage your data warehouse, run SQL queries, and monitor your data model.

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

Thanks for stopping by and exploring this project!