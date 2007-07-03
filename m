From: Simon <simon.xhz@gmail.com>
Subject: Re: spare not becoming active
Date: Tue, 3 Jul 2007 15:53:46 -0500
Message-ID: <f7de5e030707031353o14c4a7bbjb2a270646f75fe54@mail.gmail.com>
References: <4682C9ED.9040503@gmail.com> <4683DC71.3050200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4683DC71.3050200@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got a ghost in my system!

Ok, I'm still having weird issues and as nobody replied, I'm still
unsure how to proceed...
Here, I tried reformating (dd'ed some zeros on the whole drives),
repartitionning them.

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1           1         961   83  Linux
/dev/sdb2               2        1015     1005888   fd  Linux raid autodetect

I have 3 identical drives, fresh made, i issue the command:
mdadm --create --verbose /dev/md1 --level=raid5 --raid-devices=3
/dev/sdb2 /dev/sdc2 /dev/sdd2

My system is a new install (nothing left in /etc, etc...), so I really
don't get what's going on, check the output of several programs:

/dev/md1:
        Version : 00.90.03
  Creation Time : Tue Jul  3 16:29:38 2007
     Raid Level : raid5
     Array Size : 2011648 (1964.83 MiB 2059.93 MB)
  Used Dev Size : 1005824 (982.41 MiB 1029.96 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jul  3 16:31:05 2007
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 39% complete

           UUID : 84aa4aaf:8b2c555e:3f9ae70d:2eedd5b3
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8       34        1      active sync   /dev/sdc2
       3       8       50        2      spare rebuilding   /dev/sdd2
================================================================================
[dev   9,   1] /dev/md1         84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 online
[dev   8,  18] /dev/sdb2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
[dev   8,  34] /dev/sdc2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   8,  50] /dev/sdd2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 spare
