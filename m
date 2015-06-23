From: Roberto Spadim <roberto@spadim.com.br>
Subject: doubt about raid1 and writemostly
Date: Tue, 23 Jun 2015 12:01:33 -0300
Message-ID: <CAH3kUhEdDY2DeAQ1FYaEvsRRdia9kn6V+9VQETxVdh9j-R3TTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i'm with a doubt
when i use witemostly, how the md handle the slower drive
(writemostly) for example i have 2 ssd that support 500mb/s write
running raid1, i included a hdd with +- 100mb/s write with writemostly
flag
when i execute a dd if=/dev/zero of=./test , i get near to 200mb/s
with dd, and using iostat -d 1 -k, i get +- 100mb/s
there's some kind of configuration to writemostly drive? something
like 'buffer size' or someting like it?

-- 
Roberto Spadim
