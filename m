From: Roberto Spadim <roberto@spadim.com.br>
Subject: raid1 resync consuming a lot of cpu
Date: Mon, 23 Jan 2012 17:51:14 -0200
Message-ID: <CABYL=Tqu+LWN10DQkZZ=h23bd6fogp_4fMr9i_xnYFbkhAbLng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys
my raid1 server was disconected from power
and it=B4s starting resync...
ok no problem
i set max speed to 1MB/s
the problem is....
the CPU is waiting a lot
i don=B4t know if raid1 resync program is consuming my CPU with wait
eventos to ensure a 1MB/s of speed, since i don=B4t have anyother
process running just resync at a slow speed
could anyone check this?
at /proc/

[root@friganso log]# cat /proc/version
Linux version 2.6.26-ARCH (root@T-POWA-LX) (gcc version 4.3.1 20080724
(prerelease) (GCC) ) #1 SMP PREEMPT Sun Aug 10 14:04:12 CEST 2008

[root@friganso log]# cat /proc/mdstat
Personalities : [raid1]
md3 : active raid1 sdb4[1] sda4[0]
      390074176 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
      68364480 blocks [2/2] [UU]
      [=3D=3D>..................]  resync =3D 11.9% (8152768/68364480)
finish=3D732.5min speed=3D1369K/sec

md1 : active raid1 sdb2[1] sda2[0]
      29302464 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

unused devices: <none>







at HTOP program what i see is this:

  1  [|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||=
|||||1.3%]
    Tasks: 368 total, 1 running
  2  [|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||=
|||||2.7%]
    Load average: 54.04 50.06 41.78
  3  [|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||=
|||||1.7%]
    Uptime: 00:57:52
  4  [||||||||||||||||||
     1.8%]     Avg:  0.3% sy:  1.1% ni:  0.0% hi:  0.0% si:  0.0% wa:
73.1%
  5  [|||||||||||||||||||||||||||||
     1.4%]     Mem:16047M used:6556M buffers:0M cache:9411M
  6  [|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||=
|||||1.1%]
    Mem[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||6=
556/16047MB]
  7  [|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||=
|||||1.0%]
    Swp[|
 41/28615MB]
  8  [||||||||||||||||||||||||||||||
     0.7%]     Avg:  0.3% sy:  1.1% ni:  0.0% hi:  0.0% si:  0.0% wa:
73.1%


wa=3D73.1%!!!!! and system is veeery slow, it=B4s dual a xeon DELL serv=
er
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5410  @ 2.33GHz
<- quad core, i have 2 cpus (physical id     : 0, physical id     : 1)

i don=B4t know how to get this wa(maybe waiting) cpu percentage from /p=
roc files
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
