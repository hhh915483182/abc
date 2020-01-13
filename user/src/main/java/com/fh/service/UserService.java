package com.fh.service;

import com.fh.model.Area;
import com.fh.model.DataTableResult;
import com.fh.model.User;
import com.fh.model.UserQuery;

import java.util.List;

public interface UserService {
    DataTableResult queryUserList(UserQuery userQuery);

    void addUser(User user);

    User getUserById(Integer id);

    void deleteUser(Integer id);

    void batchDeleteUser(List<Integer> idList);

    void updateUser(User user);

    List<Area> queryAreaList();

    List<Area> queryAreaListByPid(Integer pid);

    Area getAreaById(Integer id);
}
