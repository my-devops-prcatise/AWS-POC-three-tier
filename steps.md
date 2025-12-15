
---

# AWS 3-Tier Java Web Application Deployment (POC)

This project demonstrates deploying a **Java Spring MVC (JSP + MySQL)** application using a **3-tier architecture on AWS**.

---

## Architecture Overview

* **Web Tier**: Application Load Balancer (Public Subnets)
* **Application Tier**: Ubuntu EC2 + Tomcat 10 (Private Subnet)
* **Database Tier**: Amazon RDS MySQL (Private Subnet)

---

## Repository Structure

```text
Java-Login-App/
├── src/main/java/com/dpt/demo
│   ├── HomeController.java
│   ├── login.java
│   ├── register.java
│   ├── MyWebAppApplication.java
│   └── ServletInitializer.java
│
├── src/main/resources
│   └── application.properties
│
├── src/main/webapp/pages
│   ├── login.jsp
│   ├── register.jsp
│   ├── home.jsp
│   ├── confirm.jsp
│   ├── fail.jsp
│   └── user.jsp
│
└── pom.xml
```

> **Note**:
> JSP files are server-side rendered views and are part of the **Application Tier**, not the Web Tier.

---

## Step 1: Network Infrastructure Setup

* Created a VPC with CIDR block
* Created subnets across 2 Availability Zones:

  * Public subnets (Web Tier)
  * Private subnets (Application Tier)
  * Private subnets (Database Tier)
* Attached:

  * Internet Gateway (for public subnets)
  * NAT Gateway (for private subnets)
* Configured route tables:

  * Public → IGW
  * App → NAT
  * DB → No internet access

---

## Step 2: Database Tier Deployment (RDS)

* Launched **Amazon RDS MySQL**
* Database name: `UserDB`
* Port: `3306`
* Deployed in **private DB subnets**
* Security Group:

  ```text
  Inbound: 3306 → App Tier Security Group
  ```

---

## Step 3: Application Tier EC2 Setup (Ubuntu)

### EC2 Details

* Ubuntu EC2 instance
* Deployed in **private App subnet**
* No public IP assigned

### Installed Required Packages

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install maven -y
sudo apt install git -y
sudo apt install tomcat10 -y
```

---

## Step 4: Application Build & Deployment (WAR on Tomcat)

### Clone Repository

```bash
git clone <your-repository-url>
cd Java-Login-App
```

### Build Application

```bash
mvn clean package
```

### Deploy WAR to Tomcat

```bash
sudo cp target/dptweb-1.0.war /var/lib/tomcat10/webapps/
sudo systemctl restart tomcat10
```

Application context path:

```text
/dptweb-1
```

---

## Step 5: Application Configuration

Configured database connection in:

```text
src/main/resources/application.properties
```

```properties
spring.mvc.view.prefix=/pages/
spring.mvc.view.suffix=.jsp

spring.datasource.url=jdbc:mysql:<RDS-ENDPOINT>:3306/UserDB
spring.datasource.username=admin
spring.datasource.password=Admin123
```

---

## Step 6: Database Connectivity Validation

```bash
sudo apt install mysql-client -y
mysql -h <RDS-ENDPOINT> -u admin -p
```

✔️ Successful login confirms App → DB connectivity.

---

## Step 7: Local Application Validation (App Tier)

```bash
curl -I http://localhost:8080/dptweb-1/
```

✔️ Confirms:

* Tomcat is running
* WAR is deployed
* JSP pages are accessible

---

## Step 8: Web Tier Deployment (NEXT STEP)

The **Web Tier** is implemented using an **Application Load Balancer (ALB)**.

### Steps to Complete Web Tier:

1. Create a Target Group

   * Type: Instance
   * Protocol: HTTP
   * Port: 8080
   * Health check path:

     ```text
     /dptweb-1/
     ```

2. Register the App Tier EC2 in the target group

3. Create an Application Load Balancer

   * Internet-facing
   * Public subnets (2 AZs)
   * Listener: HTTP 80 → Target Group

4. Update Security Groups

   * ALB SG:

     ```text
     80 → 0.0.0.0/0
     ```
   * App EC2 SG:

     ```text
     8080 → ALB Security Group
     ```

5. Access application via:

```text
http://<ALB-DNS-NAME>/dptweb-1/
```

---

## Final Architecture Flow

```text
User Browser
   ↓
Application Load Balancer (Web Tier)
   ↓
Tomcat + JSP + Controllers (App Tier)
   ↓
Amazon RDS MySQL (DB Tier)
```

---

## Interview-Ready Summary

> “I deployed a WAR-based Spring MVC application on Tomcat running on a private Ubuntu EC2 instance, connected it securely to Amazon RDS MySQL, and exposed the application using an Application Load Balancer in the web tier, forming a complete AWS 3-tier architecture.”

---



