From: Ken Causey <ken@ineffable.com>
Subject: Can't figure out how to use mdadm in initrd
Date: 28 Jun 2002 09:45:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1025275522.600.10.camel@temp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

I don't get it.  I cannot seem to get mdadm to handle a degraded array
no matter what I do.  I'm setting up a system with all filesystems
including boot and root on software RAID.  I initially tried to use
raidstart in my initrd but ran into a bug that prevents reinstating
missing array members in some circumstances, so I was directed to use
mdadm instead.  Here's my current setup:

root is on /dev/md2 (RAID5)

The /etc/mdadm/mdadm.conf file in the initrd contains:

DEVICE /dev/sd*
ARRAY /dev/md2 devices="/dev/sda3,/dev/sdb3,/dev/sdc3"

The modules loaded are

modprobe -k aic7xxx
modprobe -k raid1
modprobe -k raid5
modprobe -k ext3
modprobe -k ext2

mdadm is run as

set "/dev/md2"
[ -b "$1" ] || set "/dev/md/2"
mdadm --assemble --run --scan "$1"

I've tried every combination I can think of and if there is any member
missing (say sdc3) then it complains that that member has a bad
superblock.  Please tell me what I'm doing wrong here.  If you need more
information, let me know.

Ken Causey

