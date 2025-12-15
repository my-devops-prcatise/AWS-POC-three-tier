

---

# AWS 3-Tier Java Web Application – Progress README

## Project Overview

This project demonstrates a **3-tier architecture deployment on AWS** using a **Java Spring MVC application** with **JSP**, **Apache Tomcat**, and **Amazon RDS MySQL**.

The architecture follows:

* **Web Tier** → (to be implemented)
* **Application Tier** → Deployed
* **Database Tier** → Deployed

---

## Repository Structure

```
Java-Login-App/
├── src/
│   ├── main/
│   │   ├── java/com/dpt/demo/
│   │   │   ├── HomeController.java
│   │   │   ├── login.java
│   │   │   ├── register.java
│   │   │   ├── MyWebAppApplication.java
│   │   │   └── ServletInitializer.java
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/pages/
│   │       ├── login.jsp
│   │       ├── register.jsp
│   │       ├── home.jsp
│   │       ├── confirm.jsp
│   │       ├── fail.jsp
│   │       └── user.jsp
│   └── test/java/com/dpt/demo/
│       └── MyWebAppApplicationTests.java
```

---

## Architecture (Current Status)

```
Application Tier  ✅  →  Tomcat + Spring MVC + JSP
Database Tier     ✅  →  Amazon RDS MySQL
Web Tier          ❌  →  Not deployed yet (ALB pending)
```

---

## 1. Application Code Preparation (Completed)

* Developed a **Spring MVC Java web application**
* Controllers handle login and registration logic
* JSP files provide the UI (View layer)
* Application packaged as a **WAR file** for external Tomcat deployment

---

## 2. Application Configuration (Completed)

File:
`src/main/resources/application.properties`

Configured:

```properties
spring.mvc.view.prefix=/pages/
spring.mvc.view.suffix=.jsp

spring.datasource.url=jdbc:mysql://<RDS-ENDPOINT>:3306/UserDB
spring.datasource.username=admin
spring.datasource.password=Admin123
```

* JSP view resolution configured
* Database connection configured for Amazon RDS MySQL

---

## 3. Database Tier Deployment (Completed)

* Amazon **RDS MySQL** created
* Database name: `UserDB`
* Deployed in **private DB subnets**
* Security Group rule:

  ```
  3306 → Application EC2 Security Group
  ```
* Public access disabled

---

## 4. Application Tier EC2 Deployment (Completed)

* Ubuntu EC2 instance launched in **private App subnet**
* No public IP assigned
* Security group prepared for internal access

---

## 5. Application Tier Software Setup (Completed)

Installed on Ubuntu EC2:

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install maven -y
sudo apt install git -y
sudo apt install tomcat10 -y
```

---

## 6. Application Deployment on Tomcat (Completed)

Steps performed:

```bash
git clone <repository-url>
cd Java-Login-App
mvn clean package
```

WAR file generated:

```
target/dptweb-1.0.war
```

Deployed to Tomcat:

```bash
sudo cp target/dptweb-1.0.war /var/lib/tomcat10/webapps/
sudo systemctl restart tomcat10
```

---

## 7. Database Connectivity Verification (Completed)

Tested DB access from App EC2:

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

* Successful connection confirms **App Tier → DB Tier connectivity**

---

## 8. Local Application Validation (Completed)

Verified Tomcat deployment:

```bash
curl -I http://localhost:8080/dptweb-1/
```

* Tomcat responding
* WAR deployed correctly
* JSP pages accessible via context path

---

## Current Status Summary

* ✅ Application Tier deployed on **private Ubuntu EC2**
* ✅ Database Tier deployed using **Amazon RDS MySQL**
* ❌ Web Tier (Application Load Balancer) **not yet deployed**

---

## One-Line Summary

> The application and database tiers of a 3-tier AWS architecture have been successfully deployed using Tomcat on a private Ubuntu EC2 instance and Amazon RDS MySQL, with database connectivity verified.

---

## Next Steps (Planned)

* Deploy **Web Tier** using Application Load Balancer
* Connect ALB to Application Tier
* Enable public access through ALB
* Optional: HTTPS, Auto Scaling, Terraform

---

