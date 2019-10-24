package cn.hy.controller;

import cn.hy.bean.Emplovee;
import cn.hy.bean.Msg;
import cn.hy.service.EmploveeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;

@Controller
public class EmployeeController {

    @Autowired
    EmploveeService emploveeService;


    /**
     * 单个 批量二选一
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids")String ids){
        if (ids.contains("-")){
            List<Integer> del_ids=new ArrayList<>();
            String[] str_ids=ids.split("-");
            //组装id的集合
            for (String string:str_ids){
               del_ids.add(Integer.parseInt(string));
            }
            emploveeService.deleteBatch(del_ids);

        }else {
            Integer id=Integer.parseInt(ids);
            emploveeService.deleteEmp(id);
        }
        return Msg.success();
    }

    /**
     * 如果发送ajax=PUT形式的请求
     * 封装的数据
     * Employee
     * [empId=1014,empName=null,...]
     *
     * 问题：
     * 请求体中有数据；
     * 但是Employee对象封装不上
     * 原因：
     * TOmcat
     *  1.将请求体中的数据，封装一个Map
     *  2.resquest.getParameter("empName")就会从这个Map中取值。
     *  springmvc封装pojo对象的时候，会把pojo每个属性的值,resquest.getParameter("empName")
     *
     *  ajax发送put请求
     *    请求体中的数据拿不到，
     *    TOMCAT不会封装put请求数据，只有post形式的数据才能封装到map
     *
     *    配置上HTTpPutFromContentFilter;
     *    将请求体中的数据解析包装成一个map。
     *    request被重新包装,request.getParameter()被重写，就会从自己封装map中取数据
     * 员工更新
     * @param emplovee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Emplovee emplovee){
        //System.out.println(emplovee);
       emploveeService.updateEmp(emplovee);
        return Msg.success();
    }

    /**
     * 根据ID查询
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
          Emplovee emplovee=emploveeService.getEmp(id);
          return Msg.success().add("emp",emplovee);
    }


    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkuse(@RequestParam("empName") String empName){
        //先判断用户名是否是合法的表达式
        String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg","用户名必须是6-16位数字和字母或者2-5位中文");
        }
       //数据库用户名重复校验
        boolean b=emploveeService.checkUser(empName);
        if (b){
            return Msg.success();
        }
        else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 保存员工
     * 1.支持JSR303校验
     * 2.导入Hibernate-Validatoe
     * @param emplovee
     * @return
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Emplovee emplovee, BindingResult result) {
        if (result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String,Object> map=new HashMap<>();
            List<FieldError> errors= (List<FieldError>) result.getFieldError();
            for (FieldError fieldError:errors){
                System.out.println("错误的字段名"+fieldError.getField());
                System.out.println("错误信息"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());

            }
            return Msg.fail().add("errorFields",map);
        }
        else {
            emploveeService.saveEmp(emplovee);
            return Msg.success();
        }
    }

    @RequestMapping("/emps")
    /**
     * 返回json，需要导入jackson包
     */
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn) {
        //这不是分页查询
        //引入PageHelper分页插件
        //查询之前调用,传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPagr紧跟的查询就是分页查询
        List<Emplovee> emps = emploveeService.getAll();
        //用PageInfo对结果进行包装,只需要蒋pageinfo交给页面
        //封装了详细的分页信息，包括查询的数据,传入连续显示的页数
        PageInfo page=new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }
    /**
     * 查询员工列表(分页查询)
     * @return
     */
    /*@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn
    ,Model model){
        //这不是分页查询
        //引入PageHelper分页插件
        //查询之前调用,传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPagr紧跟的查询就是分页查询
        List<Emplovee> emps = emploveeService.getAll();
        //用PageInfo对结果进行包装,只需要蒋pageinfo交给页面
        //封装了详细的分页信息，包括查询的数据,传入连续显示的页数
        PageInfo page = new PageInfo(emps,5);
        model.addAttribute("pageInfo",page);

        return "list";
    }*/
}

