package com.example.board.controller;

import com.example.board.domain.Board;
import com.example.board.domain.PageInfo;
import com.example.board.service.BoardService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final int PAGE_SIZE = 10;

    private final BoardService boardService;

    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    @GetMapping("/list")
    public String list(@RequestParam(name = "page", defaultValue = "1") int page, Model model) {
        int total = boardService.countAll();
        PageInfo pageInfo = new PageInfo(page, PAGE_SIZE, total);
        List<Board> boards = boardService.getList(pageInfo.getOffset(), pageInfo.getSize());

        model.addAttribute("boards", boards);
        model.addAttribute("pageInfo", pageInfo);
        return "board/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(name = "id") Long id, Model model) {
        Board board = boardService.get(id);
        if (board == null) {
            return "redirect:/board/list";
        }
        model.addAttribute("board", board);
        return "board/detail";
    }

    @GetMapping("/writeForm")
    public String writeForm() {
        return "board/form";
    }

    @PostMapping("/write")
    public String write(@RequestParam(name = "title") String title,
                        @RequestParam(name = "content") String content,
                        HttpSession session) {
        String writer = (String) session.getAttribute("loginUser");
        boardService.write(title, content, writer);
        return "redirect:/board/list";
    }

    /** 레거시 작성자별 조회 화면 */
    @GetMapping("/writerList")
    public String writerList(@RequestParam(name = "writer", defaultValue = "") String writer, Model model) {
        model.addAttribute("writer", writer);
        model.addAttribute("boards", boardService.getByWriter(writer));
        return "board/writerList";
    }
}
