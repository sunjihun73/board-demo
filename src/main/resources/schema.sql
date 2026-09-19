DROP TABLE IF EXISTS board;

CREATE TABLE board (
    id          BIGSERIAL     PRIMARY KEY,
    title       VARCHAR(200)  NOT NULL,
    content     VARCHAR(4000) NOT NULL,
    writer      VARCHAR(50)   NOT NULL,
    view_count  INT           NOT NULL DEFAULT 0,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_board_writer ON board (writer);
