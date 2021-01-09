<template>
  <el-row class="flex-container">
    <div id="main">
      <el-card shadow>
        <div slot="header">
          <el-row :gutter="18">
            <el-col :md="4" :lg="2">
              <span class="panel-title hidden-md-and-down">Status</span>
            </el-col>
            <el-col :xs="10" :sm="8" :md="4" :lg="4">
              <el-switch
                style="display: block"
                v-model="formFilter.onlyMine"
                active-text="Mine"
                :width="40"
                @change="handleOnlyMine"
                inactive-text="All"
              >
              </el-switch>
            </el-col>

            <el-col :xs="10" :sm="8" :md="5" :lg="4" style="padding-top: 5px;">
              <el-dropdown
                class="drop-menu"
                @command="handleStatusChange"
                placement="bottom"
                trigger="hover"
              >
                <span class="el-dropdown-link">
                  {{status }}
                  <i class="el-icon-caret-bottom"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="All">All</el-dropdown-item>
                  <el-dropdown-item
                    v-for="result in Object.keys(JUDGE_STATUS)"
                    :key="result"
                    :command="result"
                  >
                    {{ JUDGE_STATUS[result].name }}
                  </el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </el-col>

            <el-col  :sm="8" :md="5" :lg="4" class="hidden-xs-only">
              <el-button type="primary"  size="small" icon="el-icon-refresh" round @click="getSubmissions">Refresh</el-button>
            </el-col>
            <el-col :xs="4" class="hidden-sm-and-up">
              <el-button type="primary" size="small" icon="el-icon-refresh" circle @click="getSubmissions"></el-button>
            </el-col>

            <el-col :xs="24" :sm="12" :md="5" :lg="5" class="search">
              <vxe-input
                v-model="formFilter.problemID"
                placeholder="Enter Problem ID"
                type="search"
                size="medium"
                @keyup.enter.native="handleQueryChange"
                @search-click="handleQueryChange"
              ></vxe-input>
            </el-col>
            <el-col :xs="24" :sm="12" :md="5" :lg="5" class="search">
              <vxe-input
                v-model="formFilter.username"
                :disabled="formFilter.onlyMine"
                placeholder="Enter Author"
                type="search"
                size="medium"
                @keyup.enter.native="handleQueryChange"
                @search-click="handleQueryChange"
              ></vxe-input>
            </el-col>
          </el-row>
        </div>
        <vxe-table
          border="inner"
          stripe
          keep-source
          ref="xTable"
          highlight-current-row
          highlight-hover-row
          align="center"
          auto-resize
          :row-class-name="tableRowClassName"
          :data="submissions"
          :loading="loadingTable"
        >
          <vxe-table-column
            field="submitId"
            title="Run ID"
            min-width="100"
          ></vxe-table-column>
          <vxe-table-column
            field="submitTime"
            title="Submit time"
            min-width="150"
          >
          <template v-slot="{ row }">
            <span>{{row.submitTime|localtime}}</span>
          </template>
          </vxe-table-column>
          <vxe-table-column field="pid" title="Problem ID" min-width="100">
            <template v-slot="{ row }">
              <a
                :href="getProblemUri(row.pid)"
                style="color: rgb(87, 163, 243)"
                >{{ row.pid }}</a
              >
            </template>
          </vxe-table-column>
          <vxe-table-column field="status" title="Status" min-width="170">
            <template v-slot="{ row }">
              <span :class="getStatusColor(row.status)">
                <i class="el-icon-loading" v-if="row.status == JUDGE_STATUS_RESERVE['Pending'] || row.status == JUDGE_STATUS_RESERVE['Judging']"></i> 
                {{JUDGE_STATUS[row.status].name}}
              </span>
            </template>
          </vxe-table-column>
          <vxe-table-column
            field="time"
            title="Time"
            min-width="64"
          >
          <template v-slot="{row}">
            <span>{{submissionTimeFormat(row.time)}}</span>
          </template>
          </vxe-table-column>
          <vxe-table-column
            field="memory"
            title="Memory"
            min-width="96"
          >
          <template v-slot="{row}">
            <span>{{submissionMemoryFormat(row.memory)}}</span>
          </template>
          </vxe-table-column>

          <vxe-table-column
            field="length"
            title="Length"
            min-width="60"
          >
          <template v-slot="{row}">
            <span>{{submissionLengthFormat(row.length)}}</span>
          </template>
          </vxe-table-column>

          <vxe-table-column field="language" title="Language" min-width="100">
            <template v-slot="{ row }">
              <span v-if="!row.share&&row.uid!=userInfo.uid&&!isAdminRole">{{row.language}}</span>
              <el-tooltip
                class="item"
                effect="dark"
                content="查看提交详情"
                placement="top"
                v-else
              >
                <el-button type="text" @click="showSubmitDetail(row)">{{
                  row.language
                }}</el-button>
              </el-tooltip>
            </template>
          </vxe-table-column>
          <vxe-table-column
            field="judger"
            title="Judger"
            min-width="100"
          >
          <template v-slot="{ row }">
            <span v-if="row.judger">{{row.judger}}</span>
            <span v-else>--</span>
          </template>
          </vxe-table-column>
          <vxe-table-column
            field="username"
            title="Author"
            min-width="100"
          >
          <template v-slot="{ row }">
              <a
                @click="goUserHome(row.username,row.uid)"
                style="color: rgb(87, 163, 243)"
                >{{ row.username }}</a
              >
            </template>
          </vxe-table-column>
          <!-- 非比赛提交记录，超级管理员可以对提交进行重判 -->
          <vxe-table-column v-if="rejudgeColumnVisible" title="Option" min-width="90">
            <template v-slot="{ row }">
              <vxe-button status="primary" @click="handleRejudge(row)" 
              size="mini" :loading="row.loading">Rejudge</vxe-button>
            </template>
          </vxe-table-column>
        </vxe-table>
      </el-card>
      <Pagination
        :total="total"
        :page-size="limit"
        @on-change="changeRoute"
        :current.sync="currentPage"
      ></Pagination>
    </div>
  </el-row>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import api from "@/common/api";
