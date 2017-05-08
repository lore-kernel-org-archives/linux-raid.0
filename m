From: Vladimir Fedorkov <vlad@astellar.com>
Subject: MD device tinning documentation
Date: Mon, 8 May 2017 13:22:53 +0300
Message-ID: <CA+DJSLwbsUhhK_T+K6YOBX_BLdgRn=qZjz3LUAK92A0_9sL0FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there!

I'm running benchmarks and it looks like that md device is only
utilizing single core which it limiting it's performance on concurrent
(4+ threads) writes with 8 SSD drives in software RAID10

Kernel: Linux host 4.10.12-1.el7.elrepo.x86_64 #1 SMP Fri Apr 21
09:58:15 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux

Exact numbers are here: http://astellar.com/images/sysbench_rnd_writes.png

Could you please let me know if there is multi-threaded support on MD
devices in 4.x kernels and point me to the documentation (preferred)
or source code which describes tunable parts of /dev/mdXX devices.

Much appreciated!

Thank you!
---
Vlad
