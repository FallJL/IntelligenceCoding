<template>
  <div>
    <div style="height: 50px"></div>
    <el-row :gutter="20">
      <el-col :span="12" :offset="6">
        <div style="margin-top: 15px">
          <el-input
            placeholder="搜索代码"
            v-model="query.content"
            class="input-with-select"
          >
            <el-select v-model="query.languageType" slot="prepend">
              <el-option label="C" value="1"></el-option>
              <el-option label="C++" value="2"></el-option>
              <el-option label="Java" value="3"></el-option>
              <el-option label="Python3" value="4"></el-option>
              <el-option label="Python2" value="5"></el-option>
            </el-select>
            <el-button
              @click="getCodeSearchList"
              :loading="loadings.searchLoading"
              slot="append"
              icon="el-icon-search"
            ></el-button>
          </el-input>
        </div>
      </el-col>
    </el-row>
    <div v-show="!isShow" style="height: 500px"></div>
    <div v-show="isShow">
      <el-row :gutter="20"></el-row>
      <el-row :gutter="20"
        ><el-col :span="12" :offset="6">No.1:</el-col></el-row
      >
      <el-row :gutter="20">
        <el-col :span="12" :offset="6">
          <CodeMirror
            :value.sync="searchedAllCode[0]"
            :language.sync="language"
            :theme.sync="theme"
            @resetCode="onResetToTemplate"
            @changeTheme="onChangeTheme"
            @changeLang="onChangeLang"
          ></CodeMirror>
        </el-col>
      </el-row>
      <el-row :gutter="20"
        ><el-col :span="12" :offset="6">No.2:</el-col></el-row
      >
      <el-row :gutter="20">
        <el-col :span="12" :offset="6">
          <CodeMirror
            :value.sync="searchedAllCode[1]"
            :language.sync="language"
            :theme.sync="theme"
            @resetCode="onResetToTemplate"
            @changeTheme="onChangeTheme"
            @changeLang="onChangeLang"
          ></CodeMirror>
        </el-col>
      </el-row>
      <el-row :gutter="20"
        ><el-col :span="12" :offset="6">No.3:</el-col></el-row
      >
      <el-row :gutter="20">
        <el-col :span="12" :offset="6">
          <CodeMirror
            :value.sync="searchedAllCode[2]"
            :language.sync="language"
            :theme.sync="theme"
            @resetCode="onResetToTemplate"
            @changeTheme="onChangeTheme"
            @changeLang="onChangeLang"
          ></CodeMirror>
        </el-col>
      </el-row>
      <el-row :gutter="20"
        ><el-col :span="12" :offset="6">No.4:</el-col></el-row
      >
      <el-row :gutter="20">
        <el-col :span="12" :offset="6">
          <CodeMirror
            :value.sync="searchedAllCode[3]"
            :language.sync="language"
            :theme.sync="theme"
            @resetCode="onResetToTemplate"
            @changeTheme="onChangeTheme"
            @changeLang="onChangeLang"
          ></CodeMirror>
        </el-col>
      </el-row>
      <el-row :gutter="20"
        ><el-col :span="12" :offset="6">No.5:</el-col></el-row
      >
      <el-row :gutter="20">
        <el-col :span="12" :offset="6">
          <CodeMirror
            :value.sync="searchedAllCode[4]"
            :language.sync="language"
            :theme.sync="theme"
            @resetCode="onResetToTemplate"
            @changeTheme="onChangeTheme"
            @changeLang="onChangeLang"
          ></CodeMirror>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import api from "@/common/api";
import "element-ui/lib/theme-chalk/display.css";
const CodeMirror = () => import("@/components/oj/common/CodeMirror.vue");
export default {
  name: "CodeSearch",
  components: {
    CodeMirror,
  },
  data() {
    return {
      query: {
        languageType: "4",
        content: "",
      },
      loadings: {
        searchLoading: false,
      },
      searchedAllCode: [],
      isShow: false,
      theme: "solarized",
      language: "Python3",
    };
  },
  methods: {
    getCodeSearchList() {
      let queryParams = Object.assign({}, this.query); // 包装查询数据
      console.log("queryParams:", queryParams);
      this.loadings.searchLoading = true; // 设置为正在加载
      api.getCodeSearchList(this.limit, queryParams).then(
        (res) => {
          console.log("res:", res);
          // this.total = res.data.data.total;
          // this.codeSearchList = res.data.data.records;
          this.searchedAllCode = res.data.code;
          this.isShow = true;
          this.loadings.searchLoading = false; // 加载完毕
        },
        (res) => {
          this.loadings.searchLoading = false; // 加载完毕
        }
      );
    },
    onChangeLang(newLang) {
      this.language = newLang;
    },
    onChangeTheme(newTheme) {
      this.theme = newTheme;
    },
    onResetToTemplate() {
      this.$confirm(
        this.$i18n.t("m.Are_you_sure_you_want_to_reset_your_code"),
        "Tips",
        {
          cancelButtonText: this.$i18n.t("m.Cancel"),
          confirmButtonText: this.$i18n.t("m.OK"),
          type: "warning",
        }
      )
        .then(() => {
          this.searchedAllCode = [];
        })
        .catch(() => {});
    },
  },
};
</script>

<style>
.el-row {
  margin-bottom: 20px;
  &:last-child {
    margin-bottom: 0;
  }
}

.el-col {
  border-radius: 4px;
}

.el-select .el-input {
  width: 130px;
}

.input-with-select .el-input-group__prepend {
  background-color: #fff;
}
</style>
