From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: disable raid autodetect at boot
Date: Mon, 23 May 2011 12:36:45 +0300
Message-ID: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a simple raid1 created on top of /dev/sda and /dev/sdb. After I
reboot, I would like to always manually assemble the raid. However,
every time the machine reboots, it looks like md tries to
automatically reassemble the raid, but usually binds only one of the
source devices:

16936	May 23 11:47:36 vc kernel: [    3.472926] md: linear personality
registered for level -1
16937	May 23 11:47:36 vc kernel: [    3.509352] md: multipath
personality registered for level -4
16938	May 23 11:47:36 vc kernel: [    3.551948] md: raid0 personality
registered for level 0
16939	May 23 11:47:36 vc kernel: [    3.683874] md: raid1 personality
registered for level 1
16953	May 23 11:47:36 vc kernel: [    4.944362] md: raid6 personality
registered for level 6
16954	May 23 11:47:36 vc kernel: [    4.944364] md: raid5 personality
registered for level 5
16955	May 23 11:47:36 vc kernel: [    4.944365] md: raid4 personality
registered for level 4
16956	May 23 11:47:36 vc kernel: [    4.949193] md: raid10 personality
registered for level 10
16971	May 23 11:47:36 vc kernel: [    6.059194] md: bind<sdb>

And /proc/mdstat has:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md_d127 : inactive sdd[1](S)
      2097140 blocks super 1.2

According to md.txt, "only drives with a type 0 superblock can be
autodetected and run at boot time". During raid creation, I have
specified metadata version to be 1.2; this is confirmed by --examine.
Also, I have tried to use raid=noautodetect kernel parameter, but the
auto-detection still keeps happening.

The only way up to now I have found to prevent this, is by specifying
something like
DEVICE /dev/null
in /etc/mdadm/mdadm.conf

What am I missing?

Thanks,
  Alex.
