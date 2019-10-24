package cn.hy.service;

import cn.hy.bean.DepartmentExample;
import cn.hy.bean.Emplovee;
import cn.hy.bean.EmploveeExample;
import cn.hy.dao.EmploveeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.ErrorManager;

@Service
public class EmploveeService {

    //查询所有员工
    @Autowired
    EmploveeMapper emploveeMapper;
    public List<Emplovee> getAll() {
        return (List<Emplovee>) emploveeMapper.selectByExampleWithDept(null);
    }

    //保存员工信息
    public void saveEmp(Emplovee emplovee) {
        emploveeMapper.insertSelective(emplovee);
    }

    /**
     * true可用
     * @param empName
     * @return
     */
    //校验员工用户名是否可用
    public boolean checkUser(String empName) {
        EmploveeExample example=new EmploveeExample();
        EmploveeExample.Criteria criteria=example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count= (long) emploveeMapper.countByExample(example);
        return count==0;
    }

    /**
     * 按照员工Id查询员工
     * @param id
     * @return
     */

    public Emplovee getEmp(Integer id) {
       Emplovee emplovee= emploveeMapper.selectByPrimaryKey(id);
       return emplovee;
    }

    /**
     * 员工更新
     * @param emplovee
     */
    public void updateEmp(Emplovee emplovee) {
        emploveeMapper.updateByPrimaryKeySelective(emplovee);
    }

    /**
     * 员工删除
     * @param id
     */
    public void deleteEmp(Integer id) {
        emploveeMapper.deleteByPrimaryKey(id);
    }

    /**
     * 批量删除
     * @param ids
     */
    public void deleteBatch(List<Integer> ids) {
        EmploveeExample e=new EmploveeExample();
        EmploveeExample.Criteria criteria=e.createCriteria();
        criteria.andEmpIdIn(ids);
        emploveeMapper.deleteByExample(e);

    }
}
