package com.fh.model;

public class DataTablePageBean {
	
	//不用管
	private Integer draw;
	
	//起始下标
	private Integer start;
	
	//每页显示条数
	private Integer length;

	public Integer getDraw() {
		return draw;
	}

	public void setDraw(Integer draw) {
		this.draw = draw;
	}

	public Integer getStart() {
		return start;
	}

	public void setStart(Integer start) {
		this.start = start;
	}

	public Integer getLength() {
		return length;
	}

	public void setLength(Integer length) {
		this.length = length;
	}

}
