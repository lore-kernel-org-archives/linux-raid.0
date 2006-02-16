From: Andrew Nelson <freeandy@gmail.com>
Subject: Re: will mdadm work with a raid created using raidtools
Date: Thu, 16 Feb 2006 09:15:27 -0600
Message-ID: <dt24uh$fv8$1@sea.gmane.org>
References: <43F37BFB.4030908@gmail.com> <17395.45134.227188.527148@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17395.45134.227188.527148@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday February 15, freeandy@gmail.com wrote:
> 
>>I may be a bit late in asking this because I already gave it a try but will
>>mdadm work with a raid created using raidtools?
> 
> 
> Yes.  There is no difference in the arrays created by raidtools or
> mdadm.
> 
> 

Cool.  Now I just gotta figure out why I can't create the raid.  Sadly when this
system crashed I lost the old /etc/raidtab config so I really have no idea how
the raid was set up, but here is what I've done so far.


alfalfa:~# mdadm --examine /dev/hdg
/dev/hdg:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 04407130:1c19b2b9:2c573158:ee8ac467
  Creation Time : Sun Dec 21 16:19:13 2003
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Jan 13 23:12:57 2004
          State : active
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6ff770df - correct
         Events : 0.29


      Number   Major   Minor   RaidDevice State
this     2      34        0        2      spare   /dev/hdg

   0     0      33        1        0      active sync   /dev/hde1
   1     1       0        0        1      faulty removed
   2     2      34        0        2      spare   /dev/hdg
alfalfa:~# mdadm --examin /dev/hde
mdadm: No super block found on /dev/hde (Expected magic a92b4efc, got ffffffff)
alfalfa:~# mdadm --examin /dev/hde1
/dev/hde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 04407130:1c19b2b9:2c573158:ee8ac467
  Creation Time : Sun Dec 21 16:19:13 2003
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Feb 14 21:44:46 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73e5445d - correct
         Events : 0.42


      Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync   /dev/hde1

   0     0      33        1        0      active sync   /dev/hde1
   1     1      34        1        1      active sync   /dev/hdg1
alfalfa:~# mdadm --examin /dev/hdg1
/dev/hdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 04407130:1c19b2b9:2c573158:ee8ac467
  Creation Time : Sun Dec 21 16:19:13 2003
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Feb 14 21:44:46 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73e54460 - correct
         Events : 0.42


      Number   Major   Minor   RaidDevice State
this     1      34        1        1      active sync   /dev/hdg1

   0     0      33        1        0      active sync   /dev/hde1
   1     1      34        1        1      active sync   /dev/hdg1



I then try to assemble the raid with

mdadm --assemble /dev/md0 /dev/hdg1 /dev/hde1


This appears to work fine but then the computer locks up.  With this info in syslog.


Feb 14 21:57:19 localhost kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DI
SKS=27
Feb 14 21:57:19 localhost kernel: md: md0 stopped.
Feb 14 21:57:51 localhost kernel: md: md0 stopped.
Feb 14 21:57:52 localhost kernel: md: bind<hdg1>
Feb 14 21:57:52 localhost kernel: md: bind<hde1>
Feb 14 21:57:52 localhost kernel: md: md0: raid array is not clean -- starting b
ackground reconstruction
Feb 14 21:57:52 localhost kernel: md: raid1 personality registered as nr 3
Feb 14 21:57:52 localhost kernel: raid1: raid set md0 active with 2 out of 2 mir
rors
Feb 14 21:57:52 localhost kernel: md: syncing RAID array md0
Feb 14 21:57:52 localhost kernel: md: minimum _guaranteed_ reconstruction speed:
 1000 KB/sec/disc.
Feb 14 21:57:52 localhost kernel: md: using maximum available idle IO bandwith (
but not more than 200000 KB/sec) for reconstruction.
Feb 14 21:57:52 localhost kernel: md: using 128k window, over a total of 1953583
36 blocks.
Feb 14 21:58:36 localhost kernel: hde: dma_timer_expiry: dma status == 0x21
Feb 14 21:58:46 localhost kernel: hde: DMA timeout error
Feb 14 21:58:46 localhost kernel: hde: dma timeout error: status=0x51 { DriveRea
dy SeekComplete Error }
Feb 14 21:58:46 localhost kernel: hde: dma timeout error: error=0x40 { Uncorrect
ableError }, LBAsect=1594001, high=0, low=1594001, sector=1593535
Feb 14 21:58:46 localhost kernel: end_request: I/O error, dev hde, sector 159353
5

Does anyone have any idea what I'm doing wrong?

Thanks much

//andy

