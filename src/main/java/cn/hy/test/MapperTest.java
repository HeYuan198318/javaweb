package cn.hy.test;

import cn.hy.bean.Department;
import cn.hy.bean.Emplovee;
import cn.hy.dao.DepartmentMapper;
import cn.hy.dao.EmploveeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 *测试dao层的工作
 *@author
 *推荐Spring的项目使用Spring的单元测试，可以自动注入我们需要的组件
 *1.导入SpringTest模块
 *2.@ContextConfiguration指定Spring配置文件的位置
 *3.直接autoWried要使用的组件
 **/
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    /**
     * 测试DepartmentMapper
     */
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmploveeMapper emploveeMapper;
    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
     /*   //1.创建SpringIOC容器
        ApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
        //2.从容器中获取Mapper
        DepartmentMapper bean=ioc.getBean(DepartmentMapper.class);*/
       System.out.print(departmentMapper);

       Department deprecated=new Department();
       //deprecated.setDeptId("");
       deprecated.setDeptName("开发部");

       //1.插入部门
        /*departmentMapper.insertSelective(deprecated);
        departmentMapper.insertSelective(new Department(null,"测试部"));*/

        //2.生成员工数据
//        emploveeMapper.insertSelective(new Emplovee(null,"张三","M","张三@qq.com",1));
       //3.批量插入多个员工，使用可以执行批量操作的sqlsession
//        for (){
//            emploveeMapper.insertSelective(new Emplovee(null,"张三","M","张三@qq.com",1));
//        }


        EmploveeMapper mapper=sqlSession.getMapper(EmploveeMapper.class);
        for (int i=0;i<1000;i++){
            /**
             * UUID含义是通用唯一识别码 (Universally Unique Identifier)，这 是一个软件建构的标准，
             * 也是被开源软件基金会 (Open Software Foundation, OSF) 的组织应用在分布式计算环境
             * (Distributed Computing Environment, DCE) 领域的重要部分。
             * https://www.cnblogs.com/lzhh/p/javaweb_2.html
             */
            String uid= UUID.randomUUID().toString().substring(0,5)+i;
            mapper.insertSelective(new Emplovee(null,uid,"M",uid+"@atguigu.com",1));
        }

        System.out.print("批量插入完成");
    }

}
