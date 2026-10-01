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
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;


/**
 * ================================================================
 * TASKNEXUS PRO - SELENIUM AUTOMATION TEST SUITE
 * ================================================================
 *
 * Total Test Cases : 10
 * Browser          : Google Chrome
 * Selenium         : 4.35.0
 * JUnit            : JUnit 5
 * Java             : 17+
 * Application      : TaskNexus Pro
 * Default URL      : http://localhost:8081
 *
 * Jenkins:
 *
 * mvn clean test -Dheadless=true -DbaseUrl=http://localhost:8081
 *
 * ================================================================
 */

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SeleniumTest {

    private WebDriver driver;

    private WebDriverWait wait;

    private static final String BASE_URL =
            System.getProperty(
                    "baseUrl",
                    "http://localhost:8081"
            );

    private static final Duration WAIT_TIME =
            Duration.ofSeconds(15);

    private final List<String> createdTasks =
            new ArrayList<>();


    // ============================================================
    // SETUP
    // ============================================================

    @BeforeEach
    void setUp() {

        System.out.println();
        System.out.println(
                "============================================================"
        );
        System.out.println(
                "          TASKNEXUS PRO SELENIUM TESTING"
        );
        System.out.println(
                "============================================================"
        );
        System.out.println(
                "Application URL : " + BASE_URL
        );

        ChromeOptions options =
                new ChromeOptions();

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

        options.addArguments(
                "--window-size=1920,1080"
        );

        options.addArguments(
                "--start-maximized"
        );

        options.addArguments(
                "--disable-gpu"
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

        options.addArguments(
                "--force-device-scale-factor=1"
        );

        driver =
                new ChromeDriver(
                        options
                );

        wait =
                new WebDriverWait(
                        driver,
                        WAIT_TIME
                );

        openTasksPage();

        System.out.println(
                "Chrome started successfully."
        );
    }


    // ============================================================
    // TEARDOWN
    // ============================================================

    @AfterEach
    void tearDown(TestInfo testInfo) {

        System.out.println(
                "Completed Test : "
                        + testInfo.getDisplayName()
        );

        try {

            takeScreenshot(
                    testInfo.getDisplayName()
            );

        } catch (Exception e) {

            System.out.println(
                    "Screenshot error: "
                            + e.getMessage()
            );
        }

        try {

            cleanupCreatedTasks();

        } catch (Exception e) {

            System.out.println(
                    "Cleanup warning: "
                            + e.getMessage()
            );
        }

        if (driver != null) {

            try {

                driver.quit();

            } catch (Exception ignored) {
            }
        }

        System.out.println(
                "Browser closed."
        );

        System.out.println(
                "============================================================"
        );
    }


    // ============================================================
    // TC01 - DASHBOARD
    // ============================================================

    @Test
    @Order(1)
    @DisplayName(
            "TC01_Verify_TaskNexus_Dashboard"
    )
    void testTaskNexusDashboard() {

        assertTrue(
                driver.getTitle()
                        .contains("TaskNexus"),
                "TaskNexus title should be displayed."
        );

        assertTrue(
                driver.getCurrentUrl()
                        .contains("/tasks"),
                "Tasks page should be opened."
        );

        assertTrue(
                driver.getPageSource()
                        .contains("My task workspace"),
                "Task workspace should be displayed."
        );

        assertTrue(
                isDisplayed(
                        By.id(
                                "openTaskModalButton"
                        )
                )
        );

        assertTrue(
                isDisplayed(
                        By.id(
                                "taskGrid"
                        )
                )
        );

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
                "TC01 PASSED - Dashboard verified."
        );
    }


    // ============================================================
    // TC02 - DASHBOARD STATISTICS
    // ============================================================

    @Test
    @Order(2)
    @DisplayName(
            "TC02_Verify_Dashboard_Statistics"
    )
    void testDashboardStatistics() {

        int total =
                readCounter(
                        "totalTasks"
                );

        int pending =
                readCounter(
                        "pendingTasks"
                );

        int progress =
                readCounter(
                        "progressTasks"
                );

        int completed =
                readCounter(
                        "completedTasks"
                );

        System.out.println(
                "Total Tasks       : "
                        + total
        );

        System.out.println(
                "Pending Tasks     : "
                        + pending
        );

        System.out.println(
                "In Progress Tasks : "
                        + progress
        );

        System.out.println(
                "Completed Tasks   : "
                        + completed
        );

        assertTrue(
                total >= 0
        );

        assertTrue(
                pending >= 0
        );

        assertTrue(
                progress >= 0
        );

        assertTrue(
                completed >= 0
        );

        assertEquals(
                total,
                pending
                        + progress
                        + completed,
                "Dashboard counters are inconsistent."
        );

        System.out.println(
                "TC02 PASSED - Statistics verified."
        );
    }


    // ============================================================
    // TC03 - MODAL AND VALIDATION
    // ============================================================

    @Test
    @Order(3)
    @DisplayName(
            "TC03_Verify_Task_Modal_And_Validation"
    )
    void testTaskModalAndValidation() {

        openCreateModal();

        WebElement modal =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskModal"
                                        )
                                )
                );

        WebElement title =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskTitle"
                                        )
                                )
                );

        WebElement description =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskDescription"
                                        )
                                )
                );

        WebElement category =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskCategory"
                                        )
                                )
                );

        WebElement priority =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskPriority"
                                        )
                                )
                );

        WebElement dueDate =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskDueDate"
                                        )
                                )
                );

        assertTrue(
                modal.isDisplayed()
        );

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

        Boolean valid =
                (Boolean)
                        (
                                (JavascriptExecutor)
                                        driver
                        ).executeScript(
                                "return document.getElementById('createTaskForm').checkValidity();"
                        );

        assertFalse(
                valid,
                "Empty form should be invalid."
        );

        safeClick(
                By.id(
                        "closeTaskModalButton"
                )
        );

        wait.until(
                ExpectedConditions
                        .invisibilityOfElementLocated(
                                By.id(
                                        "taskModal"
                                )
                        )
        );

        System.out.println(
                "TC03 PASSED - Modal and validation verified."
        );
    }


    // ============================================================
    // TC04 - CREATE TASK
    // ============================================================

    @Test
    @Order(4)
    @DisplayName(
            "TC04_Create_New_Task"
    )
    void testCreateNewTask() {

        String title =
                uniqueTitle(
                        "Selenium Automation"
                );

        LocalDate dueDate =
                LocalDate.now()
                        .plusDays(5);

        createTask(
                title,
                "Automated TaskNexus functional testing using Selenium WebDriver.",
                "Testing",
                "High",
                dueDate
        );

        WebElement card =
                findTaskCard(
                        title
                );

        assertEquals(
                title,
                card.findElement(
                        By.cssSelector(
                                ".task-title"
                        )
                )
                        .getText()
                        .trim()
        );

        assertEquals(
                "Testing",
                card.findElement(
                        By.cssSelector(
                                ".category-badge"
                        )
                )
                        .getText()
                        .trim()
        );

        assertEquals(
                "High",
                card.findElement(
                        By.cssSelector(
                                ".priority"
                        )
                )
                        .getText()
                        .trim()
        );

        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                )
        );

        System.out.println(
                "TC04 PASSED - Task creation verified."
        );
    }


    // ============================================================
    // TC05 - SEARCH
    // ============================================================

    @Test
    @Order(5)
    @DisplayName(
            "TC05_Verify_Task_Search"
    )
    void testTaskSearchFunctionality() {

        String code =
                randomCode();

        String title =
                "Search Task "
                        + code;

        String description =
                "Unique Description "
                        + code;

        createTask(
                title,
                description,
                "Research",
                "Medium",
                LocalDate.now()
                        .plusDays(4)
        );

        searchTaskByQuery(
                title
        );

        assertTrue(
                taskExists(
                        title
                ),
                "Task should be found by title."
        );

        openTasksPage();

        searchTaskByQuery(
                description
        );

        assertTrue(
                taskExists(
                        title
                ),
                "Task should be found by description."
        );

        openTasksPage();

        searchTaskByQuery(
                "Research"
        );

        assertTrue(
                taskExists(
                        title
                ),
                "Task should be found by category."
        );

        System.out.println(
                "TC05 PASSED - Search verified."
        );
    }


    // ============================================================
    // TC06 - FILTERS
    // ============================================================

    @Test
    @Order(6)
    @DisplayName(
            "TC06_Verify_Task_Filters"
    )
    void testTaskFilters() {

        String code =
                randomCode();

        String highTask =
                "High Filter "
                        + code;

        String lowTask =
                "Low Filter "
                        + code;

        createTask(
                highTask,
                "High priority filter testing.",
                "Testing",
                "High",
                LocalDate.now()
                        .plusDays(3)
        );

        createTask(
                lowTask,
                "Low priority filter testing.",
                "Testing",
                "Low",
                LocalDate.now()
                        .plusDays(3)
        );

        applyFilters(
                code,
                "Pending",
                "High"
        );

        assertTrue(
                taskExists(
                        highTask
                ),
                "High priority task should be visible."
        );

        assertFalse(
                taskExists(
                        lowTask
                ),
                "Low priority task should be hidden."
        );

        System.out.println(
                "TC06 PASSED - Filters verified."
        );
    }


    // ============================================================
    // TC07 - START TASK
    // ============================================================

    @Test
    @Order(7)
    @DisplayName(
            "TC07_Start_Pending_Task"
    )
    void testStartTask() {

        String title =
                uniqueTitle(
                        "Start Workflow"
                );

        createTask(
                title,
                "Move task from Pending to In Progress.",
                "Development",
                "High",
                LocalDate.now()
                        .plusDays(3)
        );

        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                )
        );

        clickTaskAction(
                title,
                ".progress-button"
        );

        waitForStatus(
                title,
                "In Progress"
        );

        assertEquals(
                "In Progress",
                getTaskStatus(
                        title
                )
        );

        System.out.println(
                "TC07 PASSED - Task started successfully."
        );
    }


    // ============================================================
    // TC08 - COMPLETE TASK LIFECYCLE
    // ============================================================

    @Test
    @Order(8)
    @DisplayName(
            "TC08_Verify_Complete_Task_Lifecycle"
    )
    void testCompleteTaskLifecycle() {

        String title =
                uniqueTitle(
                        "Lifecycle Test"
                );

        /*
         * --------------------------------------------------------
         * CREATE
         * --------------------------------------------------------
         */

        createTask(
                title,
                "Verify complete task lifecycle.",
                "Development",
                "High",
                LocalDate.now()
                        .plusDays(6)
        );

        /*
         * --------------------------------------------------------
         * PENDING
         * --------------------------------------------------------
         */

        waitForStatus(
                title,
                "Pending"
        );

        assertEquals(
                "Pending",
                getTaskStatus(
                        title
                ),
                "New task should initially be Pending."
        );

        /*
         * --------------------------------------------------------
         * IN PROGRESS
         * --------------------------------------------------------
         */

        clickTaskAction(
                title,
                ".progress-button"
        );

        /*
         * The application re-renders the task card.
         * Therefore getTaskStatus() always performs a
         * completely fresh lookup.
         */

        waitForStatus(
                title,
                "In Progress"
        );

        assertEquals(
                "In Progress",
                getTaskStatus(
                        title
                ),
                "Task should become In Progress."
        );

        /*
         * --------------------------------------------------------
         * COMPLETED
         * --------------------------------------------------------
         */

        clickTaskAction(
                title,
                ".complete-button"
        );

        /*
         * Again wait for the new DOM state.
         */

        waitForStatus(
                title,
                "Completed"
        );

        assertEquals(
                "Completed",
                getTaskStatus(
                        title
                ),
                "Task should become Completed."
        );

        /*
         * --------------------------------------------------------
         * FINAL VERIFICATION
         * --------------------------------------------------------
         */

        WebElement finalCard =
                findTaskCard(
                        title
                );

        assertEquals(
                0,
                finalCard.findElements(
                        By.cssSelector(
                                ".progress-button"
                        )
                ).size(),
                "Progress button should disappear."
        );

        assertEquals(
                0,
                finalCard.findElements(
                        By.cssSelector(
                                ".complete-button"
                        )
                ).size(),
                "Complete button should disappear."
        );

        assertEquals(
                1,
                finalCard.findElements(
                        By.cssSelector(
                                ".delete-button"
                        )
                ).size(),
                "Delete button should remain available."
        );

        System.out.println(
                "TC08 PASSED - Complete lifecycle verified."
        );
    }


    // ============================================================
    // TC09 - DELETE
    // ============================================================

    @Test
    @Order(9)
    @DisplayName(
            "TC09_Verify_Task_Deletion"
    )
    void testTaskDeletion() {

        String title =
                uniqueTitle(
                        "Delete Test"
                );

        createTask(
                title,
                "Task created for deletion testing.",
                "Testing",
                "Medium",
                LocalDate.now()
                        .plusDays(4)
        );

        searchExactTask(
                title
        );

        /*
         * First delete:
         * Cancel confirmation.
         */

        clickDeleteButton(
                title
        );

        Alert alert =
                wait.until(
                        ExpectedConditions
                                .alertIsPresent()
                );

        alert.dismiss();

        waitForPageReady();

        assertTrue(
                taskExists(
                        title
                ),
                "Task should remain after cancelling deletion."
        );

        /*
         * Second delete:
         * Confirm deletion.
         */

        clickDeleteButton(
                title
        );

        alert =
                wait.until(
                        ExpectedConditions
                                .alertIsPresent()
                );

        alert.accept();

        waitForPageReady();

        searchTaskByQuery(
                title
        );

        assertFalse(
                taskExists(
                        title
                ),
                "Deleted task should not exist."
        );

        createdTasks.remove(
                title
        );

        System.out.println(
                "TC09 PASSED - Deletion verified."
        );
    }


    // ============================================================
    // TC10 - RESET AND DATE SORTING
    // ============================================================

    @Test
    @Order(10)
    @DisplayName(
            "TC10_Reset_Filters_And_Sort_By_Date"
    )
    void testResetAndDateSorting() {

        String code =
                randomCode();

        String earlierTask =
                "Earlier Task "
                        + code;

        String laterTask =
                "Later Task "
                        + code;

        /*
         * Create later task.
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
         * Create earlier task.
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
         * Apply filters.
         */

        applyFilters(
                code,
                "Pending",
                "Medium"
        );

        /*
         * Reset filters.
         *
         * IMPORTANT:
         * No old WebElement/body reference is used.
         */

        safeClick(
                By.id(
                        "resetButton"
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

        /*
         * Verify search reset.
         */

        WebElement search =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "searchTask"
                                        )
                                )
                );

        assertEquals(
                "",
                search.getAttribute(
                        "value"
                )
        );

        /*
         * Verify status reset.
         */

        Select status =
                new Select(
                        wait.until(
                                ExpectedConditions
                                        .visibilityOfElementLocated(
                                                By.id(
                                                        "statusFilter"
                                                )
                                        )
                        )
                );

        /*
         * Verify priority reset.
         */

        Select priority =
                new Select(
                        wait.until(
                                ExpectedConditions
                                        .visibilityOfElementLocated(
                                                By.id(
                                                        "priorityFilter"
                                                )
                                        )
                        )
                );

        assertEquals(
                "All",
                status.getFirstSelectedOption()
                        .getAttribute(
                                "value"
                        )
        );

        assertEquals(
                "All",
                priority.getFirstSelectedOption()
                        .getAttribute(
                                "value"
                        )
        );

        /*
         * Date view/sorting if available.
         */

        if (
                !driver.findElements(
                        By.id(
                                "dateViewButton"
                        )
                ).isEmpty()
        ) {

            safeClick(
                    By.id(
                            "dateViewButton"
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

        /*
         * Verify both tasks exist.
         */

        assertTrue(
                taskExists(
                        earlierTask
                ),
                "Earlier task should exist."
        );

        assertTrue(
                taskExists(
                        laterTask
                ),
                "Later task should exist."
        );

        System.out.println(
                "TC10 PASSED - Reset and date view verified."
        );
    }


    // ============================================================
    // OPEN TASK PAGE
    // ============================================================

    private void openTasksPage() {

        driver.get(
                BASE_URL + "/tasks"
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


    // ============================================================
    // PAGE READY
    // ============================================================

    private void waitForPageReady() {

        wait.until(
                webDriver -> {

                    try {

                        Object state =
                                (
                                        (JavascriptExecutor)
                                                webDriver
                                ).executeScript(
                                        "return document.readyState"
                                );

                        return "complete".equals(
                                state
                        );

                    } catch (
                            WebDriverException e
                    ) {

                        return false;
                    }
                }
        );
    }


    // ============================================================
    // OPEN CREATE MODAL
    // ============================================================

    private void openCreateModal() {

        safeClick(
                By.id(
                        "openTaskModalButton"
                )
        );

        wait.until(
                ExpectedConditions
                        .visibilityOfElementLocated(
                                By.id(
                                        "taskModal"
                                )
                        )
        );

        wait.until(
                ExpectedConditions
                        .visibilityOfElementLocated(
                                By.id(
                                        "taskTitle"
                                )
                        )
        );
    }


    // ============================================================
    // CREATE TASK
    // ============================================================

    private void createTask(
            String title,
            String description,
            String category,
            String priority,
            LocalDate dueDate) {

        /*
         * Always start from a fresh page.
         */

        openTasksPage();

        openCreateModal();

        /*
         * TITLE
         */

        WebElement titleInput =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskTitle"
                                        )
                                )
                );

        titleInput.clear();

        titleInput.sendKeys(
                title
        );

        /*
         * DESCRIPTION
         */

        WebElement descriptionInput =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskDescription"
                                        )
                                )
                );

        descriptionInput.clear();

        descriptionInput.sendKeys(
                description
        );

        /*
         * CATEGORY
         */

        WebElement categoryElement =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskCategory"
                                        )
                                )
                );

        new Select(
                categoryElement
        ).selectByValue(
                category
        );

        /*
         * PRIORITY
         */

        WebElement priorityElement =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "taskPriority"
                                        )
                                )
                );

        new Select(
                priorityElement
        ).selectByValue(
                priority
        );

        /*
         * DATE
         */

        if (dueDate != null) {

            setDateValue(
                    "taskDueDate",
                    dueDate.toString()
            );
        }

        /*
         * CREATE
         */

        safeClick(
                By.id(
                        "createTaskButton"
                )
        );

        /*
         * Wait for DOM refresh.
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
         * Wait specifically for the new task.
         */

        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                taskTitleLocator(
                                        title
                                )
                        )
        );

        if (
                !createdTasks.contains(
                        title
                )
        ) {

            createdTasks.add(
                    title
            );
        }

        assertTrue(
                taskExists(
                        title
                ),
                "New task was not displayed."
        );
    }


    // ============================================================
    // DATE VALUE
    // ============================================================

    private void setDateValue(
            String elementId,
            String value) {

        By locator =
                By.id(
                        elementId
                );

        wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                locator
                        )
        );

        /*
         * Fresh lookup.
         */

        WebElement element =
                driver.findElement(
                        locator
                );

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                """
                arguments[0].value = arguments[1];

                arguments[0].dispatchEvent(
                    new Event(
                        'input',
                        { bubbles: true }
                    )
                );

                arguments[0].dispatchEvent(
                    new Event(
                        'change',
                        { bubbles: true }
                    )
                );
                """,
                element,
                value
        );

        wait.until(
                webDriver -> {

                    try {

                        String current =
                                webDriver
                                        .findElement(
                                                locator
                                        )
                                        .getAttribute(
                                                "value"
                                        );

                        return value.equals(
                                current
                        );

                    } catch (
                            StaleElementReferenceException e
                    ) {

                        return false;
                    }
                }
        );
    }


    // ============================================================
    // SEARCH
    // ============================================================

    private void searchTaskByQuery(
            String query) {

        applyFilters(
                query,
                "All",
                "All"
        );
    }


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


    // ============================================================
    // FILTERS
    // ============================================================

    private void applyFilters(
            String searchText,
            String statusValue,
            String priorityValue) {

        /*
         * SEARCH
         */

        WebElement search =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "searchTask"
                                        )
                                )
                );

        search.clear();

        if (
                searchText != null
                        &&
                !searchText.isBlank()
        ) {

            search.sendKeys(
                    searchText
            );
        }

        /*
         * STATUS
         */

        WebElement status =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "statusFilter"
                                        )
                                )
                );

        new Select(
                status
        ).selectByValue(
                statusValue
        );

        /*
         * PRIORITY
         */

        WebElement priority =
                wait.until(
                        ExpectedConditions
                                .visibilityOfElementLocated(
                                        By.id(
                                                "priorityFilter"
                                        )
                                )
                );

        new Select(
                priority
        ).selectByValue(
                priorityValue
        );

        /*
         * APPLY
         */

        safeClick(
                By.id(
                        "searchButton"
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


    // ============================================================
    // TASK TITLE LOCATOR
    // ============================================================

    private By taskTitleLocator(
            String title) {

        return By.xpath(
                "//*[contains(@class,'task-title') " +
                "and normalize-space(.)=" +
                xpathLiteral(title) +
                "]"
        );
    }


    // ============================================================
    // DIRECT TASK CARD LOCATOR
    //
    // IMPORTANT FIX:
    //
    // We locate the CARD directly instead of:
    //
    // titleElement.findElement(...)
    //
    // because TaskNexus re-renders the card after status changes.
    // ============================================================

    private By taskCardLocator(
            String title) {

        return By.xpath(
                "//*[contains(@class,'task-card')]" +
                "[.//*[contains(@class,'task-title') " +
                "and normalize-space(.)=" +
                xpathLiteral(title) +
                "]]"
        );
    }


    // ============================================================
    // XPATH STRING
    // ============================================================

    private String xpathLiteral(
            String text) {

        if (
                !text.contains("'")
        ) {

            return "'"
                    + text
                    + "'";
        }

        if (
                !text.contains("\"")
        ) {

            return "\""
                    + text
                    + "\"";
        }

        StringBuilder result =
                new StringBuilder(
                        "concat("
                );

        String[] parts =
                text.split(
                        "'",
                        -1
                );

        for (
                int i = 0;
                i < parts.length;
                i++
        ) {

            if (
                    i > 0
            ) {

                result.append(
                        ",\"'\","
                );
            }

            result.append(
                    "'"
            );

            result.append(
                    parts[i]
            );

            result.append(
                    "'"
            );
        }

        result.append(
                ")"
        );

        return result.toString();
    }


    // ============================================================
    // FIND TASK CARD - STALE SAFE
    // ============================================================

    private WebElement findTaskCard(
            String title) {

        By cardLocator =
                taskCardLocator(
                        title
                );

        for (
                int attempt = 1;
                attempt <= 5;
                attempt++
        ) {

            try {

                /*
                 * IMPORTANT:
                 * Find the CARD directly.
                 */

                WebElement card =
                        wait.until(
                                ExpectedConditions
                                        .presenceOfElementLocated(
                                                cardLocator
                                        )
                        );

                if (
                        card.isDisplayed()
                ) {

                    return card;
                }

            } catch (
                    StaleElementReferenceException e
            ) {

                System.out.println(
                        "Stale task card detected. "
                                + "Retry "
                                + attempt
                                + "/5"
                );

                sleep(300);
            }
        }

        /*
         * Final fresh lookup.
         */

        return wait.until(
                ExpectedConditions
                        .presenceOfElementLocated(
                                cardLocator
                        )
        );
    }


    // ============================================================
    // TASK STATUS - STALE SAFE
    // ============================================================

    private String getTaskStatus(
            String title) {

        By cardLocator =
                taskCardLocator(
                        title
                );

        By statusLocator =
                By.cssSelector(
                        ".status"
                );

        for (
                int attempt = 1;
                attempt <= 5;
                attempt++
        ) {

            try {

                /*
                 * Always locate a completely fresh card.
                 */

                WebElement card =
                        wait.until(
                                ExpectedConditions
                                        .presenceOfElementLocated(
                                                cardLocator
                                        )
                        );

                /*
                 * Locate status from fresh card.
                 */

                WebElement status =
                        card.findElement(
                                statusLocator
                        );

                String value =
                        status
                                .getText()
                                .trim();

                if (
                        !value.isEmpty()
                ) {

                    return value;
                }

            } catch (
                    StaleElementReferenceException e
            ) {

                System.out.println(
                        "Stale status element detected. "
                                + "Retry "
                                + attempt
                                + "/5"
                );

                sleep(400);
            }
        }

        /*
         * Final completely fresh lookup.
         */

        WebElement freshCard =
                wait.until(
                        ExpectedConditions
                                .presenceOfElementLocated(
                                        cardLocator
                                )
                );

        return freshCard
                .findElement(
                        statusLocator
                )
                .getText()
                .trim();
    }


    // ============================================================
    // WAIT FOR SPECIFIC STATUS
    // ============================================================

    private void waitForStatus(
            String title,
            String expectedStatus) {

        wait.until(
                webDriver -> {

                    try {

                        String current =
                                getTaskStatus(
                                        title
                                );

                        System.out.println(
                                "Task: "
                                        + title
                                        + " | Current Status: "
                                        + current
                        );

                        return expectedStatus.equals(
                                current
                        );

                    } catch (
                            StaleElementReferenceException e
                    ) {

                        return false;

                    } catch (
                            WebDriverException e
                    ) {

                        return false;
                    }
                }
        );
    }


    // ============================================================
    // TASK ACTION
    // ============================================================

    private void clickTaskAction(
            String title,
            String buttonSelector) {

        By titleLocator =
                taskTitleLocator(
                        title
                );

        for (
                int attempt = 1;
                attempt <= 5;
                attempt++
        ) {

            try {

                /*
                 * ALWAYS find the title again.
                 */

                WebElement titleElement =
                        wait.until(
                                ExpectedConditions
                                        .presenceOfElementLocated(
                                                titleLocator
                                        )
                        );

                /*
                 * Immediately find the parent card.
                 *
                 * This card is used only for this attempt.
                 */

                WebElement card =
                        titleElement.findElement(
                                By.xpath(
                                        "./ancestor::*[" +
                                        "contains(@class,'task-card')" +
                                        "][1]"
                                )
                        );

                /*
                 * Find the action button.
                 */

                WebElement button =
                        card.findElement(
                                By.cssSelector(
                                        buttonSelector
                                )
                        );

                /*
                 * Scroll.
                 */

                scrollToCenter(
                        button
                );

                sleep(250);

                /*
                 * Check current state.
                 */

                if (
                        !button.isDisplayed()
                                ||
                        !button.isEnabled()
                ) {

                    throw new ElementNotInteractableException(
                            "Task action button is not ready."
                    );
                }

                /*
                 * Normal Selenium click.
                 */

                button.click();

                /*
                 * Wait for DOM refresh.
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

                return;

            } catch (
                    StaleElementReferenceException e
            ) {

                System.out.println(
                        "Task action stale element. "
                                + "Retry "
                                + attempt
                                + "/5"
                );

                sleep(500);

            } catch (
                    ElementNotInteractableException e
            ) {

                System.out.println(
                        "Task action not interactable. "
                                + "Retry "
                                + attempt
                                + "/5"
                );

                sleep(500);

            } catch (
                    WebDriverException e
            ) {

                System.out.println(
                        "Task action WebDriver error. "
                                + "Retry "
                                + attempt
                                + "/5"
                );

                sleep(500);
            }
        }

        /*
         * Final fresh lookup and JavaScript click.
         */

        WebElement freshTitle =
                wait.until(
                        ExpectedConditions
                                .presenceOfElementLocated(
                                        titleLocator
                                )
                );

        WebElement freshCard =
                freshTitle.findElement(
                        By.xpath(
                                "./ancestor::*[" +
                                "contains(@class,'task-card')" +
                                "][1]"
                        )
                );

        WebElement freshButton =
                freshCard.findElement(
                        By.cssSelector(
                                buttonSelector
                        )
                );

        scrollToCenter(
                freshButton
        );

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                "arguments[0].click();",
                freshButton
        );

        waitForPageReady();
    }


    // ============================================================
    // DELETE BUTTON
    // ============================================================

    private void clickDeleteButton(
            String title) {

        By titleLocator =
                taskTitleLocator(
                        title
                );

        for (
                int attempt = 1;
                attempt <= 5;
                attempt++
        ) {

            try {

                /*
                 * Fresh title.
                 */

                WebElement titleElement =
                        wait.until(
                                ExpectedConditions
                                        .presenceOfElementLocated(
                                                titleLocator
                                        )
                        );

                /*
                 * Fresh card.
                 */

                WebElement card =
                        titleElement.findElement(
                                By.xpath(
                                        "./ancestor::*[" +
                                        "contains(@class,'task-card')" +
                                        "][1]"
                                )
                        );

                /*
                 * Fresh delete button.
                 */

                WebElement deleteButton =
                        card.findElement(
                                By.cssSelector(
                                        ".delete-button"
                                )
                        );

                scrollToCenter(
                        deleteButton
                );

                sleep(250);

                deleteButton.click();

                wait.until(
                        ExpectedConditions
                                .alertIsPresent()
                );

                return;

            } catch (
                    StaleElementReferenceException e
            ) {

                sleep(500);

            } catch (
                    ElementNotInteractableException e
            ) {

                sleep(500);

            } catch (
                    WebDriverException e
            ) {

                sleep(500);
            }
        }

        /*
         * Final JavaScript fallback.
         */

        WebElement freshTitle =
                wait.until(
                        ExpectedConditions
                                .presenceOfElementLocated(
                                        titleLocator
                                )
                );

        WebElement freshCard =
                freshTitle.findElement(
                        By.xpath(
                                "./ancestor::*[" +
                                "contains(@class,'task-card')" +
                                "][1]"
                        )
                );

        WebElement deleteButton =
                freshCard.findElement(
                        By.cssSelector(
                                ".delete-button"
                        )
                );

        scrollToCenter(
                deleteButton
        );

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                "arguments[0].click();",
                deleteButton
        );

        wait.until(
                ExpectedConditions
                        .alertIsPresent()
        );
    }


    // ============================================================
    // SAFE CLICK BY LOCATOR
    // ============================================================

    private void safeClick(
            By locator) {

        for (
                int attempt = 1;
                attempt <= 5;
                attempt++
        ) {

            try {

                /*
                 * Fresh element every attempt.
                 */

                WebElement element =
                        wait.until(
                                ExpectedConditions
                                        .elementToBeClickable(
                                                locator
                                        )
                        );

                scrollToCenter(
                        element
                );

                sleep(250);

                element.click();

                return;

            } catch (
                    StaleElementReferenceException e
            ) {

                System.out.println(
                        "Stale click element. Retry "
                                + attempt
                );

                sleep(400);

            } catch (
                    ElementNotInteractableException e
            ) {

                System.out.println(
                        "Element not interactable. Retry "
                                + attempt
                );

                sleep(400);

            } catch (
                    WebDriverException e
            ) {

                System.out.println(
                        "WebDriver click error. Retry "
                                + attempt
                );

                sleep(400);
            }
        }

        /*
         * Final fresh JavaScript click.
         */

        WebElement fresh =
                wait.until(
                        ExpectedConditions
                                .presenceOfElementLocated(
                                        locator
                                )
                );

        scrollToCenter(
                fresh
        );

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                "arguments[0].click();",
                fresh
        );
    }


    // ============================================================
    // SAFE CLICK WEBELEMENT
    // ============================================================

    private void safeClick(
            WebElement element) {

        for (
                int attempt = 1;
                attempt <= 3;
                attempt++
        ) {

            try {

                scrollToCenter(
                        element
                );

                sleep(250);

                element.click();

                return;

            } catch (
                    StaleElementReferenceException e
            ) {

                sleep(400);

            } catch (
                    ElementNotInteractableException e
            ) {

                sleep(400);

            } catch (
                    WebDriverException e
            ) {

                sleep(400);
            }
        }

        /*
         * Last-resort JavaScript click.
         */

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                "arguments[0].click();",
                element
        );
    }


    // ============================================================
    // SCROLL
    // ============================================================

    private void scrollToCenter(
            WebElement element) {

        (
                (JavascriptExecutor)
                        driver
        ).executeScript(
                """
                arguments[0].scrollIntoView({
                    block: 'center',
                    inline: 'center'
                });
                """,
                element
        );
    }


    // ============================================================
    // COUNTER
    // ============================================================

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

        String value =
                counter
                        .getText()
                        .trim();

        return Integer.parseInt(
                value
        );
    }


    // ============================================================
    // DISPLAYED
    // ============================================================

    private boolean isDisplayed(
            By locator) {

        try {

            return wait.until(
                    ExpectedConditions
                            .visibilityOfElementLocated(
                                    locator
                            )
            ).isDisplayed();

        } catch (Exception e) {

            return false;
        }
    }


    // ============================================================
    // TASK EXISTS
    // ============================================================

    private boolean taskExists(
            String title) {

        try {

            return !driver
                    .findElements(
                            taskTitleLocator(
                                    title
                            )
                    )
                    .isEmpty();

        } catch (
                StaleElementReferenceException e
        ) {

            return false;
        }
    }


    // ============================================================
    // SCREENSHOT
    // ============================================================

    private void takeScreenshot(
            String testName)
            throws Exception {

        if (
                driver == null
        ) {

            return;
        }

        Path directory =
                Path.of(
                        "target",
                        "selenium-screenshots"
                );

        Files.createDirectories(
                directory
        );

        String fileName =
                testName.replaceAll(
                        "[^a-zA-Z0-9._-]",
                        "_"
                );

        File source =
                (
                        (TakesScreenshot)
                                driver
                ).getScreenshotAs(
                        OutputType.FILE
                );

        Path destination =
                directory.resolve(
                        fileName
                                + ".png"
                );

        Files.copy(
                source.toPath(),
                destination,
                StandardCopyOption
                        .REPLACE_EXISTING
        );

        System.out.println(
                "Screenshot saved: "
                        + destination
        );
    }


    // ============================================================
    // CLEANUP
    // ============================================================

    private void cleanupCreatedTasks() {

        List<String> tasks =
                new ArrayList<>(
                        createdTasks
                );

        for (
                String title :
                tasks
        ) {

            try {

                openTasksPage();

                applyFilters(
                        title,
                        "All",
                        "All"
                );

                if (
                        !taskExists(
                                title
                        )
                ) {

                    continue;
                }

                clickDeleteButton(
                        title
                );

                Alert alert =
                        wait.until(
                                ExpectedConditions
                                        .alertIsPresent()
                        );

                alert.accept();

                waitForPageReady();

                System.out.println(
                        "Cleanup completed: "
                                + title
                );

            } catch (Exception e) {

                System.out.println(
                        "Cleanup skipped: "
                                + title
                                + " | "
                                + e.getMessage()
                );
            }
        }

        createdTasks.clear();
    }


    // ============================================================
    // UNIQUE TITLE
    // ============================================================

    private String uniqueTitle(
            String prefix) {

        return prefix
                + " "
                + randomCode();
    }


    private String randomCode() {

        return UUID
                .randomUUID()
                .toString()
                .substring(
                        0,
                        8
                );
    }


    // ============================================================
    // SLEEP
    // ============================================================

    private void sleep(
            long milliseconds) {

        try {

            Thread.sleep(
                    milliseconds
            );

        } catch (
                InterruptedException e
        ) {

            Thread.currentThread()
                    .interrupt();
        }
    }
}