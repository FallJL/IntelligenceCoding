<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="12" :offset="6">
        <div style="margin-top: 15px">
          <el-input
            placeholder="搜索代码"
            v-model="query.content"
            class="input-with-select"
          >
            <el-select
              v-model="query.languageType"
              slot="prepend"
            >
              <el-option label="C" value="1"></el-option>
              <el-option label="C++" value="2"></el-option>
              <el-option label="Java" value="3"></el-option>
              <el-option label="Python3" value="4"></el-option>
              <el-option label="Python2" value="5"></el-option>
            </el-select>
            <el-button @click="searchCodeList" slot="append" icon="el-icon-search"></el-button>
          </el-input>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import api from "@/common/api";
import "element-ui/lib/theme-chalk/display.css";
import Pagination from "@/components/oj/common/Pagination";
const Editor = () => import("@/components/admin/Editor.vue");
export default {
  name:'CodeSearch',
  components: {
    Editor,
    Pagination,
  },
  data() {
    return {
      total: 0,
      query: {
        languageType: "4",
        content: "",
        keyword: "",
        cid: "",
        currentPage: 1,
        limit: 10,
        pid: "",
        onlyMine: false,
      },
      loading: {
        searchLoading: false,
      },
    };
  },
  // created() {
  //   let query = this.$route.query;
  //   // 必须在这里先获取当前页码，不然分页组件的显示有误
  //   this.query.currentPage = parseInt(query.currentPage) || 1;
  //   if (this.query.currentPage < 1) {
  //     this.query.currentPage = 1;
  //   }
  // },
  // mounted() {
  //   // this.discussionDialogTitle = this.$i18n.t('m.Edit_Discussion');
  //   this.loading.category = true;
  //   api.getCategoryList().then(
  //     (res) => {
  //       this.categoryList = res.data.data;
  //       for (let i = 0; i < this.categoryList.length; i++) {
  //         this.cidMapName[this.categoryList[i].id] = this.categoryList[i].name;
  //       }
  //       this.loading.category = false;
  //       this.init();
  //     },
  //     (err) => {
  //       this.loading.category = false;
  //     }
  //   );
  // },
  methods: {
    ...mapActions(['changeDomTitle']),
    init() {
      this.routeName = this.$route.name;
      let query = this.$route.query;
      this.query.keyword = query.keyword || '';
      this.query.cid = query.cid || '';
      this.query.pid = this.$route.params.problemID || '';
      this.query.onlyMine = query.onlyMine + '' == 'true' ? true : false; // 统一换成字符串判断
      if (this.query.cid) {
        this.currentCategory = this.cidMapName[this.query.cid];
      } else {
        this.currentCategory = '';
      }
      if (this.query.pid) {
        this.discussion.pid = this.query.pid;
        this.changeDomTitle({ title: this.query.pid + ' Discussion' });
      } else {
        this.discussion.pid = null;
      }
      this.getDiscussionList();
    },

    getCodeSearchList() {
      this.loading.searchLoading = true;
      api.getCodeSearchList(this.query.limit, queryParams).then(
        (res) => {
          console.info(res)
          this.loading.searchLoading = false;
        },
        (err) => {
          this.loading.searchLoading = false;
        }
      )
    },

    getDiscussionList() {
      let queryParams = Object.assign({}, this.query);
      this.loading.discussion = true;
      api.getDiscussionList(this.query.limit, queryParams).then(
        (res) => {
          this.total = res.data.data.total;
          this.discussionList = res.data.data.records;
          this.loading.discussion = false;
        },
        (err) => {
          this.loading.discussion = false;
        }
      );
    },

    changeRoute(page) {
      this.query.currentPage = page;
      this.pushRouter(
        this.query,
        { problemID: this.query.pid },
        this.routeName
      );
    },

    getInfoByUsername(uid, username) {
      this.$router.push({
        path: '/user-home',
        query: { uid, username },
      });
    },

    toEditDiscussion() {
      if (!this.isAuthenticated) {
        myMessage.warning(this.$i18n.t('m.Please_login_first'));
        this.$store.dispatch('changeModalStatus', { visible: true });
      } else {
        this.discussionDialogTitle = this.$i18n.t('m.Create_Discussion');
        if (this.backupDiscussion) {
          this.discussion = this.backupDiscussion;
          // 避免监听覆盖
          this.discussion.pid = this.query.pid || null;
        } else {
          this.discussion = {
            id: null,
            pid: this.query.pid || null,
            title: '',
            content: '',
            description: '',
            categoryId: '',
            topPriority: false,
            uid: '',
            author: '',
            avatar: '',
          };
        }
        this.showEditDiscussionDialog = true;
      }
    },

    handleQueryChange() {
      this.pushRouter(
        this.query,
        { problemID: this.query.pid },
        this.routeName
      );
    },
    toDiscussionDetail(discussionID) {
      this.$router.push({
        name: 'DiscussionDetails',
        params: { discussionID: discussionID },
      });
    },

    toAllDiscussion() {
      this.$router.push({
        path: '/discussion',
      });
    },

    toOnlyMyDiscussion(onlyMine) {
      this.$router.push({
        path: this.$route.path,
        query: {
          onlyMine: onlyMine,
        },
      });
    },

    pushRouter(query, params, name) {
      this.$router.push({
        name: name,
        query: query,
        params: params,
      });
    },

    // 打开编辑对话框的回调
    onOpenEditDialog() {
      // todo 优化
      // 暂时解决 文本编辑器显示异常bug
      setTimeout(() => {
        if (document.createEvent) {
          let event = document.createEvent('HTMLEvents');
          event.initEvent('resize', true, true);
          window.dispatchEvent(event);
        } else if (document.createEventObject) {
          window.fireEvent('onresize');
        }
      }, 0);
    },

    submitDiscussion() {
      // 默认为题目的讨论添加题号格式
      let discussion = Object.assign({}, this.discussion);
      if (this.discussionDialogTitle == this.$i18n.t('m.Create_Discussion')) {
        if (discussion.pid) {
          discussion.title = '[' + discussion.pid + '] ' + discussion.title;
        }
        api.addDiscussion(discussion).then((res) => {
          myMessage.success(this.$i18n.t('m.Post_successfully'));
          this.showEditDiscussionDialog = false;
          this.init();
        });
      } else {
        api.updateDiscussion(discussion).then((res) => {
          myMessage.success(this.$i18n.t('m.Update_Successfully'));
          this.showEditDiscussionDialog = false;
          this.init();
        });
      }
    },
    handleCommand(command) {
      let tmpArr = command.split(':');
      switch (tmpArr[0]) {
        case 'edit':
          this.discussionDialogTitle = this.$i18n.t('m.Edit_Discussion');
          this.discussion = Object.assign(
            {},
            this.discussionList[parseInt(tmpArr[1])]
          );
          this.showEditDiscussionDialog = true;
          break;
        case 'delete':
          this.$confirm(this.$i18n.t('m.Delete_Discussion_Tips'), 'Tips', {
            confirmButtonText: this.$i18n.t('m.OK'),
            cancelButtonText: this.$i18n.t('m.Cancel'),
            type: 'warning',
          }).then(() => {
            api
              .deleteDiscussion(this.discussionList[parseInt(tmpArr[1])].id)
              .then((res) => {
                myMessage.success(this.$i18n.t('m.Delete_successfully'));
                this.init();
              });
          });
          break;
      }
    },
  },

  // watch: {
  //   $route(newVal, oldVal) {
  //     if (newVal != oldVal) {
  //       this.init();
  //     }
  //   },
  //   discussion(newVal, oldVal) {
  //     if (
  //       this.discussionDialogTitle == this.$i18n.t('m.Create_Discussion') &&
  //       newVal != oldVal
  //     ) {
  //       this.backupDiscussion = this.discussion;
  //     }
  //   },
  // },

  // computed: {
  //   ...mapGetters(['isAuthenticated', 'userInfo', 'isAdminRole']),
  // },
};
</script>

<style>
.el-select .el-input {
  width: 130px;
}

.input-with-select .el-input-group__prepend {
  background-color: #fff;
}

.role-root {
  background-color: #f9d681 !important;
  color: #ff503f !important;
  font-weight: 600;
}

.role-admin {
  background-color: #409eff !important;
  color: #fff !important;
}

.role {
  display: inline-block;
  font-size: 0.75rem;
  padding: 0.1875rem 0.25rem;
  line-height: 1;
}
</style>
<style scoped>
/deep/ .el-card__body {
  padding: 0 !important;
}
.discussion-header {
  background-color: #fff;
  border-radius: 6px;
  overflow: hidden;
  margin-bottom: 10px;
  height: 41px;
}
.discussion-header .search {
  margin-top: 3px;
  margin-right: 6px;
  float: right;
}
.list-card {
  border-radius: 6px;
  margin-bottom: 10px;
  padding: 15px;
  text-align: left;
  position: relative;
}
.list-card p {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.list-card .article-hlink {
  overflow: hidden;
  display: block;
}
.svg-top {
  position: absolute;
  top: 0px;
  right: 0px;
}
.article-hlink {
  margin: 0;
  padding: 0;
}
.article-hlink a {
  font-size: 16px;
  font-weight: 600;
  color: #34495e;
  margin-top: 5px;
}
a {
  color: #34495e;
  text-decoration: none;
}

.article-hlink2 p {
  margin-bottom: 10px;
  color: #888;
  font-size: 12px;
  margin: 0;
  padding: 0;
}
.title-article .title-msg {
  margin-top: 15px;
  font-size: 12px;
  color: #999 !important;
}
.title-article .title-msg a {
  color: #999;
  text-decoration: none;
}
.user-avatar {
  vertical-align: middle;
}

.title-article .title-msg span {
  margin-right: 3px;
}
.title-article .title-msg .pl {
  padding-left: 0.3rem !important;
}
.title-article .title-msg .pr {
  padding-right: 0.3rem !important;
}

.category-body {
  background: #fff;
  padding: 15px;
  margin-bottom: 15px;
  border-radius: 6px;
  overflow: hidden;
  margin-top: 12px;
}
.category-body .title-sidebar {
  border-bottom: 1px solid #eee;
  width: 100%;
  color: #34495e;
  font-size: 14px;
  font-weight: 600;
  padding-bottom: 10px;
  margin-bottom: 10px;
  overflow: hidden;
}
.category-body .title-sideba a {
  color: #34495e;
}
.category-body h3 {
  margin: 0;
  padding: 0;
}
.category-item {
  height: 30px;
  font-size: 14px;
  padding: 3px 10px;
  margin-bottom: 5px;
}
.category-item a {
  color: #34495e;
}
.category-item:hover {
  background-color: #eff3f5 !important;
  font-weight: bold;
  color: #222;
}
</style>
  