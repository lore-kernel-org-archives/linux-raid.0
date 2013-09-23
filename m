From: Sachin Garg <sgarg.bugreporter@gmail.com>
Subject: Re: (Solved) Desperate: mdadm fails to assemble raid saying devices
 are busy.
Date: Mon, 23 Sep 2013 15:49:44 -0400
Message-ID: <52409B58.3070700@gmail.com>
References: <523DADE5.8050604@gmail.com> <CAAMCDed1UffC4yj9DvKSu_9HhrJo6XLh4tHqkU9ymhP19AD1Ag@mail.gmail.com> <524053D3.4060707@gmail.com> <alpine.DEB.2.02.1309231740580.32315@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1309231740580.32315@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23-Sep-13 11:43 AM, Mikael Abrahamsson wrote:
> Do "mdadm --stop /dev/md0" and then try
> 
> "mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb1 /dev/sdc2"
> 
> See if this removes the busy problem. Also post output from this
> operation as well as what comes up in dmesg when you do this.

Thanks, Mikael - that worked. The output of the various commands are
given below.

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

[22874.978883] md: md0 stopped.
[22874.978900] md: unbind<sda2>
[22875.018193] md: export_rdev(sda2)
[22875.018284] md: unbind<sdb1>
[22875.059733] md: export_rdev(sdb1)
[22875.059821] md: unbind<sdc2>
[22875.079735] md: export_rdev(sdc2)
[22875.652012] md: md0 stopped.

# mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb1 /dev/sdc2
mdadm: /dev/md0 assembled from 3 drives - not enough to start the array
while not clean - consider --force.

[22875.653625] md: bind<sdc2>
[22875.653943] md: bind<sdb1>
[22875.654302] md: bind<sda2>

# mdadm --assemble --force /dev/md0 /dev/sda2 /dev/sdb1 /dev/sdc2

This worked!!!

# mdadm -Dv /dev/md0

/dev/md0:
        Version : 1.2
  Creation Time : Sat Mar  2 11:03:45 2013
     Raid Level : raid5
     Array Size : 468475392 (446.77 GiB 479.72 GB)
  Used Dev Size : 156158464 (148.92 GiB 159.91 GB)
   Raid Devices : 4
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Sep 23 15:41:08 2013
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : sysresccd:0
           UUID : 01b153ea:a93c7325:c13bf9cf:3195666f
         Events : 118445

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       34        1      active sync   /dev/sdc2
       2       0        0        2      removed
       4       8       17        3      active sync   /dev/sdb1

Now, I need to find a new hard drive and put it in Slot 2. What would be
the best way to do that, apart from RTFM ?

Thanks for all your help.

Best,
Sachin
