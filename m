From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Mon, 11 May 2020 08:40:22 +0200
Message-ID: <20200511064022.591C5240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Guoqing Jiang,

In message <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> you wrote:
>
> Seems raid6check is in 'D' state, what are the output of 'cat 
> /proc/19719/stack' and /proc/mdstat?

# for i in 1 2 3 4 ; do  cat /proc/19719/stack; sleep 2; echo ; done
[<0>] __wait_rcu_gp+0x10d/0x110
[<0>] synchronize_rcu+0x47/0x50
[<0>] mddev_suspend+0x4a/0x140
[<0>] suspend_lo_store+0x50/0xa0
[<0>] md_attr_store+0x86/0xe0
[<0>] kernfs_fop_write+0xce/0x1b0
[<0>] vfs_write+0xb6/0x1a0
[<0>] ksys_write+0x4f/0xc0
[<0>] do_syscall_64+0x5b/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

[<0>] __wait_rcu_gp+0x10d/0x110
[<0>] synchronize_rcu+0x47/0x50
[<0>] mddev_suspend+0x4a/0x140
[<0>] suspend_lo_store+0x50/0xa0
[<0>] md_attr_store+0x86/0xe0
[<0>] kernfs_fop_write+0xce/0x1b0
[<0>] vfs_write+0xb6/0x1a0
[<0>] ksys_write+0x4f/0xc0
[<0>] do_syscall_64+0x5b/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

[<0>] __wait_rcu_gp+0x10d/0x110
[<0>] synchronize_rcu+0x47/0x50
[<0>] mddev_suspend+0x4a/0x140
[<0>] suspend_hi_store+0x44/0x90
[<0>] md_attr_store+0x86/0xe0
[<0>] kernfs_fop_write+0xce/0x1b0
[<0>] vfs_write+0xb6/0x1a0
[<0>] ksys_write+0x4f/0xc0
[<0>] do_syscall_64+0x5b/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

[<0>] __wait_rcu_gp+0x10d/0x110
[<0>] synchronize_rcu+0x47/0x50
[<0>] mddev_suspend+0x4a/0x140
[<0>] suspend_hi_store+0x44/0x90
[<0>] md_attr_store+0x86/0xe0
[<0>] kernfs_fop_write+0xce/0x1b0
[<0>] vfs_write+0xb6/0x1a0
[<0>] ksys_write+0x4f/0xc0
[<0>] do_syscall_64+0x5b/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Interesting, why is it in ksys_write / vfs_write / kernfs_fop_write
all the time?  I thought it was _reading_ the disks only?

And iostat does not report any writes either?

# iostat /dev/sd[efhijklm] | cat
Linux 5.6.8-300.fc32.x86_64 (atlas.denx.de)     2020-05-11      _x86_64_        (8 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.18    0.00    1.07    0.17    0.00   98.58

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
sde              20.30       368.76         0.10         0.00  277022327      75178          0
sdf              20.28       368.77         0.10         0.00  277030081      75170          0
sdh              20.30       368.74         0.10         0.00  277007903      74854          0
sdi              20.30       368.79         0.10         0.00  277049113      75246          0
sdj              20.82       368.76         0.10         0.00  277022363      74986          0
sdk              20.30       368.73         0.10         0.00  277002179      76322          0
sdl              20.29       368.78         0.10         0.00  277039743      74982          0
sdm              20.29       368.75         0.10         0.00  277018163      74958          0


# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid10 sdc1[0] sdd1[1]
      234878976 blocks 512K chunks 2 far-copies [2/2] [UU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md0 : active raid6 sdm[15] sdl[14] sdi[8] sde[12] sdj[9] sdk[10] sdh[13] sdf[11]
      11720301024 blocks super 1.2 level 6, 16k chunk, algorithm 2 [8/8] [UUUUUUUU]

md1 : active raid1 sdb3[0] sda3[1]
      484118656 blocks [2/2] [UU]

md2 : active raid1 sdb1[0] sda1[1]
      255936 blocks [2/2] [UU]

unused devices: <none>

> > 3 days later:
>
> Is raid6check still in 'D' state as before?

Yes, nothing changed, still running:

top - 08:39:30 up 8 days, 16:41,  3 users,  load average: 1.00, 1.00, 1.00
Tasks: 243 total,   1 running, 242 sleeping,   0 stopped,   0 zombie
%Cpu0  :  0.0 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.3 hi,  0.0 si,  0.0 st
%Cpu1  :  1.0 us,  5.4 sy,  0.0 ni, 92.2 id,  0.7 wa,  0.3 hi,  0.3 si,  0.0 st
%Cpu2  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu4  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu5  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu6  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  24034.6 total,  10920.6 free,   1883.0 used,  11231.1 buff/cache
MiB Swap:   7828.5 total,   7828.5 free,      0.0 used.  21756.5 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
  19719 root      20   0    2852   2820   2020 D   7.6   0.0 679:04.39 raid6check
   1123 root      20   0       0      0      0 S   0.7   0.0  60:55.64 md0_raid6
     10 root      20   0       0      0      0 I   0.3   0.0   9:09.26 rcu_sched
    655 root       0 -20       0      0      0 I   0.3   0.0  21:28.95 kworker/1:1H-kblockd
  60161 root      20   0       0      0      0 I   0.3   0.0   0:01.18 kworker/6:1-events
  61997 root      20   0       0      0      0 I   0.3   0.0   0:01.48 kworker/1:3-events
...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Every program has at least one bug and can be shortened by  at  least
one  instruction  --  from  which,  by induction, one can deduce that
every program can be reduced to one instruction which doesn't work.
