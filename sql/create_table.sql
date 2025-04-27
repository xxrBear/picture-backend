-- 创建库
create database yu_picture;


CREATE TABLE IF NOT EXISTS "user" (
    id           BIGSERIAL PRIMARY KEY,
    "userAccount"  VARCHAR(256) NOT NULL,
    "userPassword" VARCHAR(512) NOT NULL,
    "userName"     VARCHAR(256),
    "userAvatar"   VARCHAR(1024),
    "userProfile"  VARCHAR(512),
    "userRole"     VARCHAR(256) NOT NULL DEFAULT 'user',
    "editTime"     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createTime"   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateTime"   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isDelete"     SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT uk_userAccount UNIQUE ("userAccount")
);
-- 创建索引
CREATE INDEX IF NOT EXISTS idx_userName ON "user" ("userName");

-- 添加表注释
COMMENT ON TABLE "user" IS '用户';

-- 添加列注释
COMMENT ON COLUMN "user".id IS 'id';
COMMENT ON COLUMN "user"."userAccount" IS '账号';
COMMENT ON COLUMN "user"."userPassword" IS '密码';
COMMENT ON COLUMN "user"."userName" IS '用户昵称';
COMMENT ON COLUMN "user"."userAvatar" IS '用户头像';
COMMENT ON COLUMN "user"."userProfile" IS '用户简介';
COMMENT ON COLUMN "user"."userRole" IS '用户角色：user/admin';
COMMENT ON COLUMN "user"."editTime" IS '编辑时间';
COMMENT ON COLUMN "user"."createTime" IS '创建时间';
COMMENT ON COLUMN "user"."updateTime" IS '更新时间';
COMMENT ON COLUMN "user"."isDelete" IS '是否删除';

-- 图片表
create table if not exists picture
(
    id           bigint auto_increment comment 'id' primary key,
    url          varchar(512)                       not null comment '图片 url',
    name         varchar(128)                       not null comment '图片名称',
    introduction varchar(512)                       null comment '简介',
    category     varchar(64)                        null comment '分类',
    tags         varchar(512)                       null comment '标签（JSON 数组）',
    "picSize"      bigint                             null comment '图片体积',
    "picWidth"     int                                null comment '图片宽度',
    "picHeight"    int                                null comment '图片高度',
    "picScale"     double                             null comment '图片宽高比例',
    "picFormat"    varchar(32)                        null comment '图片格式',
    "userId"       bigint                             not null comment '创建用户 id',
    "createTime"   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    "editTime"     datetime default CURRENT_TIMESTAMP not null comment '编辑时间',
    "updateTime"   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    "isDelete"     tinyint  default 0                 not null comment '是否删除',
    INDEX idx_name (name),                 -- 提升基于图片名称的查询性能
    INDEX idx_introduction (introduction), -- 用于模糊搜索图片简介
    INDEX idx_category (category),         -- 提升基于分类的查询性能
    INDEX idx_tags (tags),                 -- 提升基于标签的查询性能
    INDEX idx_userId (userId)              -- 提升基于用户 ID 的查询性能
) comment '图片' collate = utf8mb4_unicode_ci;


ALTER TABLE picture
    -- 添加新列
    ADD COLUMN reviewStatus INT DEFAULT 0 NOT NULL COMMENT '审核状态：0-待审核; 1-通过; 2-拒绝',
    ADD COLUMN reviewMessage VARCHAR(512) NULL COMMENT '审核信息',
    ADD COLUMN reviewerId BIGINT NULL COMMENT '审核人 ID',
    ADD COLUMN reviewTime DATETIME NULL COMMENT '审核时间';

-- 创建基于 reviewStatus 列的索引
CREATE INDEX idx_reviewStatus ON picture (reviewStatus);

ALTER TABLE picture
    -- 添加新列
    ADD COLUMN thumbnailUrl varchar(512) NULL COMMENT '缩略图 url';


-- 空间表
create table if not exists space
(
    id         bigint auto_increment comment 'id' primary key,
    spaceName  varchar(128)                       null comment '空间名称',
    spaceLevel int      default 0                 null comment '空间级别：0-普通版 1-专业版 2-旗舰版',
    maxSize    bigint   default 0                 null comment '空间图片的最大总大小',
    maxCount   bigint   default 0                 null comment '空间图片的最大数量',
    totalSize  bigint   default 0                 null comment '当前空间下图片的总大小',
    totalCount bigint   default 0                 null comment '当前空间下的图片数量',
    userId     bigint                             not null comment '创建用户 id',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    editTime   datetime default CURRENT_TIMESTAMP not null comment '编辑时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete   tinyint  default 0                 not null comment '是否删除',
    -- 索引设计
    index idx_userId (userId),        -- 提升基于用户的查询效率
    index idx_spaceName (spaceName),  -- 提升基于空间名称的查询效率
    index idx_spaceLevel (spaceLevel) -- 提升按空间级别查询的效率
) comment '空间' collate = utf8mb4_unicode_ci;

-- 添加新列
ALTER TABLE picture
    ADD COLUMN spaceId bigint  null comment '空间 id（为空表示公共空间）';

-- 创建索引
CREATE INDEX idx_spaceId ON picture (spaceId);

-- 添加新列
ALTER TABLE picture
    ADD COLUMN picColor varchar(16) null comment '图片主色调';

-- 支持空间类型，添加新列
ALTER TABLE space
    ADD COLUMN spaceType int default 0 not null comment '空间类型：0-私有 1-团队';

CREATE INDEX idx_spaceType ON space (spaceType);

-- 空间成员表
create table if not exists space_user
(
    id         bigint auto_increment comment 'id' primary key,
    spaceId    bigint                                 not null comment '空间 id',
    userId     bigint                                 not null comment '用户 id',
    spaceRole  varchar(128) default 'viewer'          null comment '空间角色：viewer/editor/admin',
    createTime datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    -- 索引设计
    UNIQUE KEY uk_spaceId_userId (spaceId, userId), -- 唯一索引，用户在一个空间中只能有一个角色
    INDEX idx_spaceId (spaceId),                    -- 提升按空间查询的性能
    INDEX idx_userId (userId)                       -- 提升按用户查询的性能
) comment '空间用户关联' collate = utf8mb4_unicode_ci;

-- 扩展用户表：新增会员功能
ALTER TABLE user
    ADD COLUMN vipExpireTime datetime NULL COMMENT '会员过期时间',
    ADD COLUMN vipCode varchar(128) NULL COMMENT '会员兑换码',
    ADD COLUMN vipNumber bigint NULL COMMENT '会员编号';
