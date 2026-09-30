<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.demo.model.Task" %>

<%!
    private String esc(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
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


    LocalDate today =
            LocalDate.now();

    LocalDate tomorrow =
            today.plusDays(1);


    long overdueCount = 0;
    long dueTodayCount = 0;
    long upcomingCount = 0;
    long highPriorityCount = 0;


    if (tasks != null) {

        for (Task task : tasks) {

            if ("High".equalsIgnoreCase(
                    task.getPriority())) {

                highPriorityCount++;
            }


            if (task.getDueDate() != null) {

                if (task.getDueDate().equals(today)
                        && !"Completed".equalsIgnoreCase(
                                task.getStatus())) {

                    dueTodayCount++;
                }


                if (task.getDueDate().isAfter(today)
                        && !"Completed".equalsIgnoreCase(
                                task.getStatus())) {

                    upcomingCount++;
                }


                if (task.getDueDate().isBefore(today)
                        && !"Completed".equalsIgnoreCase(
                                task.getStatus())) {

                    overdueCount++;
                }
            }
        }
    }


    int completionRate = 0;

    if (totalTasks > 0) {

        completionRate =
                (int) Math.round(
                        completedTasks
                                * 100.0
                                / totalTasks
                );
    }


    long remainingTasks =
            Math.max(
                    0,
                    totalTasks
                            - completedTasks
            );
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

<title>
    TaskNexus Pro | My Task Workspace
</title>


<style>

/* =========================================================
   TASKNEXUS PRO
   PREMIUM SINGLE-PAGE WORKSPACE
   ========================================================= */

:root {

    --navy:
        #102032;

    --navy-2:
        #152a3e;

    --navy-3:
        #1d364b;

    --page:
        #f5f7fa;

    --surface:
        #ffffff;

    --surface-soft:
        #f9fafc;

    --border:
        #e1e7ed;

    --border-dark:
        #d7dee6;

    --text:
        #162234;

    --text-soft:
        #53657a;

    --muted:
        #8492a6;

    --teal:
        #069687;

    --teal-dark:
        #05776d;

    --teal-soft:
        #e3f6f2;

    --blue:
        #537fd3;

    --blue-soft:
        #edf3ff;

    --amber:
        #c58b25;

    --amber-soft:
        #fff6e7;

    --red:
        #d45c63;

    --red-soft:
        #fff0f1;

    --shadow:
        0 8px 24px
        rgba(24, 42, 63, 0.05);

    --shadow-lg:
        0 18px 42px
        rgba(24, 42, 63, 0.10);

    --radius:
        15px;

    --sidebar-width:
        250px;
}


/* =========================================================
   RESET
   ========================================================= */

* {

    box-sizing:
        border-box;

    margin:
        0;

    padding:
        0;
}


html {

    scroll-behavior:
        smooth;
}


body {

    min-height:
        100vh;

    font-family:
        Inter,
        "Segoe UI",
        Arial,
        sans-serif;

    color:
        var(--text);

    background:
        var(--page);

    -webkit-font-smoothing:
        antialiased;
}


button,
input,
select,
textarea {

    font:
        inherit;
}


button {

    cursor:
        pointer;
}


a {

    color:
        inherit;

    text-decoration:
        none;
}


/* =========================================================
   APP
   ========================================================= */

.app {

    min-height:
        100vh;

    display:
        flex;
}


/* =========================================================
   SIDEBAR
   ========================================================= */

.sidebar {

    width:
        var(--sidebar-width);

    position:
        fixed;

    left:
        0;

    top:
        0;

    bottom:
        0;

    z-index:
        1000;

    display:
        flex;

    flex-direction:
        column;

    padding:
        26px 17px 18px;

    color:
        #ffffff;

    background:
        linear-gradient(
            180deg,
            #102032 0%,
            #112538 100%
        );

    overflow-y:
        auto;
}


.brand {

    display:
        flex;

    align-items:
        center;

    gap:
        12px;

    padding:
        0 8px 28px;
}


.brand-logo {

    width:
        42px;

    height:
        42px;

    flex-shrink:
        0;

    display:
        grid;

    place-items:
        center;

    border-radius:
        11px;

    color:
        #052b2b;

    background:
        #5ee2d1;

    font-size:
        20px;

    font-weight:
        900;
}


.brand-name {

    display:
        flex;

    align-items:
        center;

    gap:
        7px;
}


.brand-name strong {

    font-size:
        19px;

    letter-spacing:
        -0.5px;
}


.pro-badge {

    padding:
        3px 5px;

    border-radius:
        4px;

    background:
        rgba(
            255,
            255,
            255,
            0.12
        );

    color:
        #dbe7f1;

    font-size:
        8px;

    font-weight:
        800;

    letter-spacing:
        0.7px;
}


.brand p {

    margin-top:
        4px;

    color:
        #8fa1b6;

    font-size:
        11px;
}


.menu-title {

    margin:
        14px 15px 11px;

    color:
        #7f92aa;

    font-size:
        9px;

    font-weight:
        800;

    letter-spacing:
        1.5px;
}


.nav-item {

    min-height:
        45px;

    display:
        flex;

    align-items:
        center;

    gap:
        12px;

    padding:
        10px 12px;

    margin-bottom:
        4px;

    border-radius:
        9px;

    color:
        #c2cddb;

    font-size:
        12px;

    transition:
        0.2s ease;
}


.nav-item:hover {

    background:
        rgba(
            255,
            255,
            255,
            0.05
        );

    color:
        #ffffff;
}


.nav-item.active {

    color:
        #66dfd2;

    background:
        #203b50;
}


.nav-icon {

    width:
        23px;

    text-align:
        center;

    font-size:
        15px;
}


.nav-label {

    flex:
        1;
}


.nav-count {

    min-width:
        24px;

    padding:
        3px 6px;

    border-radius:
        6px;

    text-align:
        center;

    color:
        #dce8f2;

    background:
        #29455a;

    font-size:
        9px;

    font-weight:
        700;
}


.nav-item.active
.nav-count {

    color:
        #70e0d4;

    background:
        rgba(
            94,
            226,
            209,
            0.10
        );
}


/* =========================================================
   PRIVATE CARD
   ========================================================= */

.private-card {

    margin-top:
        20px;

    padding:
        16px;

    border:
        1px solid
        #2c4256;

    border-radius:
        12px;

    background:
        rgba(
            255,
            255,
            255,
            0.02
        );
}


.private-card-header {

    display:
        flex;

    align-items:
        center;

    gap:
        8px;

    color:
        #bfcbd7;

    font-size:
        10px;
}


.private-card p {

    margin:
        10px 0 0 26px;

    color:
        #8092a8;

    font-size:
        9px;

    line-height:
        1.6;
}


/* =========================================================
   SIDEBAR PROFILE
   ========================================================= */

.sidebar-user {

    margin-top:
        auto;

    padding:
        20px 5px 0;

    display:
        flex;

    align-items:
        center;

    gap:
        11px;
}


.sidebar-avatar {

    width:
        38px;

    height:
        38px;

    display:
        grid;

    place-items:
        center;

    border-radius:
        50%;

    color:
        #dbe7f2;

    background:
        #314a61;

    font-size:
        10px;

    font-weight:
        800;
}


.sidebar-user strong {

    display:
        block;

    font-size:
        10px;
}


.sidebar-user small {

    display:
        block;

    margin-top:
        3px;

    color:
        #8193a8;

    font-size:
        9px;
}


/* =========================================================
   MAIN
   ========================================================= */

.main {

    width:
        calc(
            100%
            -
            var(--sidebar-width)
        );

    margin-left:
        var(--sidebar-width);

    min-width:
        0;
}


/* =========================================================
   HEADER
   ========================================================= */

.topbar {

    height:
        76px;

    position:
        sticky;

    top:
        0;

    z-index:
        500;

    display:
        flex;

    align-items:
        center;

    justify-content:
        space-between;

    padding:
        0 38px;

    background:
        rgba(
            255,
            255,
            255,
            0.96
        );

    backdrop-filter:
        blur(10px);

    border-bottom:
        1px solid
        var(--border);
}


.breadcrumb {

    display:
        flex;

    align-items:
        center;

    gap:
        15px;

    color:
        var(--muted);

    font-size:
        11px;
}


.breadcrumb strong {

    color:
        var(--text-soft);

    font-weight:
        600;
}


.private-badge {

    display:
        flex;

    align-items:
        center;

    gap:
        6px;

    padding:
        9px 12px;

    border:
        1px solid
        var(--border);

    border-radius:
        8px;

    color:
        var(--text-soft);

    background:
        #f8fafc;

    font-size:
        10px;

    font-weight:
        600;
}


/* =========================================================
   CONTENT
   ========================================================= */

.content {

    max-width:
        1500px;

    margin:
        0 auto;

    padding:
        36px 38px 60px;
}


/* =========================================================
   PAGE INTRO
   ========================================================= */

.page-intro {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    gap:
        30px;

    margin-bottom:
        28px;
}


.eyebrow {

    color:
        #6f8195;

    font-size:
        9px;

    font-weight:
        800;

    letter-spacing:
        1.6px;
}


.page-intro h1 {

    margin-top:
        7px;

    font-size:
        30px;

    line-height:
        1.2;

    letter-spacing:
        -0.9px;
}


.page-intro h1 span {

    color:
        var(--teal);
}


.page-intro p {

    margin-top:
        8px;

    color:
        var(--text-soft);

    font-size:
        12px;
}


.new-task-button {

    min-height:
        44px;

    display:
        inline-flex;

    align-items:
        center;

    gap:
        9px;

    padding:
        11px 18px;

    border:
        none;

    border-radius:
        9px;

    color:
        #ffffff;

    background:
        var(--teal);

    font-size:
        11px;

    font-weight:
        700;

    box-shadow:
        0 8px 18px
        rgba(
            6,
            150,
            135,
            0.18
        );

    transition:
        0.2s ease;
}


.new-task-button:hover {

    background:
        var(--teal-dark);

    transform:
        translateY(-1px);
}


/* =========================================================
   SUMMARY CARDS
   ========================================================= */

.summary-grid {

    display:
        grid;

    grid-template-columns:
        repeat(
            4,
            minmax(
                0,
                1fr
            )
        );

    gap:
        16px;

    margin-bottom:
        26px;
}


.summary-card {

    min-height:
        145px;

    padding:
        22px;

    border:
        1px solid
        var(--border);

    border-radius:
        var(--radius);

    background:
        var(--surface);

    box-shadow:
        var(--shadow);

    transition:
        0.2s ease;
}


.summary-card:hover {

    transform:
        translateY(-2px);

    box-shadow:
        var(--shadow-lg);
}


.summary-top {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;
}


.summary-label {

    color:
        var(--text-soft);

    font-size:
        11px;
}


.summary-icon {

    width:
        36px;

    height:
        36px;

    display:
        grid;

    place-items:
        center;

    border-radius:
        10px;

    font-size:
        15px;
}


.summary-icon.blue {

    color:
        var(--blue);

    background:
        var(--blue-soft);
}


.summary-icon.amber {

    color:
        var(--amber);

    background:
        var(--amber-soft);
}


.summary-icon.green {

    color:
        var(--teal);

    background:
        var(--teal-soft);
}


.summary-icon.red {

    color:
        var(--red);

    background:
        var(--red-soft);
}


.summary-number {

    margin-top:
        13px;

    font-size:
        28px;

    font-weight:
        700;
}


.summary-help {

    margin-top:
        10px;

    color:
        var(--muted);

    font-size:
        9px;
}


/* =========================================================
   WORKSPACE LAYOUT
   ========================================================= */

.workspace-layout {

    display:
        grid;

    grid-template-columns:
        minmax(
            0,
            1fr
        )
        285px;

    gap:
        22px;

    align-items:
        start;
}


/* =========================================================
   TASK PANEL
   ========================================================= */

.task-panel {

    overflow:
        hidden;

    border:
        1px solid
        var(--border);

    border-radius:
        var(--radius);

    background:
        var(--surface);

    box-shadow:
        var(--shadow);
}


.task-panel-head {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    gap:
        20px;

    padding:
        21px 22px 17px;
}


.task-panel-title {

    display:
        flex;

    align-items:
        center;

    gap:
        8px;
}


.task-panel-title h2 {

    font-size:
        15px;
}


.small-count {

    min-width:
        24px;

    padding:
        3px 6px;

    border-radius:
        6px;

    color:
        var(--muted);

    background:
        #f0f2f5;

    text-align:
        center;

    font-size:
        9px;
}


.task-panel-head p {

    margin-top:
        5px;

    color:
        var(--muted);

    font-size:
        9px;
}


.view-controls {

    display:
        flex;

    padding:
        3px;

    border-radius:
        8px;

    background:
        #f1f3f6;
}


.view-controls button {

    min-height:
        31px;

    display:
        inline-flex;

    align-items:
        center;

    gap:
        5px;

    padding:
        6px 10px;

    border:
        none;

    border-radius:
        7px;

    color:
        var(--text-soft);

    background:
        transparent;

    font-size:
        9px;
}


.view-controls button.active {

    color:
        var(--text);

    background:
        #ffffff;

    box-shadow:
        0 2px 6px
        rgba(
            0,
            0,
            0,
            0.06
        );
}


/* =========================================================
   FILTERS
   ========================================================= */

.filters {

    padding:
        0 22px 18px;
}


.filter-form {

    display:
        grid;

    grid-template-columns:
        1fr
        1fr
        1fr
        auto;

    gap:
        9px;
}


.filter-control {

    height:
        40px;

    padding:
        0 12px;

    border:
        1px solid
        var(--border-dark);

    border-radius:
        8px;

    color:
        var(--text-soft);

    background:
        #ffffff;

    outline:
        none;

    font-size:
        10px;
}


.filter-control:focus {

    border-color:
        var(--teal);

    box-shadow:
        0 0 0 3px
        rgba(
            6,
            150,
            135,
            0.08
        );
}


.search-button {

    min-width:
        70px;

    border:
        none;

    border-radius:
        8px;

    color:
        #ffffff;

    background:
        var(--navy);

    font-size:
        10px;

    font-weight:
        700;
}


/* =========================================================
   TABS
   ========================================================= */

.tabs {

    display:
        flex;

    align-items:
        center;

    gap:
        25px;

    padding:
        0 22px;

    border-bottom:
        1px solid
        var(--border);
}


.tab {

    position:
        relative;

    min-height:
        45px;

    display:
        inline-flex;

    align-items:
        center;

    gap:
        7px;

    color:
        var(--muted);

    font-size:
        10px;

    font-weight:
        600;
}


.tab.active {

    color:
        var(--teal);
}


.tab.active::after {

    content:
        "";

    position:
        absolute;

    left:
        0;

    right:
        0;

    bottom:
        -1px;

    height:
        2px;

    background:
        var(--teal);
}


.tab-count {

    padding:
        2px 5px;

    border-radius:
        5px;

    color:
        var(--muted);

    background:
        #f0f2f4;

    font-size:
        8px;
}


.tab.active
.tab-count {

    color:
        var(--teal);

    background:
        var(--teal-soft);
}


.reset-link {

    margin-left:
        auto;

    color:
        var(--muted);

    font-size:
        9px;
}


/* =========================================================
   TASK LIST
   ========================================================= */

.task-grid {

    min-height:
        250px;

    padding:
        15px 20px 22px;

    display:
        grid;

    gap:
        10px;
}


.task-card {

    display:
        grid;

    grid-template-columns:
        auto
        minmax(
            0,
            1fr
        )
        auto
        auto;

    align-items:
        center;

    gap:
        14px;

    padding:
        15px;

    border:
        1px solid
        var(--border);

    border-radius:
        11px;

    background:
        var(--surface);

    transition:
        0.2s ease;
}


.task-card:hover {

    border-color:
        #cdd7df;

    box-shadow:
        0 8px 20px
        rgba(
            26,
            45,
            65,
            0.05
        );
}


.task-status-icon {

    width:
        34px;

    height:
        34px;

    display:
        grid;

    place-items:
        center;

    border-radius:
        50%;

    color:
        var(--teal);

    background:
        var(--teal-soft);

    font-size:
        12px;
}


.task-card.pending
.task-status-icon {

    color:
        var(--amber);

    background:
        var(--amber-soft);
}


.task-card.in-progress
.task-status-icon {

    color:
        var(--blue);

    background:
        var(--blue-soft);
}


.task-title {

    font-size:
        11px;

    font-weight:
        700;
}


.task-description {

    margin-top:
        4px;

    max-width:
        540px;

    color:
        var(--muted);

    font-size:
        9px;

    line-height:
        1.45;
}


.task-badges {

    display:
        flex;

    flex-wrap:
        wrap;

    gap:
        5px;

    margin-top:
        7px;
}


.badge {

    display:
        inline-flex;

    align-items:
        center;

    min-height:
        20px;

    padding:
        3px 7px;

    border-radius:
        20px;

    font-size:
        8px;

    font-weight:
        700;
}


.category-badge {

    color:
        #52718a;

    background:
        #eef3f6;
}


.priority.high {

    color:
        var(--red);

    background:
        var(--red-soft);
}


.priority.medium {

    color:
        var(--amber);

    background:
        var(--amber-soft);
}


.priority.low {

    color:
        var(--teal);

    background:
        var(--teal-soft);
}


.task-due {

    min-width:
        90px;

    text-align:
        right;
}


.task-due small {

    display:
        block;

    color:
        var(--muted);

    font-size:
        8px;
}


.task-due strong {

    display:
        block;

    margin-top:
        4px;

    color:
        var(--text-soft);

    font-size:
        9px;
}


.task-due strong.overdue {

    color:
        var(--red);
}


.status {

    display:
        inline-block;

    margin-top:
        4px;

    color:
        var(--teal);

    font-size:
        9px;
}


/* =========================================================
   ACTIONS
   ========================================================= */

.task-actions {

    display:
        flex;

    gap:
        5px;
}


.task-actions form {

    display:
        flex;
}


.task-actions button {

    min-height:
        31px;

    padding:
        6px 9px;

    border:
        none;

    border-radius:
        7px;

    font-size:
        8px;

    font-weight:
        700;
}


.progress-button {

    color:
        #3c67af;

    background:
        var(--blue-soft);
}


.complete-button {

    color:
        var(--teal);

    background:
        var(--teal-soft);
}


.delete-button {

    color:
        var(--red);

    background:
        var(--red-soft);
}


/* =========================================================
   EMPTY STATE
   ========================================================= */

.empty-state {

    min-height:
        230px;

    display:
        flex;

    flex-direction:
        column;

    align-items:
        center;

    justify-content:
        center;

    text-align:
        center;
}


.empty-icon {

    width:
        45px;

    height:
        45px;

    display:
        grid;

    place-items:
        center;

    border-radius:
        13px;

    color:
        var(--text-soft);

    background:
        #f0f3f6;

    font-size:
        18px;
}


.empty-state h3 {

    margin-top:
        13px;

    font-size:
        14px;
}


.empty-state p {

    margin-top:
        5px;

    color:
        var(--muted);

    font-size:
        9px;
}


/* =========================================================
   PROGRESS PANEL
   ========================================================= */

.progress-panel {

    padding:
        22px;

    border-radius:
        var(--radius);

    color:
        #ffffff;

    background:
        linear-gradient(
            180deg,
            #14283b,
            #102234
        );

    box-shadow:
        var(--shadow-lg);
}


.progress-header {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;
}


.progress-header h3 {

    font-size:
        13px;
}


.progress-header span {

    color:
        #70dfd2;

    font-size:
        13px;
}


.progress-ring {

    width:
        160px;

    height:
        160px;

    margin:
        25px auto;

    position:
        relative;

    display:
        grid;

    place-items:
        center;

    border-radius:
        50%;

    background:
        conic-gradient(
            #55ddcb
            calc(
                <%= completionRate %>
                * 1%
            ),
            #2a4053
            0
        );
}


.progress-ring::before {

    content:
        "";

    position:
        absolute;

    width:
        135px;

    height:
        135px;

    border-radius:
        50%;

    background:
        #14283b;
}


.progress-ring-content {

    position:
        relative;

    z-index:
        2;

    text-align:
        center;
}


.progress-ring-content strong {

    display:
        block;

    font-size:
        29px;
}


.progress-ring-content small {

    display:
        block;

    margin-top:
        5px;

    color:
        #93a4b5;

    font-size:
        9px;
}


.progress-stats {

    display:
        flex;

    justify-content:
        space-between;

    color:
        #b6c3cf;

    font-size:
        9px;
}


.progress-line {

    height:
        5px;

    margin:
        13px 0 16px;

    overflow:
        hidden;

    border-radius:
        20px;

    background:
        #294053;
}


.progress-line span {

    display:
        block;

    width:
        <%= completionRate %>%;

    height:
        100%;

    background:
        #55ddcb;
}


.progress-footer {

    text-align:
        center;

    color:
        #8799aa;

    font-size:
        9px;
}


/* =========================================================
   FOCUS PANEL
   ========================================================= */

.focus-card {

    margin-top:
        15px;

    padding:
        18px;

    border:
        1px solid
        var(--border);

    border-radius:
        var(--radius);

    background:
        var(--surface);

    box-shadow:
        var(--shadow);
}


.focus-card h3 {

    font-size:
        12px;
}


.focus-card p {

    margin-top:
        5px;

    color:
        var(--muted);

    font-size:
        9px;

    line-height:
        1.5;
}


.focus-row {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    margin-top:
        13px;

    padding-top:
        11px;

    border-top:
        1px solid
        var(--border);

    font-size:
        9px;
}


.focus-row strong {

    font-size:
        11px;
}


/* =========================================================
   MODAL
   ========================================================= */

.modal {

    position:
        fixed;

    inset:
        0;

    z-index:
        3000;

    display:
        none;

    align-items:
        center;

    justify-content:
        center;

    padding:
        20px;

    background:
        rgba(
            9,
            23,
            36,
            0.72
        );

    backdrop-filter:
        blur(5px);
}


.modal.show {

    display:
        flex;
}


.modal-card {

    width:
        520px;

    max-width:
        100%;

    max-height:
        90vh;

    overflow-y:
        auto;

    padding:
        25px;

    border-radius:
        16px;

    background:
        #ffffff;

    box-shadow:
        0 30px 90px
        rgba(
            0,
            0,
            0,
            0.28
        );
}


.modal-head {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        flex-start;

    margin-bottom:
        20px;
}


.modal-head h2 {

    font-size:
        17px;
}


.modal-head p {

    margin-top:
        4px;

    color:
        var(--muted);

    font-size:
        9px;
}


.close-button {

    width:
        34px;

    height:
        34px;

    display:
        grid;

    place-items:
        center;

    border:
        none;

    border-radius:
        50%;

    color:
        var(--text-soft);

    background:
        #f0f3f5;

    font-size:
        20px;
}


.form-group {

    margin-bottom:
        14px;
}


.form-group label {

    display:
        block;

    margin-bottom:
        6px;

    color:
        var(--text-soft);

    font-size:
        10px;

    font-weight:
        700;
}


.form-group input,
.form-group select,
.form-group textarea {

    width:
        100%;

    padding:
        10px 11px;

    border:
        1px solid
        var(--border-dark);

    border-radius:
        8px;

    color:
        var(--text);

    background:
        #fbfcfd;

    outline:
        none;

    font-size:
        10px;
}


.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {

    border-color:
        var(--teal);

    background:
        #ffffff;

    box-shadow:
        0 0 0 3px
        rgba(
            6,
            150,
            135,
            0.08
        );
}


.form-group textarea {

    min-height:
        95px;

    resize:
        vertical;
}


.form-row {

    display:
        grid;

    grid-template-columns:
        1fr
        1fr;

    gap:
        12px;
}


.modal-actions {

    display:
        flex;

    justify-content:
        flex-end;

    gap:
        9px;

    margin-top:
        8px;
}


.cancel-button,
.create-button {

    min-height:
        39px;

    padding:
        9px 16px;

    border-radius:
        8px;

    font-size:
        10px;

    font-weight:
        700;
}


.cancel-button {

    border:
        1px solid
        var(--border);

    color:
        var(--text-soft);

    background:
        #ffffff;
}


.create-button {

    border:
        none;

    color:
        #ffffff;

    background:
        var(--teal);
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media
(max-width: 1100px) {

    .workspace-layout {

        grid-template-columns:
            1fr;
    }


    .right-column {

        display:
            grid;

        grid-template-columns:
            1fr
            1fr;

        gap:
            15px;
    }


    .focus-card {

        margin-top:
            0;
    }


    .summary-grid {

        grid-template-columns:
            1fr
            1fr;
    }
}


@media
(max-width: 850px) {

    :root {

        --sidebar-width:
            0px;
    }


    .sidebar {

        display:
            none;
    }


    .main {

        width:
            100%;

        margin-left:
            0;
    }


    .topbar {

        padding:
            0 20px;
    }


    .content {

        padding:
            28px 20px 45px;
    }


    .filter-form {

        grid-template-columns:
            1fr
            1fr;
    }


    .search-button {

        min-height:
            40px;
    }


    .task-card {

        grid-template-columns:
            auto
            1fr;
    }


    .task-due,
    .task-actions {

        grid-column:
            2;

        justify-self:
            start;

        text-align:
            left;
    }
}


@media
(max-width: 600px) {

    .summary-grid {

        grid-template-columns:
            1fr;
    }


    .page-intro {

        align-items:
            flex-start;

        flex-direction:
            column;
    }


    .new-task-button {

        width:
            100%;

        justify-content:
            center;
    }


    .right-column {

        grid-template-columns:
            1fr;
    }


    .filter-form {

        grid-template-columns:
            1fr;
    }


    .tabs {

        gap:
            14px;

        overflow-x:
            auto;
    }


    .form-row {

        grid-template-columns:
            1fr;
    }


    .breadcrumb {

        font-size:
            9px;
    }
}

</style>

</head>


<body>


<div class="app">


<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<aside class="sidebar">


    <div class="brand">

        <div class="brand-logo">
            ✓✓
        </div>


        <div>

            <div class="brand-name">

                <strong>
                    TaskNexus
                </strong>

                <span class="pro-badge">
                    PRO
                </span>

            </div>

            <p>
                Personal workspace
            </p>

        </div>

    </div>


    <div class="menu-title">
        WORKSPACE
    </div>


    <a
            href="<%= request.getContextPath() %>/tasks"
            class="nav-item">

        <span class="nav-icon">
            ▦
        </span>

        <span class="nav-label">
            All tasks
        </span>

        <span class="nav-count">
            <%= totalTasks %>
        </span>

    </a>


    <a
            href="#tasks"
            class="nav-item">

        <span class="nav-icon">
            ▣
        </span>

        <span class="nav-label">
            Due today
        </span>

        <span class="nav-count">
            <%= dueTodayCount %>
        </span>

    </a>


    <a
            href="#tasks"
            class="nav-item">

        <span class="nav-icon">
            ◷
        </span>

        <span class="nav-label">
            Upcoming
        </span>

        <span class="nav-count">
            <%= upcomingCount %>
        </span>

    </a>


    <a
            href="<%= request.getContextPath() %>/tasks?status=Completed"
            class="nav-item
            <%= "Completed".equalsIgnoreCase(statusValue)
                    ? "active"
                    : "" %>">

        <span class="nav-icon">
            ✓
        </span>

        <span class="nav-label">
            Completed
        </span>

        <span class="nav-count">
            <%= completedTasks %>
        </span>

    </a>


    <div class="menu-title">
        QUICK FILTERS
    </div>


    <a
            href="<%= request.getContextPath() %>/tasks?priority=High"
            class="nav-item">

        <span class="nav-icon">
            ⚑
        </span>

        <span class="nav-label">
            High priority
        </span>

        <span class="nav-count">
            <%= highPriorityCount %>
        </span>

    </a>


    <a
            href="#tasks"
            class="nav-item">

        <span class="nav-icon">
            ⚠
        </span>

        <span class="nav-label">
            Overdue
        </span>

        <span class="nav-count">
            <%= overdueCount %>
        </span>

    </a>


    <div class="private-card">

        <div class="private-card-header">

            <span>
                🔒
            </span>

            <strong>
                Your private workspace
            </strong>

        </div>

        <p>
            Your TaskNexus workspace is accessible
            only from this application.
        </p>

    </div>


    <div class="sidebar-user">

        <div class="sidebar-avatar">
            ME
        </div>

        <div>

            <strong>
                My workspace
            </strong>

            <small>
                TaskNexus Pro
            </small>

        </div>

    </div>

</aside>



<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="main">


<!-- =========================================================
     TOP BAR
     ========================================================= -->

<header class="topbar">


    <div class="breadcrumb">

        <span>
            Workspace
        </span>

        <span>
            ›
        </span>

        <strong>
            My tasks
        </strong>

    </div>


    <div class="private-badge">

        <span>
            ▣
        </span>

        Private

    </div>

</header>



<!-- =========================================================
     CONTENT
     ========================================================= -->

<main class="content">


<!-- =========================================================
     INTRO
     ========================================================= -->

<section class="page-intro">


    <div>

        <div class="eyebrow">
            YOUR WORK, IN FOCUS
        </div>

        <h1>
            My task workspace<span>.</span>
        </h1>

        <p>
            A clear view of what matters next.
        </p>

    </div>


    <button
            id="openTaskModalButton"
            type="button"
            class="new-task-button"
            onclick="openTaskModal()">

        <span>
            ＋
        </span>

        New task

    </button>

</section>



<!-- =========================================================
     SUMMARY
     ========================================================= -->

<section class="summary-grid">


    <article class="summary-card">


        <div class="summary-top">

            <span class="summary-label">
                Total tasks
            </span>

            <div class="summary-icon blue">
                ▱
            </div>

        </div>


        <div
                id="totalTasks"
                class="summary-number">

            <%= totalTasks %>

        </div>


        <div class="summary-help">
            Across your workspace
        </div>

    </article>



    <article class="summary-card">


        <div class="summary-top">

            <span class="summary-label">
                In progress
            </span>

            <div class="summary-icon amber">
                ◷
            </div>

        </div>


        <div
                id="progressTasks"
                class="summary-number">

            <%= inProgressTasks %>

        </div>


        <div class="summary-help">

            <span id="pendingTasks">
                <%= pendingTasks %>
            </span>

            tasks ready to start

        </div>

    </article>



    <article class="summary-card">


        <div class="summary-top">

            <span class="summary-label">
                Completed
            </span>

            <div class="summary-icon green">
                ✓
            </div>

        </div>


        <div
                id="completedTasks"
                class="summary-number">

            <%= completedTasks %>

        </div>


        <div class="summary-help">

            <%= completionRate %>%
            of all tasks

        </div>

    </article>



    <article class="summary-card">


        <div class="summary-top">

            <span class="summary-label">
                Overdue
            </span>

            <div class="summary-icon red">
                ◴
            </div>

        </div>


        <div class="summary-number">

            <%= overdueCount %>

        </div>


        <div class="summary-help">

            <%= overdueCount > 0
                    ? "A little attention needed"
                    : "Everything is on track" %>

        </div>

    </article>

</section>



<!-- =========================================================
     WORKSPACE
     ========================================================= -->

<section class="workspace-layout">


<!-- =========================================================
     LEFT
     ========================================================= -->

<div class="task-panel">


    <div class="task-panel-head">


        <div>

            <div class="task-panel-title">

                <h2>
                    All tasks
                </h2>

                <span class="small-count">

                    <%= tasks != null
                            ? tasks.size()
                            : 0 %>

                </span>

            </div>

            <p>
                Small steps. Steady progress.
            </p>

        </div>


        <div class="view-controls">

            <button
                    id="listViewButton"
                    type="button"
                    class="active"
                    onclick="setListView()">

                ☷ List

            </button>

            <button
                    id="dateViewButton"
                    type="button"
                    onclick="sortByDate()">

                ▣ By date

            </button>

        </div>

    </div>



    <!-- FILTERS -->

    <div class="filters">


        <form
                id="taskFilterForm"
                class="filter-form"
                method="get"
                action="<%= request.getContextPath() %>/tasks">


            <input
                    id="searchTask"
                    class="filter-control"
                    type="text"
                    name="search"
                    value="<%= esc(searchValue) %>"
                    placeholder="Search tasks...">


            <select
                    id="priorityFilter"
                    class="filter-control"
                    name="priority">


                <option
                        value="All"
                        <%= "All".equalsIgnoreCase(priorityValue)
                                ? "selected"
                                : "" %>>

                    Any priority

                </option>


                <option
                        value="High"
                        <%= "High".equalsIgnoreCase(priorityValue)
                                ? "selected"
                                : "" %>>

                    High

                </option>


                <option
                        value="Medium"
                        <%= "Medium".equalsIgnoreCase(priorityValue)
                                ? "selected"
                                : "" %>>

                    Medium

                </option>


                <option
                        value="Low"
                        <%= "Low".equalsIgnoreCase(priorityValue)
                                ? "selected"
                                : "" %>>

                    Low

                </option>

            </select>


            <select
                    id="statusFilter"
                    class="filter-control"
                    name="status">


                <option
                        value="All"
                        <%= "All".equalsIgnoreCase(statusValue)
                                ? "selected"
                                : "" %>>

                    Any status

                </option>


                <option
                        value="Pending"
                        <%= "Pending".equalsIgnoreCase(statusValue)
                                ? "selected"
                                : "" %>>

                    To do

                </option>


                <option
                        value="In Progress"
                        <%= "In Progress".equalsIgnoreCase(statusValue)
                                ? "selected"
                                : "" %>>

                    In progress

                </option>


                <option
                        value="Completed"
                        <%= "Completed".equalsIgnoreCase(statusValue)
                                ? "selected"
                                : "" %>>

                    Completed

                </option>

            </select>


            <button
                    id="searchButton"
                    type="submit"
                    class="search-button">

                Apply

            </button>

        </form>

    </div>



    <!-- TABS -->

    <div class="tabs">


        <a
                href="<%= request.getContextPath() %>/tasks"
                class="tab
                <%= "All".equalsIgnoreCase(statusValue)
                        ? "active"
                        : "" %>">

            All tasks

            <span class="tab-count">
                <%= totalTasks %>
            </span>

        </a>


        <a
                href="<%= request.getContextPath() %>/tasks?status=Pending"
                class="tab
                <%= "Pending".equalsIgnoreCase(statusValue)
                        ? "active"
                        : "" %>">

            To do

            <span class="tab-count">
                <%= pendingTasks %>
            </span>

        </a>


        <a
                href="<%= request.getContextPath() %>/tasks?status=In%20Progress"
                class="tab
                <%= "In Progress".equalsIgnoreCase(statusValue)
                        ? "active"
                        : "" %>">

            In progress

            <span class="tab-count">
                <%= inProgressTasks %>
            </span>

        </a>


        <a
                href="<%= request.getContextPath() %>/tasks?status=Completed"
                class="tab
                <%= "Completed".equalsIgnoreCase(statusValue)
                        ? "active"
                        : "" %>">

            Completed

            <span class="tab-count">
                <%= completedTasks %>
            </span>

        </a>


        <a
                id="resetButton"
                href="<%= request.getContextPath() %>/tasks"
                class="reset-link">

            ↻ Reset

        </a>

    </div>



    <!-- TASKS -->

    <div
            id="taskGrid"
            class="task-grid">


<%
        if (tasks != null
                && !tasks.isEmpty()) {

            for (Task task : tasks) {


                String statusSlug =
                        task.getStatus() != null
                                ? task.getStatus()
                                      .toLowerCase()
                                      .replace(
                                              " ",
                                              "-"
                                      )
                                : "pending";


                String prioritySlug =
                        task.getPriority() != null
                                ? task.getPriority()
                                      .toLowerCase()
                                : "medium";


                boolean isOverdue =
                        task.getDueDate() != null
                        && task.getDueDate()
                               .isBefore(today)
                        && !"Completed"
                               .equalsIgnoreCase(
                                       task.getStatus()
                               );


                String dueText =
                        "No due date";


                if (task.getDueDate() != null) {

                    if (task.getDueDate()
                            .equals(today)) {

                        dueText =
                                "Today";

                    } else if (task.getDueDate()
                            .equals(tomorrow)) {

                        dueText =
                                "Tomorrow";

                    } else {

                        dueText =
                                task.getDueDate()
                                    .toString();
                    }
                }
%>


        <article
                class="task-card <%= statusSlug %>"
                data-due="<%= task.getDueDate() != null
                        ? task.getDueDate()
                        : "" %>">


            <div class="task-status-icon">

                <%= "Completed".equalsIgnoreCase(
                        task.getStatus())
                        ? "✓"
                        : "•" %>

            </div>


            <div>


                <div class="task-title">

                    <%= esc(task.getTitle()) %>

                </div>


                <div class="task-description">

                    <%= esc(
                            task.getDescription() != null
                                    ? task.getDescription()
                                    : "No description available."
                    ) %>

                </div>


                <div class="task-badges">

                    <span class="badge category-badge">

                        <%= esc(
                                task.getCategory() != null
                                        ? task.getCategory()
                                        : "General"
                        ) %>

                    </span>


                    <span
                            class="badge priority <%= prioritySlug %>">

                        <%= esc(task.getPriority()) %>

                    </span>


                    <span class="status">

                        <%= esc(task.getStatus()) %>

                    </span>

                </div>

            </div>


            <div class="task-due">

                <small>
                    DUE
                </small>

                <strong
                        class="<%= isOverdue
                                ? "overdue"
                                : "" %>">

                    <%= dueText %>

                </strong>

            </div>


            <div class="task-actions">


<%
                if ("Pending"
                        .equalsIgnoreCase(
                                task.getStatus()
                        )) {
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

                        Start

                    </button>

                </form>

<%
                }
%>


<%
                if (!"Completed"
                        .equalsIgnoreCase(
                                task.getStatus()
                        )) {
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

                        Complete

                    </button>

                </form>

<%
                }
%>


                <form
                        method="post"
                        action="<%= request.getContextPath() %>/tasks"
                        onsubmit="
                            return confirm(
                                'Delete this task?'
                            );
                        ">

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


        <div class="empty-state">

            <div class="empty-icon">
                ☷
            </div>

            <h3>
                No Tasks Found
            </h3>

            <p>
                No tasks match the selected filters.
            </p>

        </div>


<%
        }
%>

    </div>

</div>



<!-- =========================================================
     RIGHT COLUMN
     ========================================================= -->

<aside class="right-column">


    <section class="progress-panel">


        <div class="progress-header">

            <h3>
                Your progress
            </h3>

            <span>
                ✓
            </span>

        </div>


        <div class="progress-ring">

            <div class="progress-ring-content">

                <strong>
                    <%= completionRate %>%
                </strong>

                <small>
                    completed
                </small>

            </div>

        </div>


        <div class="progress-stats">

            <span>
                <%= completedTasks %>
                completed
            </span>

            <span>
                <%= remainingTasks %>
                remaining
            </span>

        </div>


        <div class="progress-line">

            <span></span>

        </div>


        <div class="progress-footer">

            <%= remainingTasks %>
            tasks to move forward

        </div>

    </section>



    <section class="focus-card">

        <h3>
            Today at a glance
        </h3>

        <p>
            Keep your most important work visible
            and move one task forward at a time.
        </p>


        <div class="focus-row">

            <span>
                Due today
            </span>

            <strong>
                <%= dueTodayCount %>
            </strong>

        </div>


        <div class="focus-row">

            <span>
                High priority
            </span>

            <strong>
                <%= highPriorityCount %>
            </strong>

        </div>


        <div class="focus-row">

            <span>
                Overdue
            </span>

            <strong>
                <%= overdueCount %>
            </strong>

        </div>

    </section>

</aside>

</section>

</main>

</div>

</div>



<!-- =========================================================
     CREATE TASK MODAL
     ========================================================= -->

<div
        id="taskModal"
        class="modal">


    <div class="modal-card">


        <div class="modal-head">


            <div>

                <h2>
                    Create a new task
                </h2>

                <p>
                    Add the details and keep your workspace moving.
                </p>

            </div>


            <button
                    id="closeTaskModalButton"
                    class="close-button"
                    type="button"
                    onclick="closeTaskModal()">

                ×

            </button>

        </div>


        <form
                id="createTaskForm"
                method="post"
                action="<%= request.getContextPath() %>/tasks">


            <input
                    type="hidden"
                    name="action"
                    value="add">


            <div class="form-group">

                <label for="taskTitle">
                    Task title
                </label>

                <input
                        id="taskTitle"
                        type="text"
                        name="title"
                        maxlength="100"
                        placeholder="What needs to be done?"
                        required>

            </div>


            <div class="form-group">

                <label for="taskDescription">
                    Description
                </label>

                <textarea
                        id="taskDescription"
                        name="description"
                        maxlength="500"
                        placeholder="Add useful details..."
                        required></textarea>

            </div>


            <div class="form-row">


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

                        <option value="Documentation">
                            Documentation
                        </option>

                        <option value="Meeting">
                            Meeting
                        </option>

                        <option value="Personal">
                            Personal
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label for="taskPriority">
                        Priority
                    </label>

                    <select
                            id="taskPriority"
                            name="priority">

                        <option value="High">
                            High
                        </option>

                        <option
                                value="Medium"
                                selected>

                            Medium

                        </option>

                        <option value="Low">
                            Low
                        </option>

                    </select>

                </div>

            </div>


            <div class="form-group">

                <label for="taskDueDate">
                    Due date
                </label>

                <input
                        id="taskDueDate"
                        type="date"
                        name="dueDate">

            </div>


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

                    Create task

                </button>

            </div>

        </form>

    </div>

</div>



<script>

/* =========================================================
   MODAL
   ========================================================= */

function openTaskModal() {

    const modal =
        document.getElementById(
            "taskModal"
        );

    modal.classList.add(
        "show"
    );

    document.body.style.overflow =
        "hidden";


    setTimeout(
        function () {

            document
                .getElementById(
                    "taskTitle"
                )
                .focus();

        },
        100
    );
}



function closeTaskModal() {

    document
        .getElementById(
            "taskModal"
        )
        .classList
        .remove(
            "show"
        );

    document.body.style.overflow =
        "auto";
}



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



document.addEventListener(
    "keydown",
    function (event) {

        if (event.key === "Escape") {

            closeTaskModal();
        }
    }
);



/* =========================================================
   MIN DATE
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const dateInput =
            document.getElementById(
                "taskDueDate"
            );


        const current =
            new Date();


        const year =
            current.getFullYear();


        const month =
            String(
                current.getMonth() + 1
            )
            .padStart(
                2,
                "0"
            );


        const day =
            String(
                current.getDate()
            )
            .padStart(
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
);



/* =========================================================
   LIST VIEW
   ========================================================= */

function setListView() {

    const grid =
        document.getElementById(
            "taskGrid"
        );


    grid.style.gridTemplateColumns =
        "1fr";


    document
        .getElementById(
            "listViewButton"
        )
        .classList
        .add(
            "active"
        );


    document
        .getElementById(
            "dateViewButton"
        )
        .classList
        .remove(
            "active"
        );
}



/* =========================================================
   SORT BY DATE
   ========================================================= */

function sortByDate() {

    const grid =
        document.getElementById(
            "taskGrid"
        );


    const cards =
        Array.from(
            grid.querySelectorAll(
                ".task-card"
            )
        );


    cards.sort(
        function (a, b) {

            const aDate =
                a.dataset.due || "9999-12-31";

            const bDate =
                b.dataset.due || "9999-12-31";


            return aDate.localeCompare(
                bDate
            );
        }
    );


    cards.forEach(
        function (card) {

            grid.appendChild(
                card
            );
        }
    );


    document
        .getElementById(
            "dateViewButton"
        )
        .classList
        .add(
            "active"
        );


    document
        .getElementById(
            "listViewButton"
        )
        .classList
        .remove(
            "active"
        );
}

</script>


</body>


</html>