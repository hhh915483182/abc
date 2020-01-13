package com.fh.mapper;

import com.fh.model.Area;
import com.fh.model.User;
import com.fh.model.UserQuery;

import java.util.List;

public interface UserMapper {
    Long queryUserCount(UserQuery userQuery);

    List<User> queryUserList(UserQuery userQuery);

    void addUser(User user);

    User getUserById(Integer id);

    void updateUser(User user);

    void deleteUser(Integer id);

    void batchDeleteUser(List<Integer> idList);

    List<Area> queryAreaList();

    List<Area> queryAreaListByPid(Integer pid);

    Area getAreaById(Integer id);
}
