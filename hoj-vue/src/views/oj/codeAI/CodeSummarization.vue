<template>
    <div>
        <el-col :sm="24" :md="24" :lg="12" class="code">
            <el-card
                    :padding="10"
                    id="code"
                    shadow="always"
                    class="detail">
                <CodeMirror
                        :value.sync="code"
                        :language.sync="language"
                        :theme.sync="theme"
                        @resetCode="onResetToTemplate"
                        @changeTheme="onChangeTheme"
                        @changeLang="onChangeLang"
                ></CodeMirror>
            </el-card>
        </el-col>

        <el-col :sm="24" :md="24" :lg="12" class="summarization">
            <el-card
                    :padding="10"
                    id="summarization"
                    shadow="always"
                    class="summarization">
                <div style="margin-top: 1px">
                    <el-button style="margin-bottom: 10px" type="primary" icon="el-icon-edit"  @click="submit">
                        {{ $t('m.NavBar_CodeSummarization') }}
                    </el-button>
                    <el-input  type="textarea"
                               :rows="28"
                               v-model="msg" disabled="true"
                               style="min-height: 33px; height: 610px;">
                    </el-input>
                </div>
            </el-card>
        </el-col>

        <div style="font-size: 14px;" :visible.sync="optVisible">
            <iframe width="1" height="1" frameborder="0"
                    :src=optUrl>
            </iframe>
        </div>
    </div>

</template>

<script>
import myMessage from '@/common/message';
const CodeMirror = () => import('@/components/oj/common/CodeMirror.vue');
const CommentedCodeMirror = () => import('@/components/oj/common/CommentedCodeMirror.vue');
export default {
        components: {
            CodeMirror,
            CommentedCodeMirror,
        },
        data() {
            return {
                code:'',
                language:'C',
                theme:'solarized',
                formInline: {
                    user: '',
                    region: ''
                },
                optVisible:'',
                optUrl:'',
                msg:'这是代码注释！！！'
            }
        },
        mounted(){
            //根据上传文件自动获取代码语言类型，全局总线数据来自codeMirror
            this.$bus.$on('getLanguage',(data)=>{
                this.language=data
            })
        },
        methods: {
            submit(){
                console.log(this.code.length)
                if (this.code.length === 0) {
                    this.$confirm(
                        this.$i18n.t('m.Code_can_not_be_empty'),
                        'Tips',
                        {
                            cancelButtonText: this.$i18n.t('m.Cancel'),
                            confirmButtonText: this.$i18n.t('m.OK'),
                            type: 'warning',
                        })
                }
                if (this.code.length > 65535) {
                    this.$confirm(
                        this.$i18n.t('m.Code_Length_can_not_exceed_65535'),
                        'Tips',
                        {
                            cancelButtonText: this.$i18n.t('m.Cancel'),
                            confirmButtonText: this.$i18n.t('m.OK'),
                            type: 'warning',
                        })
                }
                if(this.code.length>0 &&this.code.length<65535){
                    this.$confirm(
                        this.$i18n.t('m.Are_you_sure_you_want_to_generate_comments'),
                        'Tips',
                        {
                            cancelButtonText: this.$i18n.t('m.Cancel'),
                            confirmButtonText: this.$i18n.t('m.OK'),
                            type: 'warning',
                        }
                    )
                    // this.code=JSON.stringify(this.code)
                    axios({
                        method:'post',
                        url:'http://localhost:8088/python/unixcoder',
                        data:{
                            code:this.code,
                            language:this.language
                        }
                    }).then(
                        response=> {
                            console.log("成功",response.data)
                            console.log(this.language)
                            this.msg = response.data
                        },
                        error => {
                            console.log("失败",error.message)
                        }
                    )
                }
            },
            // onSubmit() {
            //     console.log('submit!');
            // },
            onChangeLang(newLang){
                this.code='';
                this.language = newLang;
            },
            onChangeTheme(newTheme) {
                this.theme = newTheme;
            },
            onResetToTemplate() {
                this.$confirm(
                    this.$i18n.t('m.Are_you_sure_you_want_to_reset_your_code'),
                    'Tips',
                    {
                        cancelButtonText: this.$i18n.t('m.Cancel'),
                        confirmButtonText: this.$i18n.t('m.OK'),
                        type: 'warning',
                    }
                )
                    .then(() => {
                        this.code = '';
                    })
                    .catch(() => {});
            }
        }
}
</script>

<style scoped>
    .container {
        margin-bottom: 20px;
    }
    .container .content {
        font-size: 16px;
        margin: 0 50px 20px 50px;
    }
    .container .content pre {
        padding: 5px 10px;
        white-space: pre-wrap;
        margin-top: 15px;
        margin-bottom: 15px;
        background: #f8f8f9;
        border: 1px dashed #e9eaec;
    }
    @media screen and (max-width: 768px) {
        .container .content {
            font-size: 1rem;
            margin: 0 5px;
        }
    }
    ul {
        list-style: disc;
        padding-inline-start: 0px;
    }
    li {
        line-height: 2;
    }
    li .title {
        font-weight: 600;
        font-size: 1rem;
    }
    .result li {
        list-style-type: none;
        margin-top: 8px;
    }
</style>