import { JUDGE_STATUS, USER_TYPE,JUDGE_STATUS_RESERVE } from "@/common/constants";
import utils from "@/common/utils";
import time from "@/common/time";
import Pagination from "@/components/oj/common/Pagination";
import myMessage from '@/common/message'
export default {
  name: "submissionList",
  components: {
    Pagination,
  },
  data() {
    return {
      formFilter: {
        onlyMine: false,
        status: "",
        username: "",
        problemID: "",
      },
      loadingTable: false,
      submissions: [
      ],
      needCheckSubmitIds:{}, // 当前状态为6和7的提交记录Id 需要重新检查更新
      total: 30,
      limit: 15,
      currentPage: 1,
      contestID: "",
      routeName: "",
      JUDGE_STATUS: "",
      autoCheckOpen:false,
      JUDGE_STATUS_RESERVE:{}
    };
  },
  mounted() {
    this.JUDGE_STATUS = Object.assign({}, JUDGE_STATUS);
    this.JUDGE_STATUS_RESERVE = Object.assign({},JUDGE_STATUS_RESERVE);
    // 去除submitting,Not Submitted,Time Limit Exceeded(多的)三种状态
    delete this.JUDGE_STATUS["9"];
    delete this.JUDGE_STATUS["-10"];
    delete this.JUDGE_STATUS["2"];
    this.init();
  },
  methods: {
    init() {
      this.contestID = this.$route.params.contestID;
      let query = this.$route.query;
      this.formFilter.problemID = query.problemID;
      this.formFilter.username = query.username || "";
      this.formFilter.onlyMine = (query.onlyMine+"")=="true"?true:false; // 统一换成字符串判断
      this.formFilter.status = query.status!=''?parseInt(query.status):'';

      if(this.formFilter.onlyMine){ // 当前为搜索自己的提交 那么不可搜索别人的提交
        this.formFilter.username = "";
      }
      this.currentPage = parseInt(query.currentPage) || 1;
      if (this.currentPage < 1) {
        this.currentPage = 1;
      }
      this.routeName = this.$route.name;
      this.getSubmissions();
      
    },
    buildQuery() {
      return {
        onlyMine: this.formFilter.onlyMine,
        status: this.formFilter.status,
        username: this.formFilter.username,
        problemID:this.formFilter.problemID,
        currentPage: this.currentPage,
      };
    },

    submissionTimeFormat(time){
      return utils.submissionTimeFormat(time)
    },

    submissionMemoryFormat(memory){
      return utils.submissionMemoryFormat(memory)
    },

    submissionLengthFormat(length){
      return utils.submissionLengthFormat(length)
    },

    getSubmissions() {
      let params = this.buildQuery();
      params.contestID = this.contestID;
      if(this.formFilter.onlyMine){ // 需要判断是否为登陆状态
        if(this.isAuthenticated){
          params.username = '' // 如果是搜索当前用户的提交记录，那么用户名搜索应该无效
          this.formFilter.username = ''
        }else{
          this.formFilter.onlyMine = false
          myMessage.error("请您先登陆！")
          return;
        }
      }

      let func = this.contestID
        ? "getContestSubmissionList"
        : "getSubmissionList";
      this.loadingTable = true;
      this.submissions = [];
      this.needCheckSubmitIds = {};
      api[func](this.limit,utils.filterEmptyValue(params))
        .then((res) => {
          let data = res.data.data;
          let index = 0;
          for (let v of data.records) {
            if(v.status == JUDGE_STATUS_RESERVE['Pending'] || v.status == JUDGE_STATUS_RESERVE['Judging']){
              this.needCheckSubmitIds[v.submitId] = index
            }
            v.loading = false;
            v.index = index;
            index+=1;
          }
          this.loadingTable = false;
          this.submissions = data.records;
          this.total = data.total;
          if(Object.keys(this.needCheckSubmitIds).length>0){
            this.checkSubmissionsStatus();
          }
        })
        .catch(() => {
          this.loadingTable = false;
        });
    },
    // 对当前提交列表 状态为Pending（6）和Judging（7）的提交记录每2秒查询一下最新结果
    checkSubmissionsStatus() {
      // 使用setTimeout避免一些问题
      if (this.refreshStatus) {
        // 如果之前的提交状态检查还没有停止,则停止,否则将会失去timeout的引用造成无限请求
        clearTimeout(this.refreshStatus);
        this.autoCheckOpen = false
      }
      const checkStatus = () => {
        let submitIds = this.needCheckSubmitIds
        api.checkSubmissonsStatus(Object.keys(submitIds)).then(
          (res) => {
            let result = res.data.data
            let viewData = this.$refs.xTable.getTableData().tableData;
            for(let key in submitIds){
              let submitId = parseInt(key);
              // 更新数据列表
              this.submissions[submitIds[key]] = result[submitId]
              // 更新view中的结果，耗时，空间消耗，判题机ip
              viewData[submitIds[key]].status = result[submitId].status
              viewData[submitIds[key]].time = result[submitId].time
              viewData[submitIds[key]].memory = result[submitId].memory
              viewData[submitIds[key]].judger = result[submitId].judger
              // 重新加载这行数据到view中
              this.$refs.xTable.reloadRow(viewData[submitIds[key]], null, null)

              if(result[submitId].status != JUDGE_STATUS_RESERVE['Pending']&&result[submitId].status != JUDGE_STATUS_RESERVE['Judging']){
                  delete this.needCheckSubmitIds[key]
              }
            }
            if(Object.keys(this.needCheckSubmitIds).length==0){
              clearTimeout(this.refreshStatus);
              this.autoCheckOpen = false
            }else{
               this.refreshStatus = setTimeout(checkStatus, 2000);
            }
          },
          (res) => {
            clearTimeout(this.refreshStatus);
            this.autoCheckOpen = false
          }
        );
      };
      // 设置每2秒检查一下提交结果
      this.refreshStatus = setTimeout(checkStatus, 2000);
      this.autoCheckOpen = true
    },

    // 改变route， 通过监听route变化请求数据，这样可以产生route history， 用户返回时就会保存之前的状态
    changeRoute() {
      let query = this.buildQuery();
      query.contestID = this.contestID;
      let queryParams = utils.filterEmptyValue(query);
        // 判断新路径请求参数与当前路径请求的参数是否一致，避免重复访问路由报错
      let equal = true
      for(let key in queryParams){
          if(queryParams[key] != this.$route.query[key]){
            equal = false
            break
          }
      }
      if(equal){ // 判断请求参数的长短
        if(Object.keys(queryParams).length!=Object.keys(this.$route.query).length){
          equal = false
        }
      }

      if(!equal){ // 避免重复同个路径请求导致报错
        let routeName = queryParams.contestID
          ? "contestSubmissionList"
          : "SubmissionList";
        this.$router.push({
          name: routeName,
          query: queryParams,
        });
      }
    },
    goRoute(route) {
      this.$router.push(route);
    },
    goUserHome(username,uid){
      this.$router.push({
        path: '/user-home',
        query: {uid,username},
      });
    },
    handleStatusChange(status) {
      if(status=='All'){
        this.formFilter.status = ''
      }else{
         this.formFilter.status = status;
      }
      this.currentPage = 1;
      this.changeRoute();
    },
    handleQueryChange() {
      this.currentPage = 1;
      this.changeRoute();
    },
    handleRejudge(row) {
      this.submissions[row.index].loading = true;
      api.submissionRejudge(row.submitId).then(
        (res) => {
          let xTable = this.$refs.xTable
          // 重判开始，需要将该提交的部分参数初始化
          row.status = res.data.data.status
          row.time = res.data.data.time
          row.memory = res.data.data.memory
          row.errorMessage = res.data.data.errorMessage
          row.judger = res.data.data.judger
          row.loading = false
          // 重新加载该行数据到view
          xTable.reloadRow(row, null, null)

          this.submissions[row.index] = res.data.data
          this.submissions[row.index].loading = false;
          myMessage.success(res.data.msg);

          // 加入待重判列表
          this.needCheckSubmitIds[row.submitId] = row.index
          if(!this.autoCheckOpen){ // 如果当前未开启自动检查提交状态的定时任务，则开启
            this.checkSubmissionsStatus();
          }
        },
        () => {
          this.submissions[row.index].loading = false;
        }
      );
    },
    handleOnlyMine(){
      if(this.formFilter.onlyMine){ // 需要判断是否为登陆状态
        if(this.isAuthenticated){
          this.formFilter.username = ''
        }else{
          this.formFilter.onlyMine = false
          myMessage.error("请您先登陆！")
          return;
        }
      }
      this.currentPage = 1;
      this.changeRoute();
    },
    ...mapActions(["changeModalStatus"]),

    showSubmitDetail(row) {
      if(!this.isAuthenticated){
        this.changeModalStatus({ mode: 'Login', visible: true })
        myMessage.warning("请先登录后再查看代码！")
        return;
      }
      this.$router.push({
        name:"SubmissionDeatil",
        params:{submitID:row.submitId}
      })
    },
    getProblemUri(pid) {
      return "/problem/" + pid;
    },
    getStatusColor(status) {
      return "el-tag el-tag--medium status-" + JUDGE_STATUS[status].color;
    },
    tableRowClassName({ row, rowIndex }) {
      if (row.username == this.userInfo.username && this.isAuthenticated) {
        return "own-submit-row";
      }
    },
  },
  computed: {
    ...mapGetters(["isAuthenticated", "userInfo","isSuperAdmin","isAdminRole"]),
    title() {
      if (!this.contestID) {
        return "Status";
      } else if (this.problemID) {
        return "Problem Submissions";
      } else {
        return "Submissions";
      }
    },
    status() {
      return this.formFilter.status === ""
        ? "Status"
        : JUDGE_STATUS[this.formFilter.status]?JUDGE_STATUS[this.formFilter.status].name:"Status";
    },
    rejudgeColumnVisible() {
      return !this.contestID && this.isSuperAdmin
    },
  },
  watch: {
    $route(newVal, oldVal) {
      if (newVal !== oldVal) {
        if(this.autoCheckOpen){
          clearInterval(this.refreshStatus);
        }
        this.init(); 
      }
    },
    isAuthenticated() {
      this.init();
    },
  },
  beforeRouteLeave(to, from, next) {
    // 防止切换组件后仍然不断请求
    clearInterval(this.refreshStatus);
    next();
  },
};
</script>

<style scoped >
@media only screen and (max-width: 767px) {
  .search {
    margin-top: 20px;
  }
}

.flex-container #main {
  flex: auto;
}
.flex-container .filter {
  margin-right: -10px;
}
.flex-container #contest-menu {
  flex: none;
  width: 210px;
}
/deep/ .el-card__header {
  border-bottom: 0px;
  padding-bottom: 0px;
  text-align: center;
}
/deep/ .el-button {
  padding: 0;
}
/deep/ .el-dialog {
  border-radius: 6px !important;
  text-align: center;
}
/deep/ .el-switch {
  padding-top: 6px;
}
@media only screen and (min-width: 768px) and (max-width: 992px){
  .el-col-sm-12 {
    padding-top: 10px;
  }
}
</style>