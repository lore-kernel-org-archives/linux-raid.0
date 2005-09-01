From: Jim Faulkner <james.faulkner@yale.edu>
Subject: question regarding multipath & Linux 2.6
Date: Thu, 1 Sep 2005 14:51:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0509011419390.15688-100000@netra.cs.yale.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

Recently my department had a SAN installed, and I am in the process of 
setting up one of the first Linux machines connected to it.  The machine 
is running Red Hat Enterprise AS4 (x86_64), which uses Linux kernel 
version 2.6.9-11.ELsmp.

The SAN shows up twice in the kernel, as /dev/sdb and /dev/sdc.  /dev/sdb 
is inaccessible (I get a bunch of "Buffer I/O error on device sdb" kernel 
errors), but /dev/sdc works fine.  According to the administrator of the 
SAN, the SAN shows up twice because there are two paths to the device, 
each going through a different storage processor (SP).  At any time, 
only one SP is active, which is why /dev/sdb is inaccessible but /dev/sdc 
works fine.  The administrator informed me that it is possible for the 
paths to switch (i.e. /dev/sdc becomes inactive and /dev/sdb becomes 
active), so I need to have some kind of multipathing software installed.  
He told me to use PowerPath, but I'd rather not have to reinstall or 
rebuild kernel modules every time there is a kernel upgrade, so I'm 
looking into Linux's built-in multipath support.

I followed the very straightforward instructions available here:
http://www.centos.org/docs/4/html/rhel-ig-s390-multi-en-4/s1-s390info-raid.html#S2-S390INFO-MULTIPATH

I created /etc/mdadm.conf, then ran:
mdadm -C /dev/md0 --level=multipath --raid-devices=2 /dev/sdb /dev/sdc

Initially after creation, "mdadm --detail" reports that both paths are up 
and active:
    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc

However, when I actually start using the device, /dev/sdb is removed and 
is set faulty (which makes sense since /dev/sdb is inaccessible):
    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       8       32        1      active sync   /dev/sdc
       2       8       16       -1      faulty   /dev/sdb

My question is this:  If the paths are switched while my machine is up, 
will Linux be smart enough to check if /dev/sdb has become active when 
/dev/sdc becomes faulty?  Or will the whole device fail?

thanks,
Jim Faulkner


