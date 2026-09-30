package com.demo;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInfo;
import org.junit.jupiter.api.TestMethodOrder;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * ================================================================
 * TASKNEXUS PRO
 * SELENIUM AUTOMATED FUNCTIONAL TEST SUITE
 * ================================================================
 *
 * Application:
 * TaskNexus Pro - Intelligent Task & Productivity Management System
 *
 * Technologies:
 * - Java 17
 * - Maven
 * - Selenium WebDriver
 * - JUnit 5
 * - ChromeDriver
 * - JSP / Servlet
 * - Tomcat
 * - Docker
 *
 * Total Test Cases: 10
 *
 * Major Functionalities Tested:
 * 1. Dashboard loading
 * 2. Dashboard statistics
 * 3. Task modal and validation
 * 4. Task creation
 * 5. Search functionality
 * 6. Status and priority filters
 * 7. Start task
 * 8. Task lifecycle and completion
 * 9. Delete task
 * 10. Reset filters and due-date sorting
 *
 * ================================================================
 */

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SeleniumTest {

    /* ============================================================
       DRIVER VARIABLES
       ============================================================ */

    private WebDriver driver;

    private WebDriverWait wait;


    /**
     * Application Base URL
     *
     * Local execution:
     * http://localhost:8081
     *
     * Jenkins example:
     * mvn test -Dheadless=true -DbaseUrl=http://localhost:8081
     */
    private static final String BASE_URL =
            System.getProperty(
                    "baseUrl",
                    "http://localhost:8081"
            );


    /**
     * Stores all tasks created during each test.
     * Tasks are automatically deleted after the test finishes.
     */
    private final List<String> createdTasks =
            new ArrayList<>();


    /* ============================================================
       BROWSER SETUP
       ============================================================ */

    @BeforeEach
    void setUp() {

        System.out.println();

        System.out.println(
                "============================================================"
        );

        System.out.println(
                "Starting TaskNexus Selenium Automated Test"
        );

        System.out.println(
                "Application URL : " + BASE_URL
        );

        System.out.println(
                "============================================================"
        );


        /*
         * Chrome browser configuration
         */
        ChromeOptions options =
                new ChromeOptions();


        /*
         * Check whether Selenium should run without opening
         * the visible Chrome browser.
         *
         * Local:
         * mvn test
         *
         * Jenkins:
         * mvn test -Dheadless=true
         */
        boolean headless =
                Boolean.parseBoolean(
                        System.getProperty(
                                "headless",
                                "false"
                        )
                );


        if (headless) {

            options.addArguments(
                    "--headless=new"
            );
        }


        /*
         * Additional browser arguments
         */
        options.addArguments(
                "--window-size=1920,1080"
        );

        options.addArguments(
                "--disable-notifications"
        );

        options.addArguments(
                "--disable-popup-blocking"
        );

        options.addArguments(
                "--disable-dev-shm-usage"
        );

        options.addArguments(
                "--no-sandbox"
        );


        /*
         * Start Chrome browser
         */
        driver =
                new ChromeDriver(
                        options
                );


        /*
         * Explicit Selenium wait
         */
        wait =
                new WebDriverWait(
                        driver,
                        Duration.ofSeconds(15)
                );


        /*
         * Open TaskNexus dashboard
         */
        openTasksPage();
    }


    /* ============================================================
       AFTER EACH TEST
       ============================================================ */

    @AfterEach
    void tearDown(
            TestInfo testInfo) {

        System.out.println();

        System.out.println(
                "Completed Test : "
                        + testInfo.getDisplayName()
        );


        /*
         * Take screenshot after every test case
         */
        try {

            takeScreenshot(
                    testInfo.getDisplayName()
            );

        } catch (Exception exception) {

            System.out.println(
                    "Screenshot could not be captured."
            );
        }


        /*
         * Delete tasks created by Selenium
         */
        try {

            cleanupCreatedTasks();

        } catch (Exception exception) {

            System.out.println(
                    "Automatic test cleanup skipped."
            );
        }


        /*
         * Close Chrome browser
         */
        if (driver != null) {

            driver.quit();
        }


        System.out.println(
                "Browser Closed Successfully"
        );

        System.out.println(
                "============================================================"
        );
    }


    /* ============================================================
       TEST CASE 01
       APPLICATION AND DASHBOARD VERIFICATION
       ============================================================ */

    @Test
    @Order(1)
    @DisplayName("TC01_Verify_TaskNexus_Dashboard")
    void testTaskNexusDashboard() {

        /*
         * Verify browser page title
         */
        String pageTitle =
                driver.getTitle();


        System.out.println(
                "Page Title : "
                        + pageTitle
        );


        assertTrue(
                pageTitle.contains(
                        "TaskNexus Pro"
                ),
                "Page title should contain TaskNexus Pro"
        );


        /*
         * Verify URL
         */
        String currentURL =
                driver.getCurrentUrl();


        System.out.println(
                "Current URL : "
                        + currentURL
        );


        assertTrue(
                currentURL.contains(
                        "/tasks"
                ),
                "Application should open /tasks"
        );


        /*
         * Verify main heading
         */
        assertTrue(
                driver.getPageSource()
                        .contains(
                                "My task workspace"
                        ),
                "Task workspace heading should be displayed"
        );


        /*
         * Verify Create Task button
         */
        assertTrue(
                isDisplayed(
                        By.id(
                                "openTaskModalButton"
                        )
                )
        );


        /*
         * Verify task area
         */
        assertTrue(
                isDisplayed(
                        By.id(
                                "taskGrid"
                        )
                )
        );


        /*
         * Verify filters
         */
        assertTrue(
                isDisplayed(
                        By.id(
                                "searchTask"
                        )
                )
        );


        assertTrue(
                isDisplayed(
                        By.id(
                                "statusFilter"
                        )
                )
        );


        assertTrue(
                isDisplayed(
                        By.id(
                                "priorityFilter"
                        )
                )
        );


        System.out.println(
                "Dashboard Loaded Successfully"
        );
    }


    /* ============================================================
       TEST CASE 02
       DASHBOARD SUMMARY COUNTERS
       ============================================================ */

    @Test
    @Order(2)
    @DisplayName("TC02_Verify_Dashboard_Statistics")
    void testDashboardStatistics() {

        /*
         * Read statistics from dashboard
         */
        int totalTasks =
                readCounter(
                        "totalTasks"
                );


        int pendingTasks =
                readCounter(
                        "pendingTasks"
                );


        int progressTasks =
                readCounter(
                        "progressTasks"
                );


        int completedTasks =
                readCounter(
                        "completedTasks"
                );


        /*
         * Display statistics in Maven console
         */
        System.out.println(
                "Total Tasks       : "
                        + totalTasks
        );

        System.out.println(
                "Pending Tasks     : "
                        + pendingTasks
        );

        System.out.println(
                "In Progress Tasks : "
                        + progressTasks
        );

        System.out.println(
                "Completed Tasks   : "
                        + completedTasks
        );


        /*
         * Counters cannot be negative
         */
        assertTrue(
                totalTasks >= 0
        );


        assertTrue(
                pendingTasks >= 0
        );


        assertTrue(
                progressTasks >= 0
        );


        assertTrue(
                completedTasks >= 0
        );


        /*
         * Verify mathematical relationship
         */
        assertEquals(
                totalTasks,
                pendingTasks
                        + progressTasks
                        + completedTasks,
                "Total tasks must equal Pending + In Progress + Completed"
        );
    }


    /* ============================================================
       TEST CASE 03
       TASK MODAL AND FORM VALIDATION
       ============================================================ */

    @Test
    @Order(3)
    @DisplayName("TC03_Verify_Task_Modal_And_Validation")
    void testTaskModalAndValidation() {

        /*
         * Open Create Task modal
         */
        openCreateModal();


        WebElement modal =
                driver.findElement(
                        By.id(
                                "taskModal"
                        )
                );


        /*
         * Modal should be visible
         */
        assertTrue(
                modal.isDisplayed()
        );


        /*
         * Find form fields
         */
        WebElement title =
                driver.findElement(
                        By.id(
                                "taskTitle"
                        )
                );


        WebElement description =
                driver.findElement(
                        By.id(
                                "taskDescription"
                        )
                );


        WebElement category =
                driver.findElement(
                        By.id(
                                "taskCategory"
                        )
                );


        WebElement priority =
                driver.findElement(
                        By.id(
                                "taskPriority"
                        )
                );


        WebElement dueDate =
                driver.findElement(
                        By.id(
                                "taskDueDate"
                        )
                );


        /*
         * Verify fields are visible
         */
        assertTrue(
                title.isDisplayed()
        );


        assertTrue(
                description.isDisplayed()
        );


        assertTrue(
                category.isDisplayed()
        );


        assertTrue(
                priority.isDisplayed()
        );


        assertTrue(
                dueDate.isDisplayed()
        );


        /*
         * Title should be required
         */
        assertNotNull(
                title.getAttribute(
                        "required"
                )
        );


        /*
         * Description should be required
         */
        assertNotNull(
                description.getAttribute(
                        "required"
                )
        );


        /*
         * Verify complete form is invalid when empty
         */
        Boolean formValid =
                (Boolean)
                        ((JavascriptExecutor) driver)
                                .executeScript(
                                        "return document.getElementById(" +
                                                "'createTaskForm'" +
                                                ").checkValidity();"
                                );


        assertFalse(
                formValid,
                "Empty Create Task form must be invalid"
        );


        /*
         * Verify minimum due date
         */
        assertEquals(
                LocalDate.now()
                        .toString(),
                dueDate.getAttribute(
                        "min"
                )
        );


        /*
         * Close modal
         */
        driver.findElement(
                By.id(
                        "closeTaskModalButton"
                )
        ).click();


        wait.until(
                ExpectedConditions
                        .invisibilityOf(
                                modal
                        )
        );


        assertFalse(
                modal.isDisplayed()
        );
    }


    /* ============================================================
       TEST CASE 04
       CREATE NEW TASK
       ============================================================ */

    @Test
    @Order(4)
    @DisplayName("TC04_Create_New_Task")
    void testCreateNewTask() {

        /*
         * Create unique task title
         */
        String title =
                uniqueTitle(
                        "Selenium Automation"
                );


        /*
         * Set future due date
         */
        LocalDate dueDate =
                LocalDate.now()
                        .plusDays(5);


        /*
         * Create new task
         */
        createTask(
                title,
                "Automated TaskNexus functional testing using Selenium WebDriver.",
                "Testing",
                "High",
                dueDate
        );


        /*
         * Verify task exists
         */
        assertTrue(
                taskExists(
                        title
                )
        );


        /*
         * Get created task card
         */
        WebElement taskCard =
                findTaskCard(
                        title
                );


        /*
         * Verify title
         */
        assertEquals(
                title,
                taskCard.findElement(
                        By.cssSelector(
                                ".task-title"
                        )
                ).getText()
        );


        /*
         * Verify description
         */
        assertTrue(
                taskCard.findElement(
                        By.cssSelector(
                                ".task-description"
                        )
                ).getText()
                        .contains(
                                "Selenium WebDriver"
                        )
        );


        /*
         * Verify category
         */
        assertEquals(
                "Testing",
                taskCard.findElement(
                        By.cssSelector(
                                ".category-badge"
                        )
                ).getText()
        );


        /*
         * Verify priority
         */
        assertEquals(
                "High",
                taskCard.findElement(
                        By.cssSelector(
                                ".priority"
                        )
                ).getText()
        );


        /*
         * Verify default task status
         */
        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                )
        );


        /*
         * Verify due date
         */
        String displayedDate =
                taskCard.findElement(
                        By.cssSelector(
                                ".task-due strong"
                        )
                ).getText();


        assertEquals(
                dueDate.toString(),
                displayedDate
        );
    }


    /* ============================================================
       TEST CASE 05
       SEARCH FUNCTIONALITY
       ============================================================ */

    @Test
    @Order(5)
    @DisplayName("TC05_Verify_Task_Search")
    void testTaskSearchFunctionality() {

        /*
         * Create unique search values
         */
        String uniqueCode =
                UUID.randomUUID()
                        .toString()
                        .substring(
                                0,
                                8
                        );


        String title =
                "Search Task "
                        + uniqueCode;


        String description =
                "Unique Description "
                        + uniqueCode;


        /*
         * Create task
         */
        createTask(
                title,
                description,
                "Research",
                "Medium",
                LocalDate.now()
                        .plusDays(4)
        );


        /*
         * --------------------------------------------------------
         * SEARCH BY TITLE
         * --------------------------------------------------------
         */

        searchTaskByQuery(
                title
        );


        assertTrue(
                taskExists(
                        title
                ),
                "Task should be searchable using title"
        );


        /*
         * --------------------------------------------------------
         * SEARCH BY DESCRIPTION
         * --------------------------------------------------------
         */

        openTasksPage();


        searchTaskByQuery(
                description
        );


        assertTrue(
                taskExists(
                        title
                ),
                "Task should be searchable using description"
        );


        /*
         * --------------------------------------------------------
         * SEARCH BY CATEGORY
         * --------------------------------------------------------
         */

        openTasksPage();


        searchTaskByQuery(
                "Research"
        );


        assertTrue(
                taskExists(
                        title
                ),
                "Task should be searchable using category"
        );


        /*
         * --------------------------------------------------------
         * INVALID SEARCH
         * --------------------------------------------------------
         */

        openTasksPage();


        searchTaskByQuery(
                "TASK-NOT-AVAILABLE-"
                        + UUID.randomUUID()
        );


        assertEquals(
                0,
                driver.findElements(
                        By.cssSelector(
                                ".task-card"
                        )
                ).size()
        );


        /*
         * Verify empty state
         */
        WebElement emptyState =
                driver.findElement(
                        By.cssSelector(
                                ".empty-state"
                        )
                );


        assertTrue(
                emptyState.isDisplayed()
        );
    }


    /* ============================================================
       TEST CASE 06
       PRIORITY AND STATUS FILTERS
       ============================================================ */

    @Test
    @Order(6)
    @DisplayName("TC06_Verify_Task_Filters")
    void testTaskFilters() {

        String uniqueCode =
                UUID.randomUUID()
                        .toString()
                        .substring(
                                0,
                                8
                        );


        String highTask =
                "High Filter "
                        + uniqueCode;


        String lowTask =
                "Low Filter "
                        + uniqueCode;


        /*
         * Create high-priority task
         */
        createTask(
                highTask,
                "High priority filter testing.",
                "Testing",
                "High",
                LocalDate.now()
                        .plusDays(3)
        );


        /*
         * Create low-priority task
         */
        createTask(
                lowTask,
                "Low priority filter testing.",
                "Testing",
                "Low",
                LocalDate.now()
                        .plusDays(3)
        );


        /*
         * --------------------------------------------------------
         * TEST HIGH PRIORITY FILTER
         * --------------------------------------------------------
         */

        applyFilters(
                uniqueCode,
                "Pending",
                "High"
        );


        assertTrue(
                taskExists(
                        highTask
                )
        );


        assertFalse(
                taskExists(
                        lowTask
                )
        );


        /*
         * Verify all visible priorities are High
         */
        List<WebElement> priorities =
                driver.findElements(
                        By.cssSelector(
                                ".task-card .priority"
                        )
                );


        for (WebElement priority
                : priorities) {

            assertEquals(
                    "High",
                    priority.getText()
            );
        }


        /*
         * --------------------------------------------------------
         * TEST PENDING STATUS FILTER
         * --------------------------------------------------------
         */

        openTasksPage();


        applyFilters(
                uniqueCode,
                "Pending",
                "All"
        );


        List<WebElement> statuses =
                driver.findElements(
                        By.cssSelector(
                                ".task-card .status"
                        )
                );


        assertFalse(
                statuses.isEmpty()
        );


        for (WebElement status
                : statuses) {

            assertEquals(
                    "Pending",
                    status.getText()
            );
        }
    }


    /* ============================================================
       TEST CASE 07
       START TASK
       ============================================================ */

    @Test
    @Order(7)
    @DisplayName("TC07_Start_Pending_Task")
    void testStartTask() {

        String title =
                uniqueTitle(
                        "Start Workflow"
                );


        /*
         * Create Pending task
         */
        createTask(
                title,
                "This task will be moved from Pending to In Progress.",
                "Development",
                "High",
                LocalDate.now()
                        .plusDays(3)
        );


        /*
         * Verify initial status
         */
        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                )
        );


        /*
         * Search exact task
         */
        searchExactTask(
                title
        );


        /*
         * Find task card
         */
        WebElement taskCard =
                findTaskCard(
                        title
                );


        /*
         * Verify Start button exists
         */
        assertEquals(
                1,
                taskCard.findElements(
                        By.cssSelector(
                                ".progress-button"
                        )
                ).size()
        );


        /*
         * Click Start Task
         */
        clickTaskAction(
                taskCard,
                ".progress-button"
        );


        /*
         * Verify new status
         */
        assertEquals(
                "In Progress",
                getTaskStatus(
                        title
                )
        );


        /*
         * Search again and verify Start button disappears
         */
        searchExactTask(
                title
        );


        taskCard =
                findTaskCard(
                        title
                );


        assertEquals(
                0,
                taskCard.findElements(
                        By.cssSelector(
                                ".progress-button"
                        )
                ).size()
        );
    }


    /* ============================================================
       TEST CASE 08
       COMPLETE TASK LIFECYCLE
       ============================================================ */

    @Test
    @Order(8)
    @DisplayName("TC08_Verify_Complete_Task_Lifecycle")
    void testCompleteTaskLifecycle() {

        String title =
                uniqueTitle(
                        "Lifecycle Test"
                );


        /*
         * Create task
         */
        createTask(
                title,
                "Verify Pending to In Progress to Completed lifecycle.",
                "Development",
                "High",
                LocalDate.now()
                        .plusDays(6)
        );


        /*
         * --------------------------------------------------------
         * STEP 1 - PENDING
         * --------------------------------------------------------
         */

        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                )
        );


        /*
         * --------------------------------------------------------
         * STEP 2 - IN PROGRESS
         * --------------------------------------------------------
         */

        searchExactTask(
                title
        );


        WebElement taskCard =
                findTaskCard(
                        title
                );


        clickTaskAction(
                taskCard,
                ".progress-button"
        );


        assertEquals(
                "In Progress",
                getTaskStatus(
                        title
                )
        );


        /*
         * --------------------------------------------------------
         * STEP 3 - COMPLETED
         * --------------------------------------------------------
         */

        searchExactTask(
                title
        );


        taskCard =
                findTaskCard(
                        title
                );


        clickTaskAction(
                taskCard,
                ".complete-button"
        );


        assertEquals(
                "Completed",
                getTaskStatus(
                        title
                )
        );


        /*
         * --------------------------------------------------------
         * VERIFY COMPLETED TASK BUTTONS
         * --------------------------------------------------------
         */

        searchExactTask(
                title
        );


        taskCard =
                findTaskCard(
                        title
                );


        /*
         * Completed task should not have Start button
         */
        assertEquals(
                0,
                taskCard.findElements(
                        By.cssSelector(
                                ".progress-button"
                        )
                ).size()
        );


        /*
         * Completed task should not have Complete button
         */
        assertEquals(
                0,
                taskCard.findElements(
                        By.cssSelector(
                                ".complete-button"
                        )
                ).size()
        );


        /*
         * Delete should still exist
         */
        assertEquals(
                1,
                taskCard.findElements(
                        By.cssSelector(
                                ".delete-button"
                        )
                ).size()
        );


        /*
         * --------------------------------------------------------
         * VERIFY COMPLETED FILTER
         * --------------------------------------------------------
         */

        openTasksPage();


        applyFilters(
                title,
                "Completed",
                "All"
        );


        assertTrue(
                taskExists(
                        title
                )
        );


        assertEquals(
                "Completed",
                getTaskStatus(
                        title
                )
        );
    }


    /* ============================================================
       TEST CASE 09
       DELETE TASK
       ============================================================ */

    @Test
    @Order(9)
    @DisplayName("TC09_Verify_Task_Deletion")
    void testTaskDeletion() {

        String title =
                uniqueTitle(
                        "Delete Test"
                );


        /*
         * Create test task
         */
        createTask(
                title,
                "This task is created to test delete functionality.",
                "Testing",
                "Medium",
                LocalDate.now()
                        .plusDays(4)
        );


        /*
         * --------------------------------------------------------
         * CANCEL DELETE
         * --------------------------------------------------------
         */

        searchExactTask(
                title
        );


        WebElement taskCard =
                findTaskCard(
                        title
                );


        taskCard.findElement(
                By.cssSelector(
                        ".delete-button"
                )
        ).click();


        /*
         * Wait for JavaScript confirmation
         */
        Alert alert =
                wait.until(
                        ExpectedConditions
                                .alertIsPresent()
                );


        System.out.println(
                "Delete Alert Message : "
                        + alert.getText()
        );


        /*
         * Cancel deletion
         */
        alert.dismiss();


        /*
         * Task should still exist
         */
        assertTrue(
                taskExists(
                        title
                )
        );


        /*
         * --------------------------------------------------------
         * CONFIRM DELETE
         * --------------------------------------------------------
         */

        taskCard =
                findTaskCard(
                        title
                );


        WebElement oldBody =
                driver.findElement(
                        By.tagName(
                                "body"
                        )
                );


        taskCard.findElement(
                By.cssSelector(
                        ".delete-button"
                )
        ).click();


        alert =
                wait.until(
                        ExpectedConditions
                                .alertIsPresent()
                );


        /*
         * Confirm deletion
         */
        alert.accept();


        /*
         * Wait for servlet redirect
         */
        wait.until(
                ExpectedConditions
                        .stalenessOf(
                                oldBody
                        )
        );


        waitForPageReady();


        /*
         * Search deleted task
         */
        searchTaskByQuery(
                title
        );


        /*
         * Verify task no longer exists
         */
        assertFalse(
                taskExists(
                        title
                )
        );


        /*
         * Remove task from cleanup list because
         * it is already deleted.
         */
        createdTasks.remove(
                title
        );
    }


    /* ============================================================
       TEST CASE 10
       RESET FILTERS AND SORT TASKS BY DATE
       ============================================================ */

    @Test
    @Order(10)
    @DisplayName("TC10_Reset_Filters_And_Sort_By_Date")
    void testResetAndDateSorting() {

        /*
         * Unique code identifies only this test's tasks.
         */
        String code =
                UUID.randomUUID()
                        .toString()
                        .substring(
                                0,
                                8
                        );


        String earlierTask =
                "Earlier Task "
                        + code;


        String laterTask =
                "Later Task "
                        + code;


        /*
         * Create task with later date first
         */
        createTask(
                laterTask,
                "Task with later due date.",
                "Testing",
                "Medium",
                LocalDate.now()
                        .plusDays(15)
        );


        /*
         * Create task with earlier date second
         */
        createTask(
                earlierTask,
                "Task with earlier due date.",
                "Testing",
                "Medium",
                LocalDate.now()
                        .plusDays(5)
        );


        /*
         * --------------------------------------------------------
         * TEST RESET FILTERS
         * --------------------------------------------------------
         */

        applyFilters(
                code,
                "Pending",
                "Medium"
        );


        WebElement oldBody =
                driver.findElement(
                        By.tagName(
                                "body"
                        )
                );


        driver.findElement(
                By.id(
                        "resetButton"
                )
        ).click();


        wait.until(
                ExpectedConditions
                        .stalenessOf(
                                oldBody
                        )
        );


        waitForPageReady();


        /*
         * Search should become empty
         */
        assertEquals(
                "",
                driver.findElement(
                        By.id(
                                "searchTask"
                        )
                ).getAttribute(
                        "value"
                )
        );


        /*
         * Status should return to All
         */
        assertEquals(
                "All",
                new Select(
                        driver.findElement(
                                By.id(
                                        "statusFilter"
                                )
                        )
                )
                .getFirstSelectedOption()
                .getAttribute(
                        "value"
                )
        );


        /*
         * Priority should return to All
         */
        assertEquals(
                "All",
                new Select(
                        driver.findElement(
                                By.id(
                                        "priorityFilter"
                                )
                        )
                )
                .getFirstSelectedOption()
                .getAttribute(
                        "value"
                )
        );


        /*
         * --------------------------------------------------------
         * TEST DATE SORTING
         * --------------------------------------------------------
         */

        driver.findElement(
                By.id(
                        "dateViewButton"
                )
        ).click();


        int earlierPosition =
                findTaskPosition(
                        earlierTask
                );


        int laterPosition =
                findTaskPosition(
                        laterTask
                );


        System.out.println(
                "Earlier Task Position : "
                        + earlierPosition
        );


        System.out.println(
                "Later Task Position   : "
                        + laterPosition
        );


        assertTrue(
                earlierPosition >= 0,
                "Earlier task should exist"
        );


        assertTrue(
                laterPosition >= 0,
                "Later task should exist"
        );


        assertTrue(
                earlierPosition
                        < laterPosition,
                "Task with earlier due date should appear first"
        );
    }


    /* ============================================================
       HELPER METHOD
       OPEN NORMAL TASK PAGE
       ============================================================ */

    private void openTasksPage() {

        driver.get(
                BASE_URL
                        + "/tasks"
        );


        waitForPageReady();


        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                By.id(
                                        "taskGrid"
                                )
                        )
        );
    }


    /* ============================================================
       HELPER METHOD
       WAIT UNTIL WEB PAGE FINISHES LOADING
       ============================================================ */

    private void waitForPageReady() {

        wait.until(
                webDriver -> {

                    Object readyState =
                            ((JavascriptExecutor)
                                    webDriver)
                                    .executeScript(
                                            "return document.readyState"
                                    );


                    return "complete"
                            .equals(
                                    readyState
                            );
                }
        );
    }


    /* ============================================================
       HELPER METHOD
       CHECK WHETHER ELEMENT IS DISPLAYED
       ============================================================ */

    private boolean isDisplayed(
            By locator) {

        try {

            WebElement element =
                    wait.until(
                            ExpectedConditions
                                    .visibilityOfElementLocated(
                                            locator
                                    )
                    );


            return element.isDisplayed();

        } catch (Exception exception) {

            return false;
        }
    }


    /* ============================================================
       HELPER METHOD
       OPEN CREATE TASK MODAL
       ============================================================ */

    private void openCreateModal() {

        WebElement button =
                wait.until(
                        ExpectedConditions
                                .elementToBeClickable(
                                        By.id(
                                                "openTaskModalButton"
                                        )
                                )
                );


        button.click();


        wait.until(
                ExpectedConditions
                        .visibilityOfElementLocated(
                                By.id(
                                        "taskModal"
                                )
                        )
        );
    }


    /* ============================================================
       HELPER METHOD
       CREATE TASK
       ============================================================ */

    private void createTask(
            String title,
            String description,
            String category,
            String priority,
            LocalDate dueDate) {

        /*
         * Return to unfiltered page
         */
        openTasksPage();


        /*
         * Open Create Task modal
         */
        openCreateModal();


        /*
         * --------------------------------------------------------
         * ENTER TITLE
         * --------------------------------------------------------
         */

        WebElement titleInput =
                driver.findElement(
                        By.id(
                                "taskTitle"
                        )
                );


        titleInput.clear();


        titleInput.sendKeys(
                title
        );


        /*
         * --------------------------------------------------------
         * ENTER DESCRIPTION
         * --------------------------------------------------------
         */

        WebElement descriptionInput =
                driver.findElement(
                        By.id(
                                "taskDescription"
                        )
                );


        descriptionInput.clear();


        descriptionInput.sendKeys(
                description
        );


        /*
         * --------------------------------------------------------
         * SELECT CATEGORY
         * --------------------------------------------------------
         */

        Select categorySelect =
                new Select(
                        driver.findElement(
                                By.id(
                                        "taskCategory"
                                )
                        )
                );


        categorySelect.selectByValue(
                category
        );


        /*
         * --------------------------------------------------------
         * SELECT PRIORITY
         * --------------------------------------------------------
         */

        Select prioritySelect =
                new Select(
                        driver.findElement(
                                By.id(
                                        "taskPriority"
                                )
                        )
                );


        prioritySelect.selectByValue(
                priority
        );


        /*
         * --------------------------------------------------------
         * ENTER DUE DATE
         * --------------------------------------------------------
         */

        if (dueDate != null) {

            setDateValue(
                    "taskDueDate",
                    dueDate.toString()
            );
        }


        /*
         * Save body reference so Selenium can detect
         * servlet redirect.
         */
        WebElement oldBody =
                driver.findElement(
                        By.tagName(
                                "body"
                        )
                );


        /*
         * Submit Create Task form
         */
        driver.findElement(
                By.id(
                        "createTaskButton"
                )
        ).click();


        /*
         * Wait until old page disappears
         */
        wait.until(
                ExpectedConditions
                        .stalenessOf(
                                oldBody
                        )
        );


        /*
         * Wait for new dashboard
         */
        waitForPageReady();


        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                By.id(
                                        "taskGrid"
                                )
                        )
        );


        /*
         * Store task so AfterEach can remove it
         */
        createdTasks.add(
                title
        );


        /*
         * Verify newly created task exists
         */
        assertTrue(
                taskExists(
                        title
                ),
                "Newly created task should be displayed"
        );
    }


    /* ============================================================
       HELPER METHOD
       SET DATE FIELD
       ============================================================ */

    private void setDateValue(
            String elementId,
            String value) {

        WebElement dateElement =
                driver.findElement(
                        By.id(
                                elementId
                        )
                );


        /*
         * JavaScript is used because HTML date inputs
         * behave differently on different machines/browsers.
         */
        ((JavascriptExecutor) driver)
                .executeScript(

                        "arguments[0].value = arguments[1];"
                                +
                        "arguments[0].dispatchEvent("
                                +
                        "new Event('input',{bubbles:true})"
                                +
                        ");"
                                +
                        "arguments[0].dispatchEvent("
                                +
                        "new Event('change',{bubbles:true})"
                                +
                        ");",

                        dateElement,
                        value
                );
    }


    /* ============================================================
       HELPER METHOD
       SEARCH TASK USING QUERY
       ============================================================ */

    private void searchTaskByQuery(
            String query) {

        applyFilters(
                query,
                "All",
                "All"
        );
    }


    /* ============================================================
       HELPER METHOD
       SEARCH EXACT TASK
       ============================================================ */

    private void searchExactTask(
            String title) {

        applyFilters(
                title,
                "All",
                "All"
        );


        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                taskTitleLocator(
                                        title
                                )
                        )
        );
    }


    /* ============================================================
       HELPER METHOD
       APPLY SEARCH / STATUS / PRIORITY FILTER
       ============================================================ */

    private void applyFilters(
            String searchText,
            String status,
            String priority) {

        /*
         * Find search field
         */
        WebElement search =
                driver.findElement(
                        By.id(
                                "searchTask"
                        )
                );


        /*
         * Remove existing search
         */
        search.clear();


        /*
         * Add new search value
         */
        if (searchText != null
                && !searchText.isBlank()) {

            search.sendKeys(
                    searchText
            );
        }


        /*
         * Select status
         */
        Select statusSelect =
                new Select(
                        driver.findElement(
                                By.id(
                                        "statusFilter"
                                )
                        )
                );


        statusSelect.selectByValue(
                status
        );


        /*
         * Select priority
         */
        Select prioritySelect =
                new Select(
                        driver.findElement(
                                By.id(
                                        "priorityFilter"
                                )
                        )
                );


        prioritySelect.selectByValue(
                priority
        );


        /*
         * Save current page reference
         */
        WebElement oldBody =
                driver.findElement(
                        By.tagName(
                                "body"
                        )
                );


        /*
         * Apply filters
         */
        driver.findElement(
                By.id(
                        "searchButton"
                )
        ).click();


        /*
         * Wait for server response
         */
        wait.until(
                ExpectedConditions
                        .stalenessOf(
                                oldBody
                        )
        );


        waitForPageReady();


        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                By.id(
                                        "taskGrid"
                                )
                        )
        );
    }


    /* ============================================================
       HELPER METHOD
       CREATE EXACT TASK TITLE LOCATOR
       ============================================================ */

    private By taskTitleLocator(
            String title) {

        return By.xpath(
                "//*[contains(@class,'task-title')"
                        +
                        " and normalize-space(.)="
                        +
                        xpathLiteral(
                                title
                        )
                        +
                        "]"
        );
    }


    /* ============================================================
       HELPER METHOD
       SAFE XPATH STRING
       ============================================================ */

    private String xpathLiteral(
            String text) {

        /*
         * Text without single quotation mark
         */
        if (!text.contains("'")) {

            return "'"
                    + text
                    + "'";
        }


        /*
         * Text without double quotation mark
         */
        if (!text.contains("\"")) {

            return "\""
                    + text
                    + "\"";
        }


        /*
         * Text contains both quote types.
         * Construct XPath concat expression.
         */
        StringBuilder xpath =
                new StringBuilder(
                        "concat("
                );


        String[] parts =
                text.split(
                        "'",
                        -1
                );


        for (int index = 0;
             index < parts.length;
             index++) {

            if (index > 0) {

                xpath.append(
                        ",\"'\","
                );
            }


            xpath.append(
                    "'"
            );


            xpath.append(
                    parts[index]
            );


            xpath.append(
                    "'"
            );
        }


        xpath.append(
                ")"
        );


        return xpath.toString();
    }


    /* ============================================================
       HELPER METHOD
       CHECK IF TASK EXISTS
       ============================================================ */

    private boolean taskExists(
            String title) {

        List<WebElement> tasks =
                driver.findElements(
                        taskTitleLocator(
                                title
                        )
                );


        return !tasks.isEmpty();
    }


    /* ============================================================
       HELPER METHOD
       FIND COMPLETE TASK CARD
       ============================================================ */

    private WebElement findTaskCard(
            String title) {

        WebElement titleElement =
                wait.until(
                        ExpectedConditions
                                .presenceOfElementLocated(
                                        taskTitleLocator(
                                                title
                                        )
                                )
                );


        /*
         * Move upward from task title to complete card
         */
        return titleElement.findElement(
                By.xpath(
                        "./ancestor::*["
                                +
                        "contains(@class,'task-card')"
                                +
                        "][1]"
                )
        );
    }


    /* ============================================================
       HELPER METHOD
       GET TASK STATUS
       ============================================================ */

    private String getTaskStatus(
            String title) {

        WebElement taskCard =
                findTaskCard(
                        title
                );


        WebElement statusElement =
                taskCard.findElement(
                        By.cssSelector(
                                ".status"
                        )
                );


        return statusElement
                .getText()
                .trim();
    }


    /* ============================================================
       HELPER METHOD
       CLICK TASK ACTION
       ============================================================ */

    private void clickTaskAction(
            WebElement taskCard,
            String buttonSelector) {

        /*
         * Save current page
         */
        WebElement oldBody =
                driver.findElement(
                        By.tagName(
                                "body"
                        )
                );


        /*
         * Locate action button
         */
        WebElement button =
                taskCard.findElement(
                        By.cssSelector(
                                buttonSelector
                        )
                );


        /*
         * Click action
         */
        button.click();


        /*
         * Wait for Servlet redirect
         */
        wait.until(
                ExpectedConditions
                        .stalenessOf(
                                oldBody
                        )
        );


        /*
         * Wait for dashboard
         */
        waitForPageReady();


        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                By.id(
                                        "taskGrid"
                                )
                        )
        );
    }


    /* ============================================================
       HELPER METHOD
       READ DASHBOARD COUNTER
       ============================================================ */

    private int readCounter(
            String elementId) {

        WebElement counter =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                elementId
                                        )
                                )
                );


        String text =
                counter.getText()
                        .trim();


        return Integer.parseInt(
                text
        );
    }


    /* ============================================================
       HELPER METHOD
       FIND TASK POSITION
       ============================================================ */

    private int findTaskPosition(
            String title) {

        List<WebElement> taskCards =
                driver.findElements(
                        By.cssSelector(
                                "#taskGrid .task-card"
                        )
                );


        for (int index = 0;
             index < taskCards.size();
             index++) {


            List<WebElement> titleElements =
                    taskCards.get(
                            index
                    ).findElements(
                            By.cssSelector(
                                    ".task-title"
                            )
                    );


            if (!titleElements.isEmpty()) {


                String currentTitle =
                        titleElements
                                .get(0)
                                .getText()
                                .trim();


                if (currentTitle.equals(
                        title
                )) {

                    return index;
                }
            }
        }


        return -1;
    }


    /* ============================================================
       HELPER METHOD
       GENERATE UNIQUE TASK TITLE
       ============================================================ */

    private String uniqueTitle(
            String prefix) {

        /*
         * UUID prevents duplicate Selenium task names.
         */
        String randomCode =
                UUID.randomUUID()
                        .toString()
                        .substring(
                                0,
                                8
                        );


        return prefix
                + " "
                + randomCode;
    }


    /* ============================================================
       HELPER METHOD
       SCREENSHOT
       ============================================================ */

    private void takeScreenshot(
            String testName)
            throws Exception {

        /*
         * Skip if browser does not exist
         */
        if (driver == null) {

            return;
        }


        /*
         * Screenshot directory
         */
        Path screenshotDirectory =
                Path.of(
                        "target",
                        "selenium-screenshots"
                );


        /*
         * Create directory if necessary
         */
        Files.createDirectories(
                screenshotDirectory
        );


        /*
         * Convert test name into safe filename
         */
        String safeFileName =
                testName.replaceAll(
                        "[^a-zA-Z0-9._-]",
                        "_"
                );


        /*
         * Capture screenshot
         */
        File source =
                ((TakesScreenshot) driver)
                        .getScreenshotAs(
                                OutputType.FILE
                        );


        /*
         * Screenshot destination
         */
        Path destination =
                screenshotDirectory.resolve(
                        safeFileName
                                + ".png"
                );


        /*
         * Copy screenshot
         */
        Files.copy(
                source.toPath(),
                destination,
                StandardCopyOption.REPLACE_EXISTING
        );


        System.out.println(
                "Screenshot Saved : "
                        + destination
        );
    }


    /* ============================================================
       HELPER METHOD
       AUTOMATIC SELENIUM TEST DATA CLEANUP
       ============================================================ */

    private void cleanupCreatedTasks() {

        /*
         * Make separate copy of task list.
         */
        List<String> cleanupList =
                new ArrayList<>(
                        createdTasks
                );


        /*
         * Process every Selenium-created task.
         */
        for (String title
                : cleanupList) {


            try {

                /*
                 * Open clean dashboard
                 */
                openTasksPage();


                /*
                 * Enter title into search
                 */
                WebElement search =
                        driver.findElement(
                                By.id(
                                        "searchTask"
                                )
                        );


                search.clear();


                search.sendKeys(
                        title
                );


                /*
                 * Save page before search
                 */
                WebElement oldBody =
                        driver.findElement(
                                By.tagName(
                                        "body"
                                )
                        );


                /*
                 * Execute search
                 */
                driver.findElement(
                        By.id(
                                "searchButton"
                        )
                ).click();


                /*
                 * Wait for search results
                 */
                wait.until(
                        ExpectedConditions
                                .stalenessOf(
                                        oldBody
                                )
                );


                waitForPageReady();


                /*
                 * Skip if task already deleted
                 */
                if (!taskExists(
                        title
                )) {

                    continue;
                }


                /*
                 * Find task
                 */
                WebElement taskCard =
                        findTaskCard(
                                title
                        );


                /*
                 * Save current page
                 */
                oldBody =
                        driver.findElement(
                                By.tagName(
                                        "body"
                                )
                        );


                /*
                 * Click Delete
                 */
                taskCard.findElement(
                        By.cssSelector(
                                ".delete-button"
                        )
                ).click();


                /*
                 * Confirm deletion
                 */
                Alert alert =
                        wait.until(
                                ExpectedConditions
                                        .alertIsPresent()
                        );


                alert.accept();


                /*
                 * Wait for page refresh
                 */
                wait.until(
                        ExpectedConditions
                                .stalenessOf(
                                        oldBody
                                )
                );


                waitForPageReady();


                System.out.println(
                        "Test Task Removed : "
                                + title
                );


            } catch (Exception exception) {


                /*
                 * Cleanup failure must not cause
                 * the actual test case to fail.
                 */
                System.out.println(
                        "Cleanup Skipped : "
                                + title
                );
            }
        }


        /*
         * Clear Java list
         */
        createdTasks.clear();
    }
}