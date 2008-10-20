From: ml@donsbox.com
Subject: change order of component devices
Date: Mon, 20 Oct 2008 16:42:37 -0400 (EDT)
Message-ID: <a890a0a486b174ab3a5606fe38bdadca.squirrel@www.donsbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Somehow, after replacing a failed disk, the device order changed for one
of my arrays (md2):

# cat /proc/mdstat
Personalities : [linear] [raid1]
md1 : active raid1 sdc2[2](S) sdb2[1] sda2[0]
      4008128 blocks [2/2] [UU]

md2 : active raid1 sdc3[2](S) sdb3[0] sda3[1]
      1003968 blocks [2/2] [UU]

md3 : active raid1 sdc4[2](S) sdb4[1] sda4[0]
      138223168 blocks [2/2] [UU]

md0 : active raid1 sdc1[2](S) sdb1[1] sda1[0]
      136448 blocks [2/2] [UU]

unused devices: <none>

Now /dev/sdb3 is RaidDevice 0.

It's not harming anything, but it's weird.  Is there any way to may
/dev/sda3 device 0, again?  I tried failing /dev/sdb3 and /dev/sda3,
activating the spare, then putting it all back, but device 0 was still
assigned to /dev/sdb3.

# uname -a
Linux stmfd-stweb 2.6.17-gentoo-r8 #5 SMP Thu Oct 26 08:58:42 EDT 2006
x86_64 Intel(R) Xeon(TM) CPU 2.80GHz GenuineIntel GNU/Linux

# mdadm --version
mdadm - v2.5.2 -  27 June 2006



