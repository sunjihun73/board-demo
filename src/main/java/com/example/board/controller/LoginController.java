package com.example.board.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @Value("${demo.login.username}")
    private String demoUsername;

    @Value("${demo.login.password}")
    private String demoPassword;

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam(name = "username") String username,
                        @RequestParam(name = "password") String password,
                        HttpSession session,
                        Model model) {
        if (demoUsername.equals(username) && demoPassword.equals(password)) {
            session.setAttribute("loginUser", username);
            return "redirect:/board/list";
        }
        model.addAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
