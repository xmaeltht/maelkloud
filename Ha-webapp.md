**Title: Elastic Load Balancer (ELB) - Highly Available Website**

**Project 1: Internet-Facing Load Balancer with Public Subnet**

**Goal:** Configure a high-availability web architecture using an Application Load Balancer (ALB) to distribute traffic between web servers in a public subnet.

**Instructions:**

1. **Setting up Security Groups**
   * Create two security groups:
      * **alb_sg:** Allows HTTP traffic (port 80) from anywhere (0.0.0.0/0)
      * **web_sg:** Allows HTTP traffic (port 80) from the **alb_sg** you created
   * **Important:** Tag resources! Note down the ID of **alb_sg**.

2. **Create Web Server Images**
   * Launch two EC2 instances in your public subnet.
   * Tag them as follows:
      * **web_server_1**
      * **web_server_2**
   * Install `httpd` web server on each instance, and configure custom index pages:
      * **Server 1:** Blue welcome message.
      * **Server 2:** Red welcome message.
   * **Use the provided user data scripts.**
   * **Testing:** Try accessing each server by its public IP; expect timeouts initially.

3. **Set up a Target Group**
   * Create a Target Group named **elb-tg**.
   * Include both of your web server instances as targets.
   * **Monitor:** Observe the health status of the instances.

4. **Create the Application Load Balancer**
   * Create an ALB named **elb-alb**.
   * Add an HTTP listener on port 80.
   * Associate your **elb-tg** target group.

5. **Health Check Success**
   * Check the Target Group – health checks should now show targets as **healthy**.

6. **Testing Time!**
    * Access your website using the ALB's DNS name. 
    * **Refresh multiple times** – observe how the page color switches between blue and red, indicating load balancing.

7. **Simulate Failure**
   * Stop **web_server_1** and revisit the ALB URL.
   * Now, only the red page (**web_server_2**) should be served.

8. **Cleanup**
    * Delete resources in **reverse order of creation** (ALB, Target Group, Instances, Security Groups).

**Project 2: Internet-Facing Load Balancer with Private Subnet**

**Goal:**  Repeat Project 1, but this time place your web servers within a private subnet. This requires additional configuration for internet access.

**Instructions:**

* Follow the same steps as Homework 1, with this major change:
* **Step 2:**  Place your EC2 instances in a **private subnet**. You'll need resources like a NAT Gateway or instance to facilitate internet connectivity from your private subnet. Research and implement a suitable solution.

**User Data Scripts**

**Server 1**

```bash
#!/bin/bash
yum update -y
yum install httpd -y
echo '<html><body><h1 style="color:Blue;">Welcome to Web Server 1 (Blue)</h1></body></html>' > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

**Server 2**
```bash
#!/bin/bash
yum update -y
yum install httpd -y
echo '<html><body><h1 style="color:Red;">Welcome to Web Server 2 (Red)</h1></body></html>' > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

Let me know if you'd like any other formatting changes or additional notes! 
