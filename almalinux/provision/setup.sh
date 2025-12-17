#!/bin/bash

# Отключение SELinux (Required for many lab scenarios like K8s/Docker)
/usr/bin/sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Обновление пакетов и установка минимальных утилит
/usr/bin/dnf -y update
/usr/bin/dnf install -y wget net-tools curl vim

# Отключение Firewalld (для упрощения лабораторной работы)
/usr/bin/systemctl stop firewalld
/usr/bin/systemctl disable firewalld

# Установка часового пояса (например, Москва)
/usr/bin/timedatectl set-timezone Europe/Moscow