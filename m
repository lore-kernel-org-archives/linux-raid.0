From: Oleg Samarin <osamarin68@gmail.com>
Subject: How does linux hide underlying disks partitions?
Date: Fri, 29 May 2015 22:07:14 +0300
Message-ID: <1432926434.4733.1.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to evaluate a complex mdadm-lvm-udev-anaconda issue
https://bugzilla.redhat.com/show_bug.cgi?id=1226305 and to undestand
how mdadm works.

I have an intel imsm raid-1 volume /dev/md126 assembled with two
disks /dev/sda and /dev/sdb.
This volume has two partitions /dev/md126p1 and /dev/md126p2.

Because it a simple mirror, both disks have te same information.

When the normal system boots up, I can see with journalctl that

1. at first /dev/sda1, /dev/sda2, /dev/sdb1, /dev/sdb2 appear
2. then mdadm assembles /dev/md126 from /dev/sda and /dev/sdb
3. /dev/sda1, /dev/sda2, /dev/sdb1, /dev/sdb2 disappear
4. /dev/md126p1 and /dev/md126p2 coming instead

Which program component is responsible for
disappearing /dev/sda1, /dev/sda2, /dev/sdb1 and /dev/sdb2?

Why can they be left after starting anaconda installer?

