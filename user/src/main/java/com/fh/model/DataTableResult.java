package com.fh.model;

import java.util.List;

public class DataTableResult {
	
	//和DataTablePageBean中draw的值保持一致即可
	private Integer draw;

	//过滤后的总条数
    private Long recordsFiltered;

    //总条数
    private Long recordsTotal;

    //用于存储查询到当前页数据的集合
    private List data;

	public Integer getDraw() {
		return draw;
	}

	public void setDraw(Integer draw) {
		this.draw = draw;
	}


	public Long getRecordsFiltered() {
		return recordsFiltered;
	}

	public void setRecordsFiltered(Long recordsFiltered) {
		this.recordsFiltered = recordsFiltered;
	}

	public Long getRecordsTotal() {
		return recordsTotal;
	}

	public void setRecordsTotal(Long recordsTotal) {
		this.recordsTotal = recordsTotal;
	}

	public List getData() {
		return data;
	}

	public void setData(List data) {
		this.data = data;
	}

	public DataTableResult(Integer draw, Long recordsFiltered, Long recordsTotal, List data) {
		super();
		this.draw = draw;
		this.recordsFiltered = recordsFiltered;
		this.recordsTotal = recordsTotal;
		this.data = data;
	}
	
}
