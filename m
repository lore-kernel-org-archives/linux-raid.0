From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: SSSE6 / RAID6
Date: Tue, 22 May 2012 22:27:42 +0100
Message-ID: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

I just compiled 3.4 for my little Atom box. Is there any way I can
confirm if the RAID6 check is using SSSE6 instructions?

$ zcat /proc/config.gz |grep -i -P '(raid|sss)'
CONFIG_RAID_ATTRS=y
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_DM_RAID=m
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_RAID6_PQ=y

 $ cat /proc/cpuinfo  |grep ssse
flags		: fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts nopl aperfmperf pni dtes64 monitor
ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdf1[5] sdh1[8] sdg1[0] sde1[7] sdc1[3] sdd1[4] sdb1[9]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/7] [UUUUUUU]
      [>....................]  check =  0.7% (15577860/1950351360)
finish=1918.9min speed=16804K/sec

unused devices: <none>

$ ps aux |grep -i -P '(md|raid)'
root        27  0.0  0.0      0     0 ?        S<   21:52   0:00 [md]
root       342 15.5  0.0      0     0 ?        R    21:52   5:23 [md0_raid6]
root      3937 65.2  0.0      0     0 ?        R    22:13   9:11 [md0_resync]

Thanks,
Mathias
