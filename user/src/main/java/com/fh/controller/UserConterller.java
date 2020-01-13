package com.fh.controller;

import com.fh.model.Area;
import com.fh.model.DataTableResult;
import com.fh.model.User;
import com.fh.model.UserQuery;
import com.fh.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("UserController")
public class UserConterller {

    @Autowired
    private UserService userService;


    //跳转到用户展示页面
    @RequestMapping("toUserList")
    public String toUserList() {
        return "user/user-list";
    }

    //分页条件查询用户信息
    @RequestMapping("queryUserList")
    @ResponseBody
    public DataTableResult queryUserList(UserQuery userQuery) {
        DataTableResult dataTableResult = userService.queryUserList(userQuery);
        return dataTableResult;
    }

    //查询所有地区
    @RequestMapping("queryAreaList")
    @ResponseBody
    public Map<String,Object> queryAreaList(){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Area> areaList = userService.queryAreaList();
            result.put("data",areaList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //查询所有地区
    @RequestMapping("queryAreaListByPid")
    @ResponseBody
    public Map<String,Object> queryAreaListByPid(Integer pid){
        Map<String,Object> result = new HashMap<>();
        try {
            List<Area> areaList = userService.queryAreaListByPid(pid);
            result.put("data",areaList);
            result.put("code",200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code",500);
        }
        return result;
    }

    //新增用户
    @RequestMapping("addUser")
    @ResponseBody
    public Map<String, Object> addUser(User user) {
        Map<String, Object> result = new HashMap<>();
        try {
            userService.addUser(user);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

    //修改用户
    @RequestMapping("updateUser")
    @ResponseBody
    public Map<String, Object> updateUser(User user) {
        Map<String, Object> result = new HashMap<>();
        try {
            userService.updateUser(user);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

    //通过ID查询单个用户
    @RequestMapping("getUserById")
    @ResponseBody
    public Map<String, Object> getUserById(Integer id, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = userService.getUserById(id);
            result.put("data", user);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

    @RequestMapping("getAreaById")
    @ResponseBody
    public Map<String, Object> getAreaById(Integer id) {
        Map<String, Object> result = new HashMap<>();
        try {
            Area area = userService.getAreaById(id);
            result.put("data", area);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

    //删除用户
    @RequestMapping("deleteUser")
    @ResponseBody
    public Map<String, Object> deleteUser(Integer id, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            userService.deleteUser(id);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

    //批量删除用户
    @RequestMapping("batchDeleteUser")
    @ResponseBody
    public Map<String, Object> batchDeleteUser(@RequestParam("ids[]") List<Integer> idList, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            userService.batchDeleteUser(idList);
            result.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
        }
        return result;
    }

}
