package top.hcode.hoj.dao;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import top.hcode.hoj.pojo.entity.Judge;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import top.hcode.hoj.pojo.vo.JudgeVo;
import top.hcode.hoj.pojo.vo.ProblemCountVo;


/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author Himit_ZH
 * @since 2020-10-23
 */
@Mapper
@Repository
public interface JudgeMapper extends BaseMapper<Judge> {
    IPage<JudgeVo> getCommonJudgeList(Page<JudgeVo> page, @Param("searchPid") String searchPid, @Param("status") Integer status,
                                      @Param("username") String username, @Param("uid") String uid);

    IPage<JudgeVo> getContestJudgeList(Page<JudgeVo> page, @Param("displayId") String displayId, @Param("cid") Long cid, @Param("status") Integer status,
                                       @Param("username") String username, @Param("uid") String uid, @Param("beforeContestSubmit") Boolean beforeContestSubmit);

    int getTodayJudgeNum();

    ProblemCountVo getContestProblemCount(@Param("pid") Long pid, @Param("cpid") Long cpid, @Param("cid") Long cid);

    ProblemCountVo getProblemCount(@Param("pid") Long pid);
}
