# ☕ Coffee Shop Sales Analysis – SQL Server + Power BI

A complete exploratory data analysis (EDA) project using **SQL Server** for data cleaning & transformation, and **Power BI** for interactive dashboard visualization. The goal is to extract meaningful insights from 149K+ coffee shop transactions and translate them into actionable business recommendations.

---

## 📌 Project Overview

The project explores a year-long (Jan–Dec 2023) coffee shop sales dataset. Starting from raw CSV import into SQL Server, the workflow involved:

* **Data Cleaning:** fixing inconsistent `Total_Bill`, adjusting data types, handling nulls, and removing duplicates.
* **Feature Engineering:** computed columns for `Hour`, `Month`, and `Day_of_Week`.
* **Exploratory Analysis:** identifying sales trends by month, hour, product, and store.
* **Visualization:** building a Power BI dashboard for interactive storytelling.

---

## 🎯 Objective

* Transform messy transactional sales data into structured, accurate information.
* Uncover patterns in sales by **time, store location, and products**.
* Understand **customer spending segments** (low, medium, high).
* Provide **data-driven recommendations** to improve sales & efficiency.

---

## 🔍 Key Tasks Performed

1. Import CSV into SQL Server and define correct data types.
2. Data cleaning: fixed `Total_Bill` inconsistencies, enforced decimal precision, removed duplicates.
3. Feature engineering: created computed columns for time analysis (`Hour`, `Month`, `Day_Of_Week`).
4. Exploratory queries:

   * Monthly & hourly sales
   * Store performance
   * Top products
   * Customer spending segmentation
   * Heatmap (Hour × Day)
5. Built interactive **Power BI Dashboard**.

---

## 💡 Key Insights

* Sales are **well distributed across all three store locations**, each contributing \~33% of revenue.
* **Medium spenders (\$5–\$15)** generate the majority of revenue (55%).
* **Low spenders (<\$5)** account for 38%, while **high spenders (> \$15)** only contribute 6.5%.
* Peak sales occur **8–10 AM weekdays**.
* After 7 PM, sales drop significantly across all stores.
* **Coffee** is the dominant product category, accounting for 37.5% of total revenue.

---

## 💡 Business Recommendations

* **Operational:** Allocate more staff during weekday morning peaks (8–10 AM), reduce staffing after 7 PM to cut costs.
* **Marketing:** Launch **seasonal promotions** (mid-year) and **afternoon happy hour campaigns** to attract more customers.
* **Customer Strategy:** Focus upselling & bundling strategies on **medium spenders (\$5–\$15)**, as they drive most revenue. Offer small promos to engage low spenders and maintain loyalty for niche high spenders.
* **Store Strategy:** Since all locations perform almost equally, prioritize **efficiency improvements across stores** (inventory, staffing, promos) rather than copying one “best performer.”

---

## 🛠️ Tools & Skills

* **SQL Server:** Data import, cleaning, computed columns, exploratory queries.
* **Power BI:** Interactive dashboard, DAX measures, visual storytelling.
* **Excel:** Quick validation & pivot checks.

---

## 📊 Deliverables

* 📄 SQL Scripts.sql → Data cleaning & EDA queries
* 📊 Dashboard-Coffee.png → Power BI Dashboard
* 📝 README.md → Analysis summary & recommendations

---

## 🌟 About Me

Hi! I'm \[Greatly Hizkia Manua], an aspiring Data Analyst with a strong passion for transforming raw data into actionable insights.

This project reflects my ability to work with real-world business data using industry-standard tools like **SQL Server** and **Power BI**.

I focus not only on building dashboards but also on uncovering strategic insights that drive real business value. Whether it’s **data cleaning, visualization, or storytelling**, I aim to deliver meaningful outcomes through data.

---

## 📬 Get in Touch
Thanks for checking out my project! I'm actively building my portfolio as a Data Analyst and open to internships, freelance projects, or full-time roles.
If you'd like to collaborate, discuss this project or offer feedback:
* Connect with me on [LinkedIn](https://www.linkedin.com/in/greatlyhizkiamanua/)
* Explore more of my work on [GitHub]([https://github.com/username-anda](https://github.com/GreatlyHizkia))
* Reach out via email at :greatlymanua@gmail.com

---

## 📌 License

This project is for educational and portfolio use only.
