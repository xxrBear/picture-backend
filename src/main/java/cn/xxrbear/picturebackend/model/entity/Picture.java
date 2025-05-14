package cn.xxrbear.picturebackend.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@TableName(value = "\"picture\"")
@Data
public class Picture implements Serializable {
    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /**
     * 图片 url
     */
    private String url;

    /**
     * 图片名称
     */
    private String name;

    /**
     * 简介
     */
    private String introduction;

    /**
     * 分类
     */
    private String category;

    /**
     * 标签（JSON 数组）
     */
    private String tags;

    /**
     * 图片体积
     */
    @TableField(value = "\"picSize\"")
    private Long picSize;

    /**
     * 图片宽度
     */
    @TableField(value = "\"picWidth\"")
    private Integer picWidth;

    /**
     * 图片高度
     */
    @TableField(value = "\"picHeight\"")
    private Integer picHeight;

    /**
     * 图片宽高比例
     */
    @TableField(value = "\"picScale\"")
    private Double picScale;

    /**
     * 图片格式
     */
    @TableField(value = "\"picFormat\"")
    private String picFormat;

    /**
     * 创建用户 id
     */
    @TableField(value = "\"userId\"")
    private Long userId;

    /**
     * 创建时间
     */
    @TableField(value = "\"createTime\"")
    private Date createTime;

    /**
     * 编辑时间
     */
    @TableField(value = "\"editTime\"")
    private Date editTime;

    /**
     * 更新时间
     */
    @TableField(value = "\"updateTime\"")
    private Date updateTime;

    /**
     * 是否删除
     */
    @TableLogic
    @TableField(value = "\"isDelete\"")
    private Integer isDelete;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;


    /**
     * 状态：0-待审核; 1-通过; 2-拒绝
     */
    @TableField(value = "\"reviewStatus\"")
    private Integer reviewStatus;

    /**
     * 审核信息
     */
    @TableField(value = "\"reviewMessage\"")
    private String reviewMessage;

    /**
     * 审核人 id
     */
    @TableField(value = "\"reviewerId\"")
    private Long reviewerId;

    /**
     * 审核时间
     */
    @TableField(value = "\"reviewTime\"")
    private Date reviewTime;

}

