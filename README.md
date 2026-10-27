# DA-01: Enterprise BI Suite

An interactive Power BI business intelligence dashboard built using the **AdventureWorksDW2022** data warehouse. The project brings together Sales, Finance, HR, and Supply Chain analytics in a single-page executive dashboard.

## Project Objectives

- Consolidate key business metrics into an interactive dashboard.
- Analyze sales performance, financial trends, workforce information, and inventory.
- Enable exploration through slicers, bookmark navigation, and product-level drill-through.
- Document data coverage, validation checks, and known limitations.

## Tools and Technologies

- **Power BI Desktop** — dashboard development, data modeling, DAX measures, and visualizations
- **Power Query** — data preparation and transformation
- **DAX** — KPI calculations, YTD sales, year-over-year growth, and other measures
- **SQL Server Developer Edition** — AdventureWorksDW2022 data warehouse and SQL validation
- **SQL Server Agent** — scheduled validation and execution logging

## Dashboard Features

- Single-page executive dashboard with Overview, Sales, Finance, HR, and Supply Chain sections
- KPI cards and interactive visualizations
- Region and year filtering where supported by the underlying data
- Currency filtering for applicable sales data
- Product-level Sales Detail drill-through
- Power BI row-level security roles for North America, Europe, and Pacific

## Data Coverage and Limitations

The source data does not cover every year equally:

- **Sales and Supply Chain Inventory:** 2010–2014
- **Finance:** 2010–2013
- **HR:** available fields and interactions depend on the source tables and relationships

Blank results outside the available source-data periods should not be interpreted as confirmed zero activity. Currency availability also depends on the transactions present in the relevant tables.

The SQL Server Agent job validates sales data and logs its execution status. It does not automatically refresh the Power BI Desktop report. The report must be refreshed manually in Power BI Desktop unless a separate refresh solution is configured.

## Validation

The project includes SQL validation scripts and a test report covering data checks and dashboard functionality.

Previously recorded validation results included 60,398 sales rows and 60,398 distinct checked sales keys. Refer to the test report for the checks performed, reported results, and limitations. These results are not a claim that every possible scenario has been independently retested.

## Repository Structure

- `PowerBI/` — Power BI dashboard file
- `SQL/` — SQL validation and analysis scripts
- `Documentation/` — architecture diagram, data dictionary, and user guide
- `Presentation/` — project presentation and individual reflection
- `Demo/` — dashboard demonstration recording
- `Tests/` — final test report

## How to Explore the Project

1. Review the architecture diagram and data dictionary in `Documentation/`.
2. Open the `.pbix` file in `PowerBI/` using Power BI Desktop.
3. Connect to a compatible AdventureWorksDW2022 SQL Server database if prompted, and configure credentials and data-source settings for your environment.
4. Refresh the report as appropriate for your local setup.
5. Use the dashboard navigation, slicers, and product drill-through to explore the supported analyses.
6. Review `SQL/` and `Tests/` for validation scripts and reported test outcomes.

## Project Deliverables

The repository includes the Power BI dashboard, SQL scripts, documentation, demonstration recording, presentation, individual reflection, and test report.

## Author

**Sri Vandana Dornala** — Aspiring Data Analyst

