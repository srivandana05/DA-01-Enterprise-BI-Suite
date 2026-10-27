**DA-01: Enterprise Business Intelligence Suite**

**Project overview:-**

This project is an interactive Power BI dashboard built using the

AdventureWorksDW2022 sample data warehouse. It brings together Sales,

Finance, HR, and Supply Chain views in a single-page dashboard

experience.

**Business problem:-**

Business data is organized across different subject areas, making it

harder for decision-makers to view performance in one place and explore

how results vary by time, region, product, currency, or business

function. Static totals alone may not explain why a metric changes, and

missing periods in a dataset can be mistaken for zero activity if data

coverage is not checked.

What this project addresses:-

The project brings selected Sales, Finance, HR, and Supply Chain

indicators into one interactive dashboard. Users can navigate between

business areas, apply relevant filters, review trends, and drill through

to product-level details. SQL validation checks and data-coverage

documentation help users interpret the available data more carefully.



This is a decision-support prototype built on sample data. It helps

users explore patterns and identify questions for further investigation;

it does not prove the causes of sales or financial changes,

automatically optimize prices, or establish business outcomes on its

own.

**Objectives:-**

\- Present key business indicators in a unified dashboard.

\- Support exploration with relevant year, region, and currency

&#x20; filters.

\- Provide product-level exploration through drill-through.

\- Demonstrate data modelling, DAX measures, row-level security, and

&#x20; source-data validation.

\- Document data coverage and limitations so users can interpret

&#x20; results appropriately.

**Tools and technologies:-**

\- SQL Server Developer Edition

\- AdventureWorksDW2022

\- Power Query

\- Power BI Desktop

\- DAX

\- SQL Server Agent

**Dashboard features:-**

\- Single-page dashboard with bookmark-based navigation across business

&#x20; areas.

\- Sales KPIs and visuals, including sales, distinct orders, average

&#x20; order value, year-to-date sales, year-over-year growth, product and

&#x20; regional analysis.

\- Finance, HR, and Supply Chain sections based on the available source

&#x20; tables.

\- Year, region, and currency filtering where applicable.

\- Product drill-through to a detailed view.

\- Power BI row-level security roles created and tested for North

&#x20; America, Europe, and Pacific.

\- SQL validation and logging through a SQL Server Agent job.

**Data coverage and limitations:-**

\*\*Observed source-data coverage: - Sales: 2010--2014 - Supply Chain

inventory: 2010--2014 - Finance: 2010--2013\*\*



Blank periods outside these ranges indicate no matching records in the

current source data; they should not automatically be interpreted as

zero business activity.



The Power BI model uses Import mode. The SQL Server Agent job validates

and logs source-data checks; it does not automatically refresh the Power

BI model. Refresh is currently performed manually in Power BI Desktop.

**Repository structure:-**

**- PowerBI/**

\--- Power BI report (.pbix) and dashboard screenshots

**- SQL/**

\--- SQL validation queries and job scripts, where available

**- Documentation/**

\--- architecture diagram, data dictionary, and user

&#x20; guide

**- Presentation/**

&#x20;--- 10-minute presentation and individual reflection

**- Demo/**

\--- dashboard walkthrough recording

**- Tests/**

\--- final test report and evidence (to be completed last)

**Setup:-**

1\. Install Power BI Desktop and SQL Server tools as needed.

2\. Obtain the AdventureWorksDW2022 sample database in SQL Server.

3\. Open the .pbix file in Power BI Desktop.

4\. If prompted, update the SQL Server connection to your local server

&#x20;  and database.

5\. Refresh the model in Power BI Desktop.

6\. Review the report's filters, bookmark navigation, product

&#x20;  drill-through, and RLS roles.

Configure connection details locally. Do not commit passwords,

credentials, or other secrets.

**Validation:-**

A SQL validation run previously checked 60,398 sales rows and reported

zero nulls for the checked key. A distinct-key check returned 60,398

total rows and 60,398 distinct keys for the checked field. The formal

test report and supporting evidence will be added after the remaining

deliverables are finalized.

Deliverables

\- Power BI report

\- SQL validation / processing scripts, where available

\- Architecture diagram

\- Data dictionary

\- User guide

\- Presentation

\- Individual reflection

\- Demo recording

\- Final test report

**Author**

Sri Vandana Dornala

