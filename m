From: PAulN <pauln@psc.edu>
Subject: Raid5 Construction Question
Date: Thu, 19 Aug 2004 13:24:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4124E24E.7070802@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
So I have a raid 5 which is around ~1TB and the problem I've been having 
is that
the resync rate is really bad.  This is understandable given that the 
raid5 has not
been initialized.  Does anyone know a way for me to initialize my raid5 
before I use it so
that the resync process doesn't run for 3 days?
thanks
paul


Config:
-------------------------------------------------
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               7
nr-spare-disks              1
chunk-size                  64k
persistent-superblock       1
parity-algorithm        left-symmetric
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdb1
    raid-disk     1
    device          /dev/sdc1
    raid-disk     2
    device          /dev/sdd1
    raid-disk     3
    device          /dev/sde1
    raid-disk     4
    device          /dev/sdg1
    raid-disk     5
    device          /dev/sdf1
    raid-disk    6
    device          /dev/sdh1
    spare-disk     0
----------------------------------------

