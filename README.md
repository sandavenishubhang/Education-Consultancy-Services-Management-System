# VOYAGE: A University Application Portal

## Overview
VOYAGE is a comprehensive university application portal designed to simplify the process of applying to universities in regions like the USA, UK, and Canada. It offers students a one-stop solution to submit, track, and manage their university applications efficiently. Universities can interact directly with students via the platform, providing decisions and feedback seamlessly.

---

## Business Objective
- Provide consultancy services for students applying to universities across various regions.
- Eliminate the hassle of managing multiple university application platforms.
- Allow students to submit and track applications in one centralized location.
- Facilitate direct communication between students and university representatives.
- Organize career fairs to help universities promote their unique selling points.

---

## Features
- **Unified Application Process:** Submit and track all applications in one place.
- **University Interaction:** Representatives provide decisions based on student credentials.
- **Career Fairs:** A platform for universities to highlight their programs and strengths.
- **Analytics Dashboard:** Insights into acceptance rates, revenue, and application trends.

---

## Technologies Used
- **Database Management:**
  - Relational Database: MySQL
  - NoSQL Database: MongoDB
- **Backend:** Python for database access and operations.
- **Mock Data:** Generated using [Mockaroo](https://mockaroo.com).

---

## Setup Instructions
### Prerequisites
- Python (3.8+)
- MySQL Database
- MongoDB
- Required Python Libraries: `mysql-connector`, `pymongo`

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/voyage-university-portal.git
   cd voyage-university-portal
2. **Set up MySQL and MongoDB databases using provided schema files:**
   - Import the MySQL schema into your MySQL server:
     ```bash
     mysql -u <username> -p <database_name> < schema.sql
     ```
   - Import MongoDB collections:
     ```bash
     mongoimport --db <database_name> --collection <collection_name> --file <file_name>.json
     ```
   Replace `<username>`, `<database_name>`, `<collection_name>`, and `<file_name>.json` with your details.

3. Configure database credentials in `config.py`:
   ```python
   MYSQL_HOST = "localhost"
   MYSQL_USER = "your_mysql_username"
   MYSQL_PASSWORD = "your_mysql_password"
   MYSQL_DB = "your_mysql_database"

   MONGODB_URI = "mongodb://localhost:27017"
   
4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   
5. Run the application:
   ```bash
   python app.py

---

## Sample Queries
### MySQL
- **Average score of admitted students:**
  ```sql
  SELECT AVG(GPA) 
  FROM User_Student 
  INNER JOIN Application 
  ON User_Student.UserID = Application.Student_UserID 
  WHERE ApplicationStatus = 'Admitted';

- **Revenue by year**
  ```sql
  SELECT Year(date) as year,sum(BillAmount) as Revenue
  FROM Bill 
  Group by Year(Date);

---

### MongoDB
- **Top 3 universities by applications:**
  ```javascript
  db.universities.aggregate([
    { $group: { _id: "$universityID", totalApplications: { $sum: 1 } } },
    { $sort: { totalApplications: -1 } },
    { $limit: 3 }
  ]);
- **Most Popular Country:**
   ```javascript
   db.applications.aggregate([
  { $group: { _id: "$country", totalApplications: { $sum: 1 } } },
  { $sort: { totalApplications: -1 } },
  { $limit: 1 }
  ]);



## Future Improvements
- Integration with third-party services for application tracking.
- AI-driven university recommendations.
- Enhanced analytics for student preferences and trends.
- Improved scalability for global access.
- Mobile application integration for on-the-go updates and notifications.

---

## Contributors
- **Your Name** - Shubhang Yadav Sandaveni

 






