From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: mdadm 3.3.2 deadlock
Date: Thu, 25 Feb 2016 10:23:25 +0300
Message-ID: <CACaajQv=n4aOMfMwNrDM8_M8NeoYyxC0XejpxqZVxvivvjygJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi. I have strange deadlocked process of mdadm
root     14495  0.0  0.0  13064  1964 ?        D    Feb24   0:00
/sbin/mdadm --detail --export /dev/.tmp-block-259:5

why this is can happen and does mdadm git repo already have fix for this?
Thanks!

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
