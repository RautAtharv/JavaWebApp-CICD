package com.demo.servlet;

import com.demo.model.Task;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

    private final List<Task> taskList =
            new CopyOnWriteArrayList<>();

    private final AtomicInteger idGenerator =
            new AtomicInteger(1);

    @Override
    public void init() {

        taskList.add(
                new Task(
                        idGenerator.getAndIncrement(),
                        "Complete DevOps Pipeline",
                        "Configure Jenkins, Maven, Docker and Selenium",
                        "Development",
                        "High",
                        "In Progress",
                        LocalDate.now().plusDays(2)
                )
        );

        taskList.add(
                new Task(
                        idGenerator.getAndIncrement(),
                        "Prepare Project Documentation",
                        "Complete project report and required screenshots",
                        "College",
                        "Medium",
                        "Pending",
                        LocalDate.now().plusDays(5)
                )
        );

        taskList.add(
                new Task(
                        idGenerator.getAndIncrement(),
                        "Application Testing",
                        "Perform automated Selenium testing",
                        "Testing",
                        "High",
                        "Pending",
                        LocalDate.now().plusDays(3)
                )
        );
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String search =
                request.getParameter("search");

        String statusFilter =
                request.getParameter("status");

        String priorityFilter =
                request.getParameter("priority");

        List<Task> filteredTasks =
                new ArrayList<>(taskList);

        // Search
        if (search != null &&
                !search.trim().isEmpty()) {

            String keyword =
                    search.trim().toLowerCase();

            filteredTasks =
                    filteredTasks.stream()
                            .filter(task ->
                                    task.getTitle()
                                            .toLowerCase()
                                            .contains(keyword)

                                    || task.getDescription()
                                            .toLowerCase()
                                            .contains(keyword)

                                    || task.getCategory()
                                            .toLowerCase()
                                            .contains(keyword))
                            .collect(Collectors.toList());
        }

        // Status filter
        if (statusFilter != null &&
                !statusFilter.isEmpty() &&
                !"All".equalsIgnoreCase(statusFilter)) {

            filteredTasks =
                    filteredTasks.stream()
                            .filter(task ->
                                    task.getStatus()
                                            .equalsIgnoreCase(statusFilter))
                            .collect(Collectors.toList());
        }

        // Priority filter
        if (priorityFilter != null &&
                !priorityFilter.isEmpty() &&
                !"All".equalsIgnoreCase(priorityFilter)) {

            filteredTasks =
                    filteredTasks.stream()
                            .filter(task ->
                                    task.getPriority()
                                            .equalsIgnoreCase(priorityFilter))
                            .collect(Collectors.toList());
        }

        long completed =
                taskList.stream()
                        .filter(task ->
                                "Completed".equalsIgnoreCase(
                                        task.getStatus()))
                        .count();

        long pending =
                taskList.stream()
                        .filter(task ->
                                "Pending".equalsIgnoreCase(
                                        task.getStatus()))
                        .count();

        long inProgress =
                taskList.stream()
                        .filter(task ->
                                "In Progress".equalsIgnoreCase(
                                        task.getStatus()))
                        .count();

        request.setAttribute(
                "tasks",
                filteredTasks
        );

        request.setAttribute(
                "totalTasks",
                taskList.size()
        );

        request.setAttribute(
                "completedTasks",
                completed
        );

        request.setAttribute(
                "pendingTasks",
                pending
        );

        request.setAttribute(
                "inProgressTasks",
                inProgress
        );

        request.getRequestDispatcher(
                "/dashboard.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String action =
                request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {

            addTask(request);

        } else if ("delete".equalsIgnoreCase(action)) {

            deleteTask(request);

        } else if ("complete".equalsIgnoreCase(action)) {

            completeTask(request);

        } else if ("progress".equalsIgnoreCase(action)) {

            markInProgress(request);
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/tasks"
        );
    }

    private void addTask(
            HttpServletRequest request) {

        String title =
                request.getParameter("title");

        String description =
                request.getParameter("description");

        String category =
                request.getParameter("category");

        String priority =
                request.getParameter("priority");

        String dueDate =
                request.getParameter("dueDate");

        if (title == null ||
                title.trim().isEmpty()) {

            return;
        }

        LocalDate date = null;

        if (dueDate != null &&
                !dueDate.trim().isEmpty()) {

            try {
                date = LocalDate.parse(dueDate);
            } catch (Exception ignored) {
            }
        }

        Task task =
                new Task(
                        idGenerator.getAndIncrement(),
                        title.trim(),
                        description != null
                                ? description.trim()
                                : "",
                        category != null
                                ? category
                                : "General",
                        priority != null
                                ? priority
                                : "Medium",
                        "Pending",
                        date
                );

        taskList.add(task);
    }

    private void deleteTask(
            HttpServletRequest request) {

        try {

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            taskList.removeIf(
                    task ->
                            task.getId() == id
            );

        } catch (Exception ignored) {
        }
    }

    private void completeTask(
            HttpServletRequest request) {

        try {

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            taskList.stream()
                    .filter(task ->
                            task.getId() == id)
                    .findFirst()
                    .ifPresent(task ->
                            task.setStatus(
                                    "Completed"
                            ));

        } catch (Exception ignored) {
        }
    }

    private void markInProgress(
            HttpServletRequest request) {

        try {

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            taskList.stream()
                    .filter(task ->
                            task.getId() == id)
                    .findFirst()
                    .ifPresent(task ->
                            task.setStatus(
                                    "In Progress"
                            ));

        } catch (Exception ignored) {
        }
    }
}