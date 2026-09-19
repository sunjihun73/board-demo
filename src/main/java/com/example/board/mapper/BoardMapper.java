package com.example.board.mapper;

import com.example.board.domain.Board;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardMapper {

    List<Board> selectList(@Param("offset") int offset, @Param("limit") int limit);

    int selectCount();

    Board selectById(@Param("id") Long id);

    int insert(Board board);

    int increaseViewCount(@Param("id") Long id);

    /** 인수받은 레거시 화면에서 사용 중인 작성자 조회 */
    List<Board> selectByWriterLegacy(@Param("writer") String writer);
}
