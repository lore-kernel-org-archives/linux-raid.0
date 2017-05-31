From: CoolCold <coolthecold@gmail.com>
Subject: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 19:20:10 +0700
Message-ID: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
Got a new box, for image storage, playing around, created raid10 array
with 20 1.8TB SATA drives, and found that we hit the cpu limit,
details below.

Creation (disable write intent bitmap, with bitmap all is much worse):
mdadm --create -c 64 -b none -n 20 -l 10 /dev/md1 /dev/sde /dev/sdf
/dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm
/dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt
/dev/sdu /dev/sdv /dev/sdw /dev/sdx

/proc/mdstat output:
[root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
      17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
[UUUUUUUUUUUUUUUUUUUU]
      [=>...................]  resync =  6.4% (1133170368/17580330880)
finish=192.6min speed=1423140K/sec

top stat:
top - 12:09:03 up  4:55,  2 users,  load average: 3.33, 3.18, 2.88
Tasks: 487 total,   4 running, 483 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  4.5 sy,  0.0 ni, 95.3 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem : 13174918+total, 13005539+free,  1191212 used,   502584 buff/cache
KiB Swap:  9764860 total,  9764860 free,        0 used. 13020440+avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
22275 root      20   0       0      0      0 R  99.0  0.0   7:01.01 md1_raid10

this cpu usage 99-100% is constant.

iostat shows drives have much more potential:
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdi               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.48    0.24    0.24    0.00   0.13  27.00
sdf               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.38    0.19    0.19    0.00   0.12  24.76
sds               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.26    0.13    0.13    0.00   0.13  25.76
sde               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.35    0.17    0.17    0.00   0.12  24.08
sdh               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.31    0.15    0.15    0.00   0.14  29.32
sdj               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.35    0.17    0.17    0.00   0.13  26.46
sdt               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.31    0.15    0.15    0.00   0.13  26.36
sdn               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.56    0.28    0.28    0.00   0.14  28.40
sdq               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.60    0.29    0.29    0.00   0.13  26.28
sdl               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.43    0.21    0.21    0.00   0.15  29.94
sdm               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.31    0.15    0.15    0.00   0.13  26.02
sdk               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.33    0.16    0.16    0.00   0.14  28.74
sdv               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.38    0.19    0.19    0.00   0.11  23.32
sdo               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.48    0.24    0.24    0.00   0.15  29.80
sdr               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.34    0.16    0.16    0.00   0.12  25.10
sdg               0.00     0.00 2038.60    0.00 130470.40     0.00
128.00     0.56    0.27    0.27    0.00   0.15  30.66
sdu               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.27    0.13    0.13    0.00   0.11  22.02
sdp               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.32    0.16    0.16    0.00   0.14  28.70
sdw               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.30    0.15    0.15    0.00   0.12  25.38
sdx               0.00     0.00 2038.40    0.00 130457.60     0.00
128.00     0.40    0.20    0.20    0.00   0.13  26.48

kernel:
[root@spare-a17484327407661 rovchinnikov]# cat /proc/version
Linux version 3.10.0-327.el7.x86_64 (builder@kbuilder.dev.centos.org)
(gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu Nov
19 22:10:57 UTC 2015

So, the question is - why cpu usage is so high and I suppose is a limit here?

-- 
Best regards,
[COOLCOLD-RIPN]
