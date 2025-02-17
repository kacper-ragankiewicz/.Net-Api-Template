[![codebeat badge](https://codebeat.co/badges/96fdd8bb-9d1e-409e-9a93-66eb7f9ebb31)](https://codebeat.co/projects/github-com-kacper-ragankiewicz-net-api-template-main)


# .NET Project with Docker Compose & Terraform

## Overview
This project is a **.NET application** that runs inside a **Docker container**, orchestrated using **Docker Compose**. The infrastructure is managed using **Terraform**, allowing easy deployment to cloud providers like AWS, Azure, or GCP.

## Prerequisites
Ensure you have the following installed:

- [.NET SDK](https://dotnet.microsoft.com/download)
- [Docker & Docker Compose](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/your-project.git
cd your-project
```

### 2. Build and Run with Docker Compose
```bash
docker-compose up --build -d
```
This will:
- Build the .NET project
- Create and start the necessary containers

To stop the services, run:
```bash
docker-compose down
```

### 3. Running the Application Locally
If you want to run the application outside Docker:
```bash
dotnet run --project YourProjectName
```

### 4. Infrastructure Deployment with Terraform

#### Initialize Terraform
```bash
cd terraform
terraform init
```

#### Plan Infrastructure Changes
```bash
terraform plan
```

#### Apply Infrastructure Changes
```bash
terraform apply -auto-approve
```

#### Destroy Infrastructure (Optional)
```bash
terraform destroy -auto-approve
```

## Project Structure
```
/your-project
│── /src                # Source code
│   ├── YourProject     # Main .NET project
│   ├── YourProject.Tests # Unit tests
│── /terraform          # Terraform infrastructure configuration
│── /docker             # Docker files
│── docker-compose.yml  # Docker Compose configuration
│── README.md           # Project documentation
│── .gitignore          # Git ignore file
```

## Environment Variables
This project uses environment variables for configuration. You can define them in a `.env` file:
```env
ASPNETCORE_ENVIRONMENT=Development
DB_CONNECTION_STRING=your_connection_string
```
Ensure you **do not commit** sensitive data by adding `.env` to `.gitignore`.

## CI/CD Integration
To automate deployment, integrate Terraform with a CI/CD pipeline such as **GitHub Actions, GitLab CI/CD, or Azure DevOps**.

Example GitHub Actions workflow:
```yaml
name: Deploy with Terraform
on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
      - name: Set Up Terraform
        uses: hashicorp/setup-terraform@v1
      - name: Initialize Terraform
        run: terraform init
      - name: Plan Terraform Changes
        run: terraform plan
      - name: Apply Terraform Changes
        run: terraform apply -auto-approve
```

## Monitoring & Logging
- Logs can be viewed using:
  ```bash
  docker logs -f <container_name>
  ```
- Consider integrating **Prometheus** and **Grafana** for monitoring.

## Contributions
Contributions are welcome! Feel free to open an issue or submit a pull request.

## License
This project is licensed under the **MIT License**.

---
For any questions or issues, feel free to reach out. 🚀

