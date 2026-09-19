package com.example.board.domain;

/** 목록 페이징 계산 결과 */
public class PageInfo {

    private static final int PAGE_BLOCK = 5;

    private final int page;
    private final int size;
    private final int total;
    private final int totalPages;
    private final int startPage;
    private final int endPage;

    public PageInfo(int requestedPage, int size, int total) {
        this.size = size;
        this.total = total;
        this.totalPages = Math.max(1, (int) Math.ceil((double) total / size));

        int current = Math.max(1, requestedPage);
        this.page = Math.min(current, this.totalPages);

        this.startPage = ((this.page - 1) / PAGE_BLOCK) * PAGE_BLOCK + 1;
        this.endPage = Math.min(this.startPage + PAGE_BLOCK - 1, this.totalPages);
    }

    public int getOffset() {
        return (page - 1) * size;
    }

    public int getPage() {
        return page;
    }

    public int getSize() {
        return size;
    }

    public int getTotal() {
        return total;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public int getStartPage() {
        return startPage;
    }

    public int getEndPage() {
        return endPage;
    }

    public boolean isHasPrev() {
        return page > 1;
    }

    public boolean isHasNext() {
        return page < totalPages;
    }
}
