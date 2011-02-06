From: Roberto Spadim <roberto@spadim.com.br>
Subject: raid1 sector size
Date: Sun, 6 Feb 2011 14:19:18 -0200
Message-ID: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, there's a way to increase sector size?
instead of 512bytes use 4096bytes?

check:
md0: 512bytes
sda: 4096bytes
sdb: 4096bytes

i want a 512bytes at md0
why? i'm trying to reduce IOPS (more bytes to read = less io / second)
and maybe increase read rate

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
