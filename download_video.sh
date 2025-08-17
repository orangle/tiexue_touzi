#!/bin/bash

# 多媒体下载和转换脚本
# 用法: ./download_video.sh <url> [output_name]
# 支持m3u8视频链接和m4a音频链接，最终输出都是mp3格式

# 检查是否安装了ffmpeg
if ! command -v ffmpeg &> /dev/null
then
    echo "错误: 未找到ffmpeg，请先安装ffmpeg"
    exit 1
fi

# 检查参数
if [ $# -eq 0 ]
then
    echo "用法: $0 <url> [output_name]"
    echo "示例: $0 \"https://example.com/video.m3u8\" \"my_video\""
    echo "示例: $0 \"https://example.com/audio.m4a\" \"my_audio\""
    exit 1
fi

MEDIA_URL="$1"
OUTPUT_NAME="${2:-media}"

# 识别URL类型
if [[ "$MEDIA_URL" == *.m3u8* ]] || [[ "$MEDIA_URL" == *".m3u8"?* ]]
then
    MEDIA_TYPE="m3u8"
    echo "检测到m3u8视频链接"
elif [[ "$MEDIA_URL" == *.m4a* ]] || [[ "$MEDIA_URL" == *".m4a"?* ]]
then
    MEDIA_TYPE="m4a"
    echo "检测到m4a音频链接"
else
    echo "错误: 不支持的链接类型，请提供m3u8视频链接或m4a音频链接"
    exit 1
fi

# 根据链接类型处理
if [ "$MEDIA_TYPE" == "m3u8" ]
then
    # 下载m3u8视频并转换为mp3
    echo "正在下载视频..."
    ffmpeg -i "$MEDIA_URL" -c copy "${OUTPUT_NAME}.mp4"
    
    # 提取音频为mp3
    echo "正在提取音频为mp3格式..."
    ffmpeg -i "${OUTPUT_NAME}.mp4" -vn -acodec mp3 "${OUTPUT_NAME}.mp3"
    
    # 删除临时视频文件
    rm "${OUTPUT_NAME}.mp4"
    
    echo "下载完成！"
    echo "音频文件: ${OUTPUT_NAME}.mp3"
elif [ "$MEDIA_TYPE" == "m4a" ]
then
    # 直接下载m4a并转换为mp3
    echo "正在下载并转换音频为mp3格式..."
    ffmpeg -i "$MEDIA_URL" -acodec mp3 "${OUTPUT_NAME}.mp3"
    
    echo "下载完成！"
    echo "音频文件: ${OUTPUT_NAME}.mp3"
fi