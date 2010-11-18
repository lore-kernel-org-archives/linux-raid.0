From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: faulty array member
Date: Thu, 18 Nov 2010 18:08:46 +0100
Message-ID: <4CE55D9E.4070406@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have a linux file-server with to 1TB sata disks
in software raid1.

as my drives are no longer in full health raid put
one array member in faulty state.

A bit about my environment:

# uname -rms
Linux 2.6.9-89.0.18.ELsmp i686

# cat /etc/redhat-release
CentOS release 4.8 (Final)


# parted /dev/sda print
Disk geometry for /dev/sda: 0.000-953869.710 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031    251.015  primary   ext3        boot
2        251.016  40248.786  primary   ext3        raid
3      40248.787  42296.132  primary   linux-swap
4      42296.133 953867.219  primary   ext3        raid

# parted /dev/sdb print
Disk geometry for /dev/sdb: 0.000-953869.710 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031  39997.771  primary   ext3        boot, raid
2      39997.771  42045.117  primary   linux-swap
3      42045.117  42296.132  primary   ext3
4      42296.133 953867.219  primary   ext3        raid


# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb4[1] sda4[0]
       933448704 blocks [2/2] [UU]
md0 : active raid1 sdb1[1] sda2[2](F)
       40957568 blocks [2/1] [_U]
unused devices: <none>


Don't ask me why the two drives are not specular
and md0 is mapped sdb1+sda2.. I have no idea.
It was made so by anaconda using kickstart during install.


So, I was using debugfs:
# debugfs
debugfs 1.35 (28-Feb-2004)
debugfs:  open /dev/md0
debugfs:  testb 1736947
Block 1736947 marked in use
debugfs:  icheck 1736947
Block   Inode number
1736947 <block not found>
debugfs:  icheck 1736947 10
Block   Inode number
1736947 <block not found>
10      7

in an attempt to locate the bad disk blocks, and after that
software raid put sda2 in faulty state.


Now, as smartctl is telling me that there are errors spread
on all partitions used in both raids, I would like to take
a full backup of at least /dev/md1 (that's still healthy).

The question is:
Is there a way and is it safe to put back /dev/sda2 into
/dev/md0 so that I'm sure I can backup even the blocks
that are unreadable on the first array member but probably
are still readable on failed device?

Thank you for your time and help!

Best regards.
Robi
