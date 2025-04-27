package cn.xxrbear.picturebackend.controller;

import cn.xxrbear.picturebackend.common.BaseResponse;
import cn.xxrbear.picturebackend.common.ResultUtils;
import cn.xxrbear.picturebackend.exception.ErrorCode;
import cn.xxrbear.picturebackend.exception.ThrowUtils;
import cn.xxrbear.picturebackend.model.dto.UserRegisterRequest;
import cn.xxrbear.picturebackend.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public BaseResponse<Long> userRegister(@RequestBody UserRegisterRequest userRegisterRequest) {
        ThrowUtils.throwIf(userRegisterRequest == null, ErrorCode.PARAMS_ERROR);
        String userAccount = userRegisterRequest.getUserAccount();
        String userPassword = userRegisterRequest.getUserPassword();
        String checkPassword = userRegisterRequest.getCheckPassword();
        long result = userService.userRegister(userAccount, userPassword, checkPassword);
        return ResultUtils.success(result);
    }
}
