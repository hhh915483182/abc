package com.fh.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class UserQuery  extends DataTablePageBean{

    private String userName;

    private Integer sex;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date minRegisterTime;//最早创建日期
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date maxRegisterTime;//最晚创建日期


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public Date getMinRegisterTime() {
        return minRegisterTime;
    }

    public void setMinRegisterTime(Date minRegisterTime) {
        this.minRegisterTime = minRegisterTime;
    }

    public Date getMaxRegisterTime() {
        return maxRegisterTime;
    }

    public void setMaxRegisterTime(Date maxRegisterTime) {
        this.maxRegisterTime = maxRegisterTime;
    }
}
