From: David Nedved <david_nedved@yahoo.com>
Subject: raid1 devices not autostarting
Date: Tue, 30 Mar 2004 22:25:07 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040331062507.76253.qmail@web40704.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I'm trying to move my system off a failing disk onto a raid1 device. 
I've got the device built, but when passing root=/dev/md0 to the kernel
it can't find it.  When I boot my raid devices are NOT autostarting, so
I believe that to be my problem.  I'm running RH9 fully updated with
their latest kernel (2.4.20-30.9SMP), all the partitions are type fd,
and I *think* I have the persistant superblock option on.  I even
recreated md1 to make sure, but still when I boot I have to start the
raids manually.  raidstart --all DOES work.

When init is going through rc.sysinit, it says md0(skipped),
md1(skipped), but they should have been started by the kernel before
that point anyway, shouldn't they?

Any ideas?  I'm including my raidtab below.

Thanks in advance.  I'm not on the list, so if you can help me please
copy me back directly.  Thanks a ton in advance!

David

raiddev /dev/md0
        raid-level              1
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              8
        device                  /dev/sda1
        raid-disk               0
        device                  /dev/sdb1
        raid-disk               1
raiddev /dev/md1
        raid-level              1
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              8
        device                  /dev/sda2
        raid-disk               0
        device                  /dev/sdb2
        raid-disk               1


=====
david_nedved@yahoo.com

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
