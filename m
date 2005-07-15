From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: How to auto rebuild array?
Date: Fri, 15 Jul 2005 12:04:46 +0200
Message-ID: <42D78A3E.777FAC84@ardistech.com>
References: <42D3C998.3F84EF1C@ardistech.com> <42D567F7.7010408@ruisantos.com> <42D60C24.AF0C2931@ardistech.com> <42D77A6E.3070205@ruisantos.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rui Santos <rsantos@ruisantos.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Rui,

>  Nevertheless, i could realy use those commands outputs.
> 
Below are the command outputs for the RAID1 set when /dev/hdb3 was
kicked during raid autodetect.

Cheers,
	Bart


--------------------------------------------------------------------
# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid5] 
md1 : active raid1 hdb2[1] hda2[0]
      99904 blocks [2/2] [UU]
      
md2 : active raid1 hda3[0]
      999936 blocks [2/1] [U_]


# mdadm --misc -D /dev/md2
/dev/md2:
        Version : 00.90.01
  Creation Time : Tue Jul  5 09:15:31 2005
     Raid Level : raid1
     Array Size : 999936 (976.50 MiB 1023.93 MB)
    Device Size : 999936 (976.50 MiB 1023.93 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Jul 15 12:03:17 2005
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 1c03c211:3bbbdacf:20ff8e96:29bd37e7
         Events : 0.211375

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/.static/dev/hda3
       1       0        0        -      removed


# mdadm --misc -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 1c03c211:3bbbdacf:20ff8e96:29bd37e7
  Creation Time : Tue Jul  5 09:15:31 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2

    Update Time : Fri Jul 15 12:03:17 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : d15f25b8 - correct
         Events : 0.211375


      Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync   /dev/.static/dev/hda3

   0     0       3        3        0      active sync   /dev/.static/dev/hda3
   1     1       0        0        1      faulty removed

# mdadm --misc -E /dev/hdb3
/dev/hdb3:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 1c03c211:3bbbdacf:20ff8e96:29bd37e7
  Creation Time : Tue Jul  5 09:15:31 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Fri Jul 15 11:25:42 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d15f1c9a - correct
         Events : 0.211268


      Number   Major   Minor   RaidDevice State
this     1       3       67        1      active sync   /dev/.static/dev/hdb3

   0     0       3        3        0      active sync   /dev/.static/dev/hda3
   1     1       3       67        1      active sync   /dev/.static/dev/hdb3
