From: "Joe Pitts" <jpitts@hvc.rr.com>
Subject: raid1 fstab
Date: Tue, 7 Sep 2004 10:01:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000301c494e3$1fc92720$0801a8c0@homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm running FC2 kernel-2.6.8-1.521

I am converting a single disk setup to RAID1. I've been using the procedure
in OREILLY's Managing Raid on Linux, pp239 241 - Converting to software
raid.
I'm at the point where I'm have to edit the /etc/fstab file and aside from
listing the
md devices I have'nt a clue what else I should be putting in this file.
My raid devices are:
/dev/md0 = /dev/sdb1 = /boot
/dev/md1 = /dev/sdb2 = /usr
/dev/md2 = /dev/sdb3 = /var/www
/dev/md3 = /dev/sdb5 = /
/dev/md4 = /dev/sdb6 = /tmp
/dev/md5 = /dev/sdb7 = swap
/dev/md6 = /dev/sdb8 = /var
/dev/md7 = /dev/sdb9 = /home
/dev/md8 = /dev/sdb10 = /var/lib
/dev/md9 = /dev/sdb11 = /var/log

Also can anyone point me in the direction as to how grub.conf woud be edited
to
properly boot this setup

