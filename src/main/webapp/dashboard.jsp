<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.demo.model.Task" %>

<%
    // =====================================================
    // DATA RECEIVED FROM TaskServlet
    // =====================================================

    List<Task> tasks =
            (List<Task>) request.getAttribute("tasks");

    Integer totalTasks =
            (Integer) request.getAttribute("totalTasks");

    Long completedTasks =
            (Long) request.getAttribute("completedTasks");

    Long pendingTasks =
            (Long) request.getAttribute("pendingTasks");

    Long inProgressTasks =
            (Long) request.getAttribute("inProgressTasks");


    // Prevent null values
    if (totalTasks == null) {
        totalTasks = 0;
    }

    if (completedTasks == null) {
        completedTasks = 0L;
    }

    if (pendingTasks == null) {
        pendingTasks = 0L;
    }

    if (inProgressTasks == null) {
        inProgressTasks = 0L;
    }


    // =====================================================
    // KEEP SEARCH/FILTER VALUES AFTER SEARCH
    // =====================================================

    String searchValue =
            request.getParameter("search");

    String statusValue =
            request.getParameter("status");

    String priorityValue =
            request.getParameter("priority");


    if (searchValue == null) {
        searchValue = "";
    }

    if (statusValue == null) {
        statusValue = "All";
    }

    if (priorityValue == null) {
        priorityValue = "All";
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

    <meta
            name="description"
            content="TaskNexus - Intelligent Task and Productivity Management System">

    <title>
        TaskNexus | Intelligent Task Management System
    </title>

    <!-- Professional CSS -->
    <link
            rel="stylesheet"
            href="<%= request.getContextPath() %>/css/style.css">

</head>


<body>


<!-- =====================================================
     TOP NAVIGATION BAR
     ===================================================== -->

<header class="topbar">

    <div class="brand">

        <h1>
            Task<span>Nexus</span>
        </h1>

        <p>
            Intelligent Task & Productivity Management System
        </p>

    </div>


    <div class="user-area">

        <div class="avatar">
            TN
        </div>

        <div>

            <strong>
                Productivity Workspace
            </strong>

            <small>
                Smart Task Dashboard
            </small>

        </div>

    </div>

</header>



<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

<main class="container">


    <!-- =================================================
         HERO / WELCOME SECTION
         ================================================= -->

    <section class="hero">

        <div>

            <p class="small-heading">
                SMART PRODUCTIVITY WORKSPACE
            </p>

            <h2>
                Manage Your Work Smarter
            </h2>

            <p class="hero-text">

                Create, organize, prioritize and track
                your tasks from one centralized workspace.

                TaskNexus helps you monitor progress,
                deadlines and productivity efficiently.

            </p>

        </div>


        <button
                id="openTaskModalButton"
                type="button"
                class="primary-button"
                onclick="openTaskModal()">

            + Create New Task

        </button>

    </section>



    <!-- =================================================
         DASHBOARD STATISTICS
         ================================================= -->

    <section class="stats">


        <!-- TOTAL TASKS -->

        <div class="stat-card">

            <div class="stat-icon">
                📋
            </div>

            <div>

                <span>
                    Total Tasks
                </span>

                <h2 id="totalTasks">
                    <%= totalTasks %>
                </h2>

            </div>

        </div>



        <!-- PENDING TASKS -->

        <div class="stat-card">

            <div class="stat-icon">
                ⏳
            </div>

            <div>

                <span>
                    Pending Tasks
                </span>

                <h2 id="pendingTasks">
                    <%= pendingTasks %>
                </h2>

            </div>

        </div>



        <!-- IN PROGRESS TASKS -->

        <div class="stat-card">

            <div class="stat-icon">
                ⚡
            </div>

            <div>

                <span>
                    In Progress
                </span>

                <h2 id="progressTasks">
                    <%= inProgressTasks %>
                </h2>

            </div>

        </div>



        <!-- COMPLETED TASKS -->

        <div class="stat-card">

            <div class="stat-icon">
                ✓
            </div>

            <div>

                <span>
                    Completed
                </span>

                <h2 id="completedTasks">
                    <%= completedTasks %>
                </h2>

            </div>

        </div>

    </section>



    <!-- =================================================
         SEARCH AND FILTER PANEL
         ================================================= -->

    <section class="filter-card">

        <form
                id="taskFilterForm"
                method="get"
                action="<%= request.getContextPath() %>/tasks">


            <!-- SEARCH -->

            <div class="search-box">

                <input
                        id="searchTask"
                        type="text"
                        name="search"
                        value="<%= searchValue %>"
                        placeholder="Search task, description or category...">

            </div>



            <!-- STATUS FILTER -->

            <select
                    id="statusFilter"
                    name="status">

                <option
                        value="All"
                        <%= "All".equalsIgnoreCase(statusValue)
                                ? "selected" : "" %>>

                    All Status

                </option>


                <option
                        value="Pending"
                        <%= "Pending".equalsIgnoreCase(statusValue)
                                ? "selected" : "" %>>

                    Pending

                </option>


                <option
                        value="In Progress"
                        <%= "In Progress".equalsIgnoreCase(statusValue)
                                ? "selected" : "" %>>

                    In Progress

                </option>


                <option
                        value="Completed"
                        <%= "Completed".equalsIgnoreCase(statusValue)
                                ? "selected" : "" %>>

                    Completed

                </option>

            </select>



            <!-- PRIORITY FILTER -->

            <select
                    id="priorityFilter"
                    name="priority">

                <option
                        value="All"
                        <%= "All".equalsIgnoreCase(priorityValue)
                                ? "selected" : "" %>>

                    All Priority

                </option>


                <option
                        value="High"
                        <%= "High".equalsIgnoreCase(priorityValue)
                                ? "selected" : "" %>>

                    High

                </option>


                <option
                        value="Medium"
                        <%= "Medium".equalsIgnoreCase(priorityValue)
                                ? "selected" : "" %>>

                    Medium

                </option>


                <option
                        value="Low"
                        <%= "Low".equalsIgnoreCase(priorityValue)
                                ? "selected" : "" %>>

                    Low

                </option>

            </select>



            <!-- SEARCH BUTTON -->

            <button
                    id="searchButton"
                    type="submit"
                    class="search-button">

                Search

            </button>



            <!-- RESET BUTTON -->

            <a
                    id="resetButton"
                    class="reset-button"
                    href="<%= request.getContextPath() %>/tasks">

                Reset

            </a>

        </form>

    </section>



    <!-- =================================================
         TASK WORKSPACE
         ================================================= -->

    <section class="task-section">


        <div class="section-header">

            <div>

                <h2>
                    Task Workspace
                </h2>

                <p>

                    View, organize and manage your
                    current work activities.

                </p>

            </div>

        </div>



        <div
                id="taskGrid"
                class="task-grid">


            <%
                if (tasks != null && !tasks.isEmpty()) {

                    for (Task task : tasks) {

                        String priorityClass =
                                task.getPriority() != null
                                        ? task.getPriority()
                                              .toLowerCase()
                                              .replace(" ", "-")
                                        : "medium";
            %>


            <!-- ==========================================
                 INDIVIDUAL TASK CARD
                 ========================================== -->

            <article
                    class="task-card"
                    data-task-id="<%= task.getId() %>">


                <!-- TASK CARD HEADER -->

                <div class="task-card-header">


                    <span class="category">

                        <%= task.getCategory() != null
                                ? task.getCategory()
                                : "General" %>

                    </span>


                    <span
                            class="priority <%= priorityClass %>">

                        <%= task.getPriority() != null
                                ? task.getPriority()
                                : "Medium" %>

                        Priority

                    </span>

                </div>



                <!-- TASK TITLE -->

                <h3 class="task-title">

                    <%= task.getTitle() %>

                </h3>



                <!-- TASK DESCRIPTION -->

                <p class="description">

                    <%= task.getDescription() != null
                            ? task.getDescription()
                            : "No description available." %>

                </p>



                <!-- TASK INFORMATION -->

                <div class="task-meta">


                    <!-- STATUS -->

                    <div>

                        <span class="meta-label">
                            Current Status
                        </span>

                        <strong class="status">

                            <%= task.getStatus() %>

                        </strong>

                    </div>



                    <!-- DUE DATE -->

                    <div>

                        <span class="meta-label">
                            Due Date
                        </span>

                        <strong>

                            <%
                                if (task.getDueDate() != null) {
                            %>

                            <%= task.getDueDate() %>

                            <%
                                } else {
                            %>

                            No Deadline

                            <%
                                }
                            %>

                        </strong>

                    </div>

                </div>



                <!-- ======================================
                     TASK ACTION BUTTONS
                     ====================================== -->

                <div class="task-actions">


                    <!-- START TASK -->

                    <%
                        if ("Pending".equalsIgnoreCase(
                                task.getStatus())) {
                    %>

                    <form
                            method="post"
                            action="<%= request.getContextPath() %>/tasks">

                        <input
                                type="hidden"
                                name="action"
                                value="progress">

                        <input
                                type="hidden"
                                name="id"
                                value="<%= task.getId() %>">

                        <button
                                type="submit"
                                class="progress-button">

                            Start Task

                        </button>

                    </form>

                    <%
                        }
                    %>



                    <!-- COMPLETE TASK -->

                    <%
                        if (!"Completed".equalsIgnoreCase(
                                task.getStatus())) {
                    %>

                    <form
                            method="post"
                            action="<%= request.getContextPath() %>/tasks">

                        <input
                                type="hidden"
                                name="action"
                                value="complete">

                        <input
                                type="hidden"
                                name="id"
                                value="<%= task.getId() %>">

                        <button
                                type="submit"
                                class="complete-button">

                            ✓ Complete

                        </button>

                    </form>

                    <%
                        }
                    %>



                    <!-- DELETE TASK -->

                    <form
                            method="post"
                            action="<%= request.getContextPath() %>/tasks"
                            onsubmit="return confirmDelete();">

                        <input
                                type="hidden"
                                name="action"
                                value="delete">

                        <input
                                type="hidden"
                                name="id"
                                value="<%= task.getId() %>">

                        <button
                                type="submit"
                                class="delete-button">

                            Delete

                        </button>

                    </form>

                </div>

            </article>


            <%
                    }

                } else {
            %>



            <!-- ==========================================
                 EMPTY TASK STATE
                 ========================================== -->

            <div class="empty-state">

                <div class="empty-icon">
                    📋
                </div>

                <h3>
                    No Tasks Found
                </h3>

                <p>

                    No tasks match your current search
                    or filter settings.

                </p>

                <button
                        type="button"
                        class="primary-button"
                        onclick="openTaskModal()">

                    + Create Your First Task

                </button>

            </div>


            <%
                }
            %>


        </div>

    </section>

</main>



<!-- =====================================================
     CREATE NEW TASK MODAL
     ===================================================== -->

<div
        id="taskModal"
        class="modal">


    <div class="modal-content">


        <!-- MODAL HEADER -->

        <div class="modal-header">

            <div>

                <h2>
                    Create New Task
                </h2>

                <p>
                    Add a new task to your productivity workspace.
                </p>

            </div>


            <button
                    id="closeTaskModalButton"
                    type="button"
                    class="close-button"
                    onclick="closeTaskModal()">

                ×

            </button>

        </div>



        <!-- =================================================
             CREATE TASK FORM
             ================================================= -->

        <form
                id="createTaskForm"
                method="post"
                action="<%= request.getContextPath() %>/tasks">


            <input
                    type="hidden"
                    name="action"
                    value="add">



            <!-- TASK TITLE -->

            <div class="form-group">

                <label for="taskTitle">
                    Task Title
                </label>

                <input
                        id="taskTitle"
                        type="text"
                        name="title"
                        maxlength="100"
                        placeholder="Example: Complete DevOps Pipeline"
                        required>

            </div>



            <!-- DESCRIPTION -->

            <div class="form-group">

                <label for="taskDescription">
                    Description
                </label>

                <textarea
                        id="taskDescription"
                        name="description"
                        maxlength="500"
                        placeholder="Describe what needs to be completed..."
                        required></textarea>

            </div>



            <!-- CATEGORY AND PRIORITY -->

            <div class="form-row">


                <!-- CATEGORY -->

                <div class="form-group">

                    <label for="taskCategory">
                        Category
                    </label>

                    <select
                            id="taskCategory"
                            name="category">

                        <option value="Development">
                            Development
                        </option>

                        <option value="Testing">
                            Testing
                        </option>

                        <option value="College">
                            College
                        </option>

                        <option value="Research">
                            Research
                        </option>

                        <option value="Meeting">
                            Meeting
                        </option>

                        <option value="Documentation">
                            Documentation
                        </option>

                        <option value="Personal">
                            Personal
                        </option>

                    </select>

                </div>



                <!-- PRIORITY -->

                <div class="form-group">

                    <label for="taskPriority">
                        Priority
                    </label>

                    <select
                            id="taskPriority"
                            name="priority">

                        <option value="High">
                            High Priority
                        </option>

                        <option
                                value="Medium"
                                selected>

                            Medium Priority

                        </option>

                        <option value="Low">
                            Low Priority
                        </option>

                    </select>

                </div>

            </div>



            <!-- DUE DATE -->

            <div class="form-group">

                <label for="taskDueDate">
                    Due Date
                </label>

                <input
                        id="taskDueDate"
                        type="date"
                        name="dueDate">

            </div>



            <!-- MODAL ACTION BUTTONS -->

            <div class="modal-actions">

                <button
                        type="button"
                        class="cancel-button"
                        onclick="closeTaskModal()">

                    Cancel

                </button>


                <button
                        id="createTaskButton"
                        type="submit"
                        class="create-button">

                    Create Task

                </button>

            </div>

        </form>

    </div>

</div>



<!-- =====================================================
     JAVASCRIPT
     ===================================================== -->

<script>

    // ===================================================
    // OPEN CREATE TASK MODAL
    // ===================================================

    function openTaskModal() {

        const modal =
            document.getElementById("taskModal");

        modal.classList.add("show");

        document.body.style.overflow =
            "hidden";


        // Automatically focus task title
        setTimeout(
            function () {

                const titleInput =
                    document.getElementById(
                        "taskTitle"
                    );

                if (titleInput) {

                    titleInput.focus();
                }

            },
            100
        );
    }



    // ===================================================
    // CLOSE CREATE TASK MODAL
    // ===================================================

    function closeTaskModal() {

        const modal =
            document.getElementById("taskModal");

        modal.classList.remove("show");

        document.body.style.overflow =
            "auto";
    }



    // ===================================================
    // DELETE CONFIRMATION
    // ===================================================

    function confirmDelete() {

        return confirm(
            "Are you sure you want to delete this task?"
        );
    }



    // ===================================================
    // CLOSE MODAL WHEN CLICKING OUTSIDE
    // ===================================================

    window.addEventListener(
        "click",
        function (event) {

            const modal =
                document.getElementById(
                    "taskModal"
                );

            if (event.target === modal) {

                closeTaskModal();
            }
        }
    );



    // ===================================================
    // ESC KEY CLOSES MODAL
    // ===================================================

    document.addEventListener(
        "keydown",
        function (event) {

            if (event.key === "Escape") {

                closeTaskModal();
            }
        }
    );



    // ===================================================
    // PREVENT PAST DUE DATE SELECTION
    // ===================================================

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            const dateInput =
                document.getElementById(
                    "taskDueDate"
                );

            if (dateInput) {

                const today =
                    new Date();

                const year =
                    today.getFullYear();

                const month =
                    String(
                        today.getMonth() + 1
                    ).padStart(
                        2,
                        "0"
                    );

                const day =
                    String(
                        today.getDate()
                    ).padStart(
                        2,
                        "0"
                    );

                dateInput.min =
                    year
                    + "-"
                    + month
                    + "-"
                    + day;
            }
        }
    );

</script>


</body>

</html>