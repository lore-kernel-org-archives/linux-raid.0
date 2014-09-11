From: system.admin@yum.de
Subject: access to old raid1 partitions after reinstall on two new disks
Date: Thu, 11 Sep 2014 18:02:57 +0200
Message-ID: <5411C7B1.1010205@yum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there,

we have a machine running on four raid-1 partitions (2 disks). The
system had to be reinstalled on two new disks since one of the old disks
failed and we afterwards saw defective sectors on the remaining disk. So
the system was restored from backup on two complete new disks. We now
have the disk with the defective sectors on which the old system was
installed as third disk installed in the machine. Since we could not
recover everything from backup, we would like to start the old raid
devices from the old disk again and try to access the old filesystems
again.

The fresh installed system has of course the same md0, md1, md2, md3
devices as the old one had. Therefore I wonder how to access the old
raid devices, which had the same names.

Is there a way to get the old partitions running as additional raid
devices like md4, md5, md6 and md7 (or under different names) and should
it be possible to mount the filesystems of those new / old raid devices
in the fresh installed system?

Thanks for your help!

Regards
Hans
