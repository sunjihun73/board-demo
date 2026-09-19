package com.example.board.service;

import com.example.board.domain.Board;
import com.example.board.mapper.BoardMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BoardService {

    private final BoardMapper boardMapper;

    public BoardService(BoardMapper boardMapper) {
        this.boardMapper = boardMapper;
    }

    @Transactional(readOnly = true)
    public List<Board> getList(int offset, int limit) {
        return boardMapper.selectList(offset, limit);
    }

    @Transactional(readOnly = true)
    public int countAll() {
        return boardMapper.selectCount();
    }

    @Transactional
    public Board get(Long id) {
        boardMapper.increaseViewCount(id);
        return boardMapper.selectById(id);
    }

    @Transactional
    public Long write(String title, String content, String writer) {
        Board board = new Board();
        board.setTitle(title);
        board.setContent(content);
        board.setWriter(writer);
        boardMapper.insert(board);
        return board.getId();
    }

    @Transactional(readOnly = true)
    public List<Board> getByWriter(String writer) {
        return boardMapper.selectByWriterLegacy(writer);
    }
}
