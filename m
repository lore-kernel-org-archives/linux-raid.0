From: <martin@hack.org>
Subject: md device stuck!
Date: Mon, 29 Jul 2002 15:50:05 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.32.0207291541380.4476-100000@dope.pingdynasty.com>
References: <15685.5438.362051.450805@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15685.5438.362051.450805@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hiya,

has anyone come across the problem of md devices getting 'stuck'?
currently, if i try to mount/umount md2, or run either raidstop or
mdadm --stop, the commands just hang and /proc/mdstat gives no indication
of anything going on. (the only way to kill the command seems to be to
SIGKILL its parent process...)

any ideas?

dope:~ # mount
/dev/md1 on / type ext2 (rw)
proc on /proc type proc (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)

dope:~ # cat /proc/mdstat
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md2 : active raid5 sdb6[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb4[1] sda5[0]
      44220800 blocks level 5, 32k chunk, algorithm 2 [6/6] [UUUUUU]
md1 : active raid5 sdd2[2] sdc2[1] sdb5[0]
      17688448 blocks level 5, 32k chunk, algorithm 2 [3/3] [UUU]
md0 : active raid1 sdb2[1] sda2[0]
      2147264 blocks [2/2] [UU]
unused devices: <none>

dope:~ # ps -flw
  F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
004 S root      4414  4413  0  72   0 -   506 norita 15:33 pts/4    00:00:00 -bash
000 D root      4438  4414  0  72   0 -   220 ptrace 15:34 pts/4    00:00:00 mdadm --stop /dev/md2

many thanks,

/m

