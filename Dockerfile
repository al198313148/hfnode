FROM alpine:latest

# Устанавливаем xray для работы VLESS
RUN apk add --no-cache curl unzip \
    && curl -L -H "Cache-Control: no-cache" -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/xray \
    && rm -rf /tmp/*

# Записываем конфигурацию сервера (порт 7860 обязателен для Hugging Face)
RUN echo '{\
  "inbounds": [{ \
    "port": 7860, \
    "protocol": "vless", \
    "settings": { \
      "clients": [{"id": "7786e948-c97d-4e32-9a56-e2184b938302"}], \
      "decryption": "none" \
    }, \
    "streamSettings": { \
      "network": "ws", \
      "wsSettings": {"path": "/"} \
    } \
  }], \
  "outbounds": [{"protocol": "freedom"}] \
}' > /usr/local/bin/config.json

EXPOSE 7860

CMD ["/usr/local/bin/xray", "-config", "/usr/local/bin/config.json"]