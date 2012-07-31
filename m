From: Skip Coombe <skipcoombe@gmail.com>
Subject: persistent removed MD referrence on reboot
Date: Mon, 30 Jul 2012 21:02:27 -0400
Message-ID: <CAO7BsSnu+CZMeQ=YNUKDOCQGF9FYjCTV37rhkBiW1JGAVexxuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an md entry referring to a badly removed RAID1 device (by me) after
the associated device crashed (can't afford a replacement drive at this
time).
Despite attempts to remove the reference, after a reboot I see:

================================
$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10]
md2 : inactive sdc[1](S)
      488385560 blocks super 1.2

unused devices: <none>
================================

I am trying to repurpose the good drive as a not-RAID device. I have done
sudo mdadm --zero-superblock /dev/sdc
and
sudo mdadm --zero-superblock --force /dev/sdc
and even low level formatted /dev/sdc

But the info in /proc/mdstat  and

================================
$ sudo ls -l /dev/md*
brw-rw---- 1 root disk 9, 2 Jul 30 19:34 /dev/md2

/dev/md:
total 0
lrwxrwxrwx 1 root root 8 Jul 30 19:34 2 -> /dev/md2
================================

prevents the new ext3 partition /dev/sdc1 from
being mounted ("mount point is busy"). After executing

================================
$ sudo mdadm --manage --stop /dev/md2
mdadm: stopped /dev/md2

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10]
unused devices: <none>
================================

and /dev/sdc1 can be mounted by device name or UUID.

Note - I have hidden mdadm.conf

================================
$ ls /etc/mdadm/mdadm.conf
ls: cannot access /etc/mdadm/mdadm.conf: No such file or directory
================================

At this point I am willing to uninstall, reinstall, or deactivate
(how?) md but I would rather do it right.

Any suggestions will be appreciated.

Please respond directly: skipcoombe@gmail.com

Thank you,

Skip


--
Skip Coombe
skip.coombe@gmail.com
