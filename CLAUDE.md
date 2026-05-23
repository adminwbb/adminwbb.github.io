# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概述

这是一个 Hugo 博客，使用 GitHub Actions 部署到 GitHub Pages。主题为 Stack，支持中英文双语。

## 常用命令

```bash
# 本地预览
hugo server

# 构建生产版本
hugo --minify

# 新建文章（需手动复制到 content/post/）
hugo new post/文件名.md
```

## 项目结构

- `config.toml` - Hugo 配置（双语支持、评论区、侧边栏等）
- `content/post/` - 博客文章目录
- `themes/stack/` - Stack 主题（git submodule）
- `scripts/rename_by_title.py` - 按文章标题重命名文件的脚本

## GitHub Actions 工作流

### deploy.yml
- 触发条件：master 分支 push
- 构建命令：`hugo --enableGitInfo --minify`
- 部署到 GitHub Pages

### format-markdown.yml
- 触发条件：任何分支的 `.md` 文件变更
- 自动：
  1. 重命名文件为标题
  2. 用 Prettier 格式化 Markdown
- 跳过条件：`github.actor != 'github-actions[bot]'`（防止无限循环）

## 部署说明

- 仓库为 adminwbb/adminwbb.github.io 的 fork
- 本地为 sdttttt/adminwbb.github.io
- PR 需提交到 upstream (adminwbb/adminwbb.github.io)
- GitHub Actions 修改需要手动合并（OAuth App 权限限制）

## 注意事项

- 文章文件名已改为中文标题（如 `上班上班.md`）
- 新建文章后需手动移动到 `content/post/` 目录