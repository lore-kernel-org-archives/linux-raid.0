From: CoolCold <coolthecold@gmail.com>
Subject: removing nonexistent drive from array
Date: Thu, 12 Nov 2009 22:46:38 +0300
Message-ID: <f19d625d0911121146x6235dcdfl4711f088efc3549b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
I have raid1 array built of 2 disks. One of drives failed, so i've
removed it and inserted another one. Old disk was /dev/sdc, new one
detected as /dev/sde, I've added it into array, recovery begun and
everything is fine except i can't remove the old one:

root@srv15:~# cat /proc/mdstat
Personalities : [raid1]
md3 : active raid1 sde3[2] sdd3[0] sdc3[3](F)
      290720192 blocks [2/1] [U_]
      [=>...................]  recovery =  5.9% (17269760/290720192)
finish=1229.9min speed=3703K/sec

md2 : active raid1 sda3[0] sdb3[1]
      290720192 blocks [2/2] [UU]

md1 : active raid1 sdb2[0] sda2[1]
      1951808 blocks [2/2] [UU]

md0 : active raid1 sdb1[0] sda1[1]
      289024 blocks [2/2] [UU]

unused devices: <none>

root@srv15:~# cat /proc/partitions |grep sdc
root@srv15:~# mdadm /dev/md3 -r /dev/sdc3
mdadm: cannot find /dev/sdc3: No such file or directory

Didn't find anything in man about such case. Any ideas?

System is Debian Etch
root@srv15:~# dpkg -p mdadm|grep Vers
Version: 2.5.6-9

kernel version 2.6.28.8, amd64

-- 
Best regards,
[COOLCOLD-RIPN]
