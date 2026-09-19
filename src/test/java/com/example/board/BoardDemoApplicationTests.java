package com.example.board;

import com.example.board.service.BoardService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class BoardDemoApplicationTests {

    @Autowired
    private BoardService boardService;

    @Test
    void 컨텍스트가_로딩되고_예제데이터가_존재한다() {
        assertThat(boardService.countAll()).isGreaterThan(0);
        assertThat(boardService.getList(0, 10)).hasSize(10);
    }
}
