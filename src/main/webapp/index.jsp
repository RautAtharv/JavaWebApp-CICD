<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <meta name="description"
          content="Java Web Application CI/CD Pipeline using GitHub, Jenkins, Maven, Docker and Apache Tomcat">

    <title>DevFlow | Java CI/CD Pipeline</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>

        /* =========================================================
           GLOBAL
        ========================================================= */

        :root {

            --bg: #07111f;
            --bg-secondary: #0b1728;

            --card: rgba(255,255,255,0.055);
            --card-hover: rgba(255,255,255,0.085);

            --border: rgba(255,255,255,0.10);

            --text: #f8fafc;
            --muted: #94a3b8;

            --primary: #38bdf8;
            --primary-dark: #0284c7;

            --green: #22c55e;
            --purple: #a78bfa;

            --shadow:
                0 20px 60px rgba(0,0,0,0.35);

            --radius: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {

            font-family: 'Inter', sans-serif;

            background:
                radial-gradient(
                    circle at 15% 10%,
                    rgba(56,189,248,0.13),
                    transparent 28%
                ),
                radial-gradient(
                    circle at 85% 30%,
                    rgba(167,139,250,0.10),
                    transparent 25%
                ),
                var(--bg);

            color: var(--text);

            min-height: 100vh;

            overflow-x: hidden;
        }

        a {
            color: inherit;
            text-decoration: none;
        }


        /* =========================================================
           BACKGROUND GRID
        ========================================================= */

        body::before {

            content: "";

            position: fixed;

            inset: 0;

            pointer-events: none;

            background-image:
                linear-gradient(
                    rgba(255,255,255,0.025) 1px,
                    transparent 1px
                ),
                linear-gradient(
                    90deg,
                    rgba(255,255,255,0.025) 1px,
                    transparent 1px
                );

            background-size: 50px 50px;

            mask-image: linear-gradient(
                to bottom,
                black,
                transparent 80%
            );

            z-index: -1;
        }


        /* =========================================================
           NAVBAR
        ========================================================= */

        .navbar {

            position: sticky;

            top: 0;

            z-index: 1000;

            height: 76px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 7%;

            background: rgba(7,17,31,0.78);

            backdrop-filter: blur(18px);

            border-bottom: 1px solid var(--border);
        }


        .brand {

            display: flex;

            align-items: center;

            gap: 12px;

            font-size: 19px;

            font-weight: 800;

            letter-spacing: -0.5px;
        }


        .brand-logo {

            width: 38px;

            height: 38px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 11px;

            background:
                linear-gradient(
                    135deg,
                    #38bdf8,
                    #6366f1
                );

            box-shadow:
                0 0 30px rgba(56,189,248,0.25);
        }


        .brand-logo svg {
            width: 22px;
            height: 22px;
        }


        .nav-links {

            display: flex;

            align-items: center;

            gap: 30px;
        }


        .nav-links a {

            color: var(--muted);

            font-size: 14px;

            font-weight: 500;

            transition: 0.25s;
        }


        .nav-links a:hover {
            color: white;
        }


        .nav-status {

            display: flex;

            align-items: center;

            gap: 8px;

            padding: 8px 13px;

            border: 1px solid rgba(34,197,94,0.25);

            background: rgba(34,197,94,0.08);

            border-radius: 30px;

            color: #86efac;

            font-size: 12px;

            font-weight: 600;
        }


        .status-dot {

            width: 7px;

            height: 7px;

            border-radius: 50%;

            background: var(--green);

            box-shadow: 0 0 10px var(--green);

            animation: pulse 2s infinite;
        }


        @keyframes pulse {

            0%,100% {
                opacity: 1;
                transform: scale(1);
            }

            50% {
                opacity: .55;
                transform: scale(.75);
            }
        }


        /* =========================================================
           HERO
        ========================================================= */

        .hero {

            position: relative;

            min-height: 700px;

            display: grid;

            grid-template-columns: 1.1fr .9fr;

            align-items: center;

            gap: 70px;

            padding: 90px 7% 100px;
        }


        .hero-content {
            max-width: 760px;
        }


        .eyebrow {

            display: inline-flex;

            align-items: center;

            gap: 9px;

            padding: 8px 13px;

            border-radius: 30px;

            border: 1px solid rgba(56,189,248,0.25);

            background: rgba(56,189,248,0.07);

            color: #7dd3fc;

            font-size: 12px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1px;

            margin-bottom: 25px;
        }


        .eyebrow-icon {

            width: 7px;

            height: 7px;

            background: var(--primary);

            border-radius: 50%;

            box-shadow: 0 0 12px var(--primary);
        }


        .hero h1 {

            font-size: clamp(46px, 6vw, 78px);

            line-height: 1.02;

            letter-spacing: -4px;

            margin-bottom: 25px;
        }


        .gradient-text {

            background:
                linear-gradient(
                    100deg,
                    #38bdf8,
                    #818cf8,
                    #c084fc
                );

            -webkit-background-clip: text;

            background-clip: text;

            color: transparent;
        }


        .hero-description {

            max-width: 650px;

            color: var(--muted);

            font-size: 17px;

            line-height: 1.8;

            margin-bottom: 35px;
        }


        .hero-buttons {

            display: flex;

            flex-wrap: wrap;

            gap: 14px;
        }


        .btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 10px;

            padding: 14px 21px;

            border-radius: 12px;

            font-size: 14px;

            font-weight: 700;

            cursor: pointer;

            transition: .25s;

            border: 1px solid transparent;
        }


        .btn-primary {

            background:
                linear-gradient(
                    135deg,
                    #38bdf8,
                    #6366f1
                );

            color: white;

            box-shadow:
                0 10px 30px rgba(56,189,248,0.20);
        }


        .btn-primary:hover {

            transform: translateY(-3px);

            box-shadow:
                0 15px 40px rgba(56,189,248,0.30);
        }


        .btn-secondary {

            background: rgba(255,255,255,0.04);

            border-color: var(--border);

            color: white;
        }


        .btn-secondary:hover {

            background: rgba(255,255,255,0.08);

            transform: translateY(-3px);
        }


        /* =========================================================
           TERMINAL CARD
        ========================================================= */

        .terminal {

            position: relative;

            background:
                linear-gradient(
                    145deg,
                    rgba(255,255,255,0.09),
                    rgba(255,255,255,0.035)
                );

            border: 1px solid var(--border);

            border-radius: 22px;

            overflow: hidden;

            box-shadow: var(--shadow);

            transform: perspective(1000px) rotateY(-4deg);

            transition: .4s;
        }


        .terminal:hover {

            transform:
                perspective(1000px)
                rotateY(0deg)
                translateY(-5px);
        }


        .terminal-top {

            height: 48px;

            display: flex;

            align-items: center;

            gap: 7px;

            padding: 0 17px;

            border-bottom: 1px solid var(--border);

            background: rgba(0,0,0,.15);
        }


        .terminal-dot {

            width: 10px;

            height: 10px;

            border-radius: 50%;

            background: #64748b;
        }


        .terminal-title {

            margin-left: 10px;

            color: #64748b;

            font-size: 11px;

            font-family: monospace;
        }


        .terminal-body {

            padding: 25px;

            font-family: 'Courier New', monospace;

            font-size: 13px;

            line-height: 2;
        }


        .terminal-line {
            color: #94a3b8;
        }


        .terminal-green {
            color: #4ade80;
        }


        .terminal-blue {
            color: #38bdf8;
        }


        .terminal-purple {
            color: #c084fc;
        }


        .terminal-yellow {
            color: #facc15;
        }


        .cursor {

            display: inline-block;

            width: 7px;

            height: 15px;

            background: #38bdf8;

            vertical-align: middle;

            animation: blink 1s infinite;
        }


        @keyframes blink {

            50% {
                opacity: 0;
            }
        }


        /* =========================================================
           STATS
        ========================================================= */

        .stats {

            padding: 0 7% 70px;
        }


        .stats-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 16px;
        }


        .stat-card {

            padding: 25px;

            border-radius: 17px;

            background: var(--card);

            border: 1px solid var(--border);

            transition: .3s;
        }


        .stat-card:hover {

            transform: translateY(-4px);

            background: var(--card-hover);
        }


        .stat-number {

            font-size: 28px;

            font-weight: 800;

            margin-bottom: 5px;
        }


        .stat-label {

            color: var(--muted);

            font-size: 13px;
        }


        /* =========================================================
           SECTION
        ========================================================= */

        .section {

            padding: 100px 7%;
        }


        .section-heading {

            max-width: 700px;

            margin-bottom: 50px;
        }


        .section-label {

            color: #38bdf8;

            font-size: 12px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.5px;

            margin-bottom: 12px;
        }


        .section-heading h2 {

            font-size: clamp(32px, 4vw, 48px);

            letter-spacing: -2px;

            margin-bottom: 15px;
        }


        .section-heading p {

            color: var(--muted);

            line-height: 1.8;

            font-size: 15px;
        }


        /* =========================================================
           TECHNOLOGY
        ========================================================= */

        .tech-grid {

            display: grid;

            grid-template-columns:
                repeat(5, 1fr);

            gap: 15px;
        }


        .tech-card {

            padding: 28px 20px;

            min-height: 190px;

            display: flex;

            flex-direction: column;

            justify-content: space-between;

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: var(--radius);

            transition: .3s;
        }


        .tech-card:hover {

            transform: translateY(-7px);

            border-color:
                rgba(56,189,248,0.35);

            background: var(--card-hover);
        }


        .tech-icon {

            width: 50px;

            height: 50px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 14px;

            font-size: 24px;

            background: rgba(56,189,248,0.09);

            border: 1px solid
                rgba(56,189,248,0.12);
        }


        .tech-card h3 {

            font-size: 16px;

            margin-top: 20px;

            margin-bottom: 7px;
        }


        .tech-card p {

            color: var(--muted);

            font-size: 12px;

            line-height: 1.6;
        }


        /* =========================================================
           PIPELINE
        ========================================================= */

        .pipeline-section {

            padding: 100px 7%;

            background:
                linear-gradient(
                    180deg,
                    transparent,
                    rgba(56,189,248,0.035),
                    transparent
                );
        }


        .pipeline-container {

            padding: 40px;

            border: 1px solid var(--border);

            background: rgba(255,255,255,0.035);

            border-radius: 25px;

            overflow-x: auto;
        }


        .pipeline {

            min-width: 950px;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .pipeline-item {

            display: flex;

            align-items: center;
        }


        .pipeline-node {

            width: 105px;

            height: 105px;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            gap: 8px;

            border-radius: 18px;

            background:
                linear-gradient(
                    145deg,
                    rgba(56,189,248,.10),
                    rgba(255,255,255,.035)
                );

            border: 1px solid
                rgba(56,189,248,.20);

            text-align: center;

            transition: .3s;
        }


        .pipeline-node:hover {

            transform: translateY(-7px);

            border-color: #38bdf8;

            box-shadow:
                0 10px 35px
                rgba(56,189,248,.15);
        }


        .pipeline-icon {

            font-size: 25px;
        }


        .pipeline-node strong {

            font-size: 11px;
        }


        .pipeline-node small {

            color: var(--muted);

            font-size: 9px;
        }


        .pipeline-arrow {

            width: 45px;

            height: 1px;

            position: relative;

            background:
                linear-gradient(
                    90deg,
                    #38bdf8,
                    #6366f1
                );
        }


        .pipeline-arrow::after {

            content: "";

            position: absolute;

            right: 0;

            top: -4px;

            width: 8px;

            height: 8px;

            border-top: 1px solid #6366f1;

            border-right: 1px solid #6366f1;

            transform: rotate(45deg);
        }


        /* =========================================================
           ARCHITECTURE
        ========================================================= */

        .architecture {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 25px;
        }


        .architecture-card {

            padding: 32px;

            border-radius: var(--radius);

            border: 1px solid var(--border);

            background: var(--card);
        }


        .architecture-card h3 {

            font-size: 18px;

            margin-bottom: 25px;
        }


        .architecture-flow {

            display: flex;

            flex-direction: column;

            gap: 12px;
        }


        .architecture-row {

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 15px 17px;

            background: rgba(255,255,255,.035);

            border: 1px solid var(--border);

            border-radius: 12px;

            font-size: 13px;
        }


        .architecture-row span:last-child {

            color: #38bdf8;

            font-family: monospace;

            font-size: 11px;
        }


        /* =========================================================
           FEATURES
        ========================================================= */

        .features {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;
        }


        .feature {

            padding: 28px;

            background: var(--card);

            border: 1px solid var(--border);

            border-radius: var(--radius);

            transition: .3s;
        }


        .feature:hover {

            transform: translateY(-5px);

            background: var(--card-hover);
        }


        .feature-number {

            color: #38bdf8;

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 20px;
        }


        .feature h3 {

            margin-bottom: 10px;

            font-size: 17px;
        }


        .feature p {

            color: var(--muted);

            line-height: 1.7;

            font-size: 13px;
        }


        /* =========================================================
           FOOTER
        ========================================================= */

        footer {

            border-top: 1px solid var(--border);

            padding: 45px 7%;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 30px;
        }


        .footer-brand {

            font-weight: 700;

            margin-bottom: 7px;
        }


        .footer-text {

            color: var(--muted);

            font-size: 12px;
        }


        .footer-stack {

            display: flex;

            gap: 10px;

            flex-wrap: wrap;

            justify-content: flex-end;
        }


        .footer-tag {

            padding: 7px 11px;

            border-radius: 8px;

            background: rgba(255,255,255,.04);

            border: 1px solid var(--border);

            color: #94a3b8;

            font-size: 10px;
        }


        /* =========================================================
           RESPONSIVE
        ========================================================= */

        @media(max-width: 1100px) {

            .hero {

                grid-template-columns: 1fr;

            }

            .terminal {

                max-width: 750px;

            }

            .tech-grid {

                grid-template-columns:
                    repeat(3, 1fr);
            }

        }


        @media(max-width: 800px) {

            .nav-links {
                display: none;
            }

            .navbar {
                padding: 0 5%;
            }

            .hero,
            .section,
            .pipeline-section {

                padding-left: 5%;
                padding-right: 5%;
            }

            .stats {
                padding-left: 5%;
                padding-right: 5%;
            }

            .stats-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .tech-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .architecture {

                grid-template-columns: 1fr;
            }

            .features {

                grid-template-columns: 1fr;
            }

            footer {

                flex-direction: column;

                align-items: flex-start;
            }

            .footer-stack {

                justify-content: flex-start;
            }

        }


        @media(max-width: 500px) {

            .hero h1 {

                font-size: 42px;

                letter-spacing: -2px;
            }

            .stats-grid,
            .tech-grid {

                grid-template-columns: 1fr;
            }

            .hero-buttons {

                flex-direction: column;

                align-items: stretch;
            }

            .btn {
                width: 100%;
            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     NAVIGATION
========================================================= -->

<header class="navbar">

    <a href="#home" class="brand">

        <span class="brand-logo">

            <svg viewBox="0 0 24 24"
                 fill="none"
                 stroke="white"
                 stroke-width="2">

                <path d="M12 3v18"/>
                <path d="M3 12h18"/>
                <circle cx="12" cy="12" r="8"/>

            </svg>

        </span>

        DevFlow

    </a>


    <nav class="nav-links">

        <a href="#technology">
            Technology
        </a>

        <a href="#pipeline">
            Pipeline
        </a>

        <a href="#architecture">
            Architecture
        </a>

        <a href="#features">
            Features
        </a>

    </nav>


    <div class="nav-status">

        <span class="status-dot"></span>

        System Online

    </div>

</header>



<!-- =========================================================
     HERO
========================================================= -->

<main id="home">

<section class="hero">

    <div class="hero-content">

        <div class="eyebrow">

            <span class="eyebrow-icon"></span>

            Java DevOps Project

        </div>


        <h1>

            Build.

            <span class="gradient-text">
                Test.
            </span>

            Deploy.

            <br>

            Automatically.

        </h1>


        <p class="hero-description">

            A production-style Java web application demonstrating
            a complete Continuous Integration and Continuous
            Deployment workflow using GitHub, Jenkins, Maven,
            JUnit, Docker and Apache Tomcat.

        </p>


        <div class="hero-buttons">

            <a href="#pipeline"
               class="btn btn-primary">

                Explore Pipeline

                <span>→</span>

            </a>


            <a href="#technology"
               class="btn btn-secondary">

                View Technology

            </a>

        </div>

    </div>



    <!-- TERMINAL -->

    <div class="terminal">

        <div class="terminal-top">

            <span class="terminal-dot"></span>
            <span class="terminal-dot"></span>
            <span class="terminal-dot"></span>

            <span class="terminal-title">
                deployment-terminal
            </span>

        </div>


        <div class="terminal-body">

            <div class="terminal-line">
                <span class="terminal-blue">
                    $ git push origin main
                </span>
            </div>

            <div class="terminal-line">
                → Triggering Jenkins pipeline...
            </div>

            <br>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [1/7]
                </span>
                Checkout source code
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [2/7]
                </span>
                Maven compilation
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [3/7]
                </span>
                JUnit tests
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [4/7]
                </span>
                Generate WAR
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [5/7]
                </span>
                Build Docker image
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [6/7]
                </span>
                Deploy to Tomcat
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <div class="terminal-line">
                <span class="terminal-purple">
                    [7/7]
                </span>
                Health check
                <span class="terminal-green">
                    ✓
                </span>
            </div>

            <br>

            <div class="terminal-line">

                <span class="terminal-green">
                    SUCCESS
                </span>

                Deployment completed successfully.

            </div>

            <div>

                <span class="terminal-blue">
                    $
                </span>

                <span class="cursor"></span>

            </div>

        </div>

    </div>

</section>



<!-- =========================================================
     STATS
========================================================= -->

<section class="stats">

    <div class="stats-grid">

        <div class="stat-card">

            <div class="stat-number">
                07
            </div>

            <div class="stat-label">
                Pipeline Stages
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-number">
                100%
            </div>

            <div class="stat-label">
                Automated Deployment
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-number">
                8081
            </div>

            <div class="stat-label">
                Application Port
            </div>

        </div>


        <div class="stat-card">

            <div class="stat-number">
                WAR
            </div>

            <div class="stat-label">
                Deployment Artifact
            </div>

        </div>

    </div>

</section>



<!-- =========================================================
     TECHNOLOGY
========================================================= -->

<section class="section"
         id="technology">

    <div class="section-heading">

        <div class="section-label">
            Technology Stack
        </div>

        <h2>
            Everything needed to ship software.
        </h2>

        <p>
            Each technology has a specific role in the pipeline,
            from source control and testing to containerization
            and deployment.
        </p>

    </div>


    <div class="tech-grid">


        <div class="tech-card">

            <div class="tech-icon">
                ☕
            </div>

            <div>

                <h3>
                    Java
                </h3>

                <p>
                    Core programming language used to build
                    the web application.
                </p>

            </div>

        </div>


        <div class="tech-card">

            <div class="tech-icon">
                📦
            </div>

            <div>

                <h3>
                    Maven
                </h3>

                <p>
                    Compiles the project and generates the
                    deployable WAR artifact.
                </p>

            </div>

        </div>


        <div class="tech-card">

            <div class="tech-icon">
                🧪
            </div>

            <div>

                <h3>
                    JUnit
                </h3>

                <p>
                    Automatically verifies application
                    functionality through unit tests.
                </p>

            </div>

        </div>


        <div class="tech-card">

            <div class="tech-icon">
                ⚙
            </div>

            <div>

                <h3>
                    Jenkins
                </h3>

                <p>
                    Orchestrates the complete CI/CD pipeline
                    automatically.
                </p>

            </div>

        </div>


        <div class="tech-card">

            <div class="tech-icon">
                🐳
            </div>

            <div>

                <h3>
                    Docker
                </h3>

                <p>
                    Packages the application into a portable
                    container image.
                </p>

            </div>

        </div>

    </div>

</section>



<!-- =========================================================
     PIPELINE
========================================================= -->

<section class="pipeline-section"
         id="pipeline">

    <div class="section-heading">

        <div class="section-label">
            Continuous Delivery
        </div>

        <h2>
            From commit to deployment.
        </h2>

        <p>
            Every stage is connected so a successful code change
            can move automatically from GitHub to the running
            Tomcat application.
        </p>

    </div>


    <div class="pipeline-container">

        <div class="pipeline">


            <div class="pipeline-item">

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        👨‍💻
                    </div>

                    <strong>
                        Developer
                    </strong>

                    <small>
                        Commit
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        📂
                    </div>

                    <strong>
                        GitHub
                    </strong>

                    <small>
                        Source
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        ⚙️
                    </div>

                    <strong>
                        Jenkins
                    </strong>

                    <small>
                        CI/CD
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        🔨
                    </div>

                    <strong>
                        Maven
                    </strong>

                    <small>
                        Build
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        🧪
                    </div>

                    <strong>
                        JUnit
                    </strong>

                    <small>
                        Test
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        🐳
                    </div>

                    <strong>
                        Docker
                    </strong>

                    <small>
                        Image
                    </small>

                </div>

            </div>


            <div class="pipeline-item">

                <div class="pipeline-arrow"></div>

                <div class="pipeline-node">

                    <div class="pipeline-icon">
                        🚀
                    </div>

                    <strong>
                        Tomcat
                    </strong>

                    <small>
                        Deploy
                    </small>

                </div>

            </div>


        </div>

    </div>

</section>



<!-- =========================================================
     ARCHITECTURE
========================================================= -->

<section class="section"
         id="architecture">

    <div class="section-heading">

        <div class="section-label">
            System Architecture
        </div>

        <h2>
            A clean path from source to production.
        </h2>

        <p>
            The application is packaged as a WAR file and
            delivered through a containerized Tomcat runtime.
        </p>

    </div>


    <div class="architecture">


        <div class="architecture-card">

            <h3>
                Application Flow
            </h3>

            <div class="architecture-flow">

                <div class="architecture-row">

                    <span>
                        Source Code
                    </span>

                    <span>
                        GitHub
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Build
                    </span>

                    <span>
                        Maven
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Artifact
                    </span>

                    <span>
                        JavaWebApp.war
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Container
                    </span>

                    <span>
                        Docker
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Runtime
                    </span>

                    <span>
                        Tomcat :8080
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Access
                    </span>

                    <span>
                        Host :8081
                    </span>

                </div>

            </div>

        </div>



        <div class="architecture-card">

            <h3>
                Deployment Environment
            </h3>

            <div class="architecture-flow">

                <div class="architecture-row">

                    <span>
                        Docker Image
                    </span>

                    <span>
                        javawebapp:1.0
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Container
                    </span>

                    <span>
                        javawebapp
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Web Server
                    </span>

                    <span>
                        Apache Tomcat
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Internal Port
                    </span>

                    <span>
                        8080
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Host Port
                    </span>

                    <span>
                        8081
                    </span>

                </div>


                <div class="architecture-row">

                    <span>
                        Status
                    </span>

                    <span style="color:#4ade80;">
                        ● ONLINE
                    </span>

                </div>

            </div>

        </div>

    </div>

</section>



<!-- =========================================================
     FEATURES
========================================================= -->

<section class="section"
         id="features">

    <div class="section-heading">

        <div class="section-label">
            Engineering Benefits
        </div>

        <h2>
            Designed for reliable delivery.
        </h2>

        <p>
            The project demonstrates the fundamental practices
            used in modern DevOps workflows.
        </p>

    </div>


    <div class="features">


        <div class="feature">

            <div class="feature-number">
                01 / CONTINUOUS INTEGRATION
            </div>

            <h3>
                Automated Builds
            </h3>

            <p>
                Every source-code change can trigger Jenkins
                to compile and validate the application using
                Maven.
            </p>

        </div>


        <div class="feature">

            <div class="feature-number">
                02 / QUALITY
            </div>

            <h3>
                Automated Testing
            </h3>

            <p>
                JUnit tests run during the pipeline so broken
                changes can be detected before deployment.
            </p>

        </div>


        <div class="feature">

            <div class="feature-number">
                03 / PACKAGING
            </div>

            <h3>
                Reproducible Artifacts
            </h3>

            <p>
                Maven produces a consistent JavaWebApp.war
                artifact that can be deployed across environments.
            </p>

        </div>


        <div class="feature">

            <div class="feature-number">
                04 / CONTAINERS
            </div>

            <h3>
                Portable Deployment
            </h3>

            <p>
                Docker packages Tomcat and the application
                into a consistent runtime environment.
            </p>

        </div>


        <div class="feature">

            <div class="feature-number">
                05 / DELIVERY
            </div>

            <h3>
                Continuous Deployment
            </h3>

            <p>
                Jenkins can automatically build the Docker image
                and deploy the latest successful version.
            </p>

        </div>


        <div class="feature">

            <div class="feature-number">
                06 / MONITORING
            </div>

            <h3>
                Deployment Visibility
            </h3>

            <p>
                Health checks and monitoring tools can verify
                that the deployed application remains available.
            </p>

        </div>

    </div>

</section>

</main>



<!-- =========================================================
     FOOTER
========================================================= -->

<footer>

    <div>

        <div class="footer-brand">
            DevFlow — Java CI/CD Pipeline
        </div>

        <div class="footer-text">
            A demonstration of automated build, test,
            containerization and deployment.
        </div>

    </div>


    <div class="footer-stack">

        <span class="footer-tag">
            Java
        </span>

        <span class="footer-tag">
            Maven
        </span>

        <span class="footer-tag">
            JUnit
        </span>

        <span class="footer-tag">
            Jenkins
        </span>

        <span class="footer-tag">
            Docker
        </span>

        <span class="footer-tag">
            Tomcat
        </span>

    </div>

</footer>


</body>


</html>