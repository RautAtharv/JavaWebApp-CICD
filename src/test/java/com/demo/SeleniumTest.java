package com.demo;

import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class SeleniumTest {

    private WebDriver driver;

    @Test
    public void testJavaWebApplication() {

        // Launch Chrome
        driver = new ChromeDriver();

        // Open Java application running in Tomcat Docker
        driver.get("http://localhost:8081");

        driver.manage().window().maximize();

        // Verify webpage title
        assertEquals(
            "CI/CD Java Web Application",
            driver.getTitle()
        );

        // Verify webpage message
        boolean messageDisplayed =
            driver.findElement(By.id("message")).isDisplayed();

        assertTrue(messageDisplayed);
    }

    @AfterEach
    public void closeBrowser() {

        if (driver != null) {
            driver.quit();
        }
    }
}