package com.fh.service;

import com.fh.mapper.UserMapper;
import com.fh.model.Area;
import com.fh.model.DataTableResult;
import com.fh.model.User;
import com.fh.model.UserQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl  implements  UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public DataTableResult queryUserList(UserQuery userQuery) {
        //1.查询总数
        Long count = userMapper.queryUserCount(userQuery);

        //2.查询当前页数据
        List<User> userList =  userMapper.queryUserList(userQuery);

        DataTableResult dataTableResult = new DataTableResult(userQuery.getDraw(),count,count,userList);
        return dataTableResult;
    }


    @Override
    public void addUser(User user) {
        user.setRegisterTime(new Date());
        userMapper.addUser(user);
    }

    @Override
    public User getUserById(Integer id) {
        return userMapper.getUserById(id);
    }

    @Override
    public void deleteUser(Integer id) {
        userMapper.deleteUser(id);
    }

    @Override
    public void batchDeleteUser(List<Integer> idList) {
        userMapper.batchDeleteUser(idList);
    }

    @Override
    public void updateUser(User user) {
        userMapper.updateUser(user);
    }

    @Override
    public List<Area> queryAreaList() {
        return userMapper.queryAreaList();
    }

    @Override
    public List<Area> queryAreaListByPid(Integer pid) {
        return userMapper.queryAreaListByPid(pid);
    }

    @Override
    public Area getAreaById(Integer id) {
        return userMapper.getAreaById(id);
    }
}
