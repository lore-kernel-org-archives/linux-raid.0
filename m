From: "Marc" <linux-raid@liquid-nexus.net>
Subject: RE: Poor RAID5 performance on new SMP system
Date: Mon, 18 Oct 2004 15:33:08 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041018072749.M67126@liquid-nexus.net>
References: <C8650B2A-20C7-11D9-AECB-00039359D1F2@bitart.com> <200410180612.i9I6CZN14660@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410180612.i9I6CZN14660@www.watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I took hdg offline and ran tests on it separately with bonnie and it seems 
OK. The array rebuild is really slow - max 15000kB/s and the load average is 
over 2. The strange thing is that kswapd is actively running whenever I 
perform IO on the array (and my swap file is not used at all). I haven't 
noticed this before - I suspect its related to this issue. Any ideas? Enable 
himem? (I only have 512MB RAM).

-----------
cat /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdg1[1] hdk1[3] hdi1[2] hde1[0]
      234444288 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

---------------
mdadm -D /dev/md0 (I got the Debian testing version v.1.7.0 - it doesnt 
show 'no-errors' now but maybe its because I've just rebuild the array by 
removing hdg and then re-adding it).

/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Apr 17 12:19:25 2004
     Raid Level : raid5
     Array Size : 234444288 (223.58 GiB 240.07 GB)
    Device Size : 78148096 (74.53 GiB 80.02 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Oct 18 15:10:52 2004
          State : dirty
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 775f1dcf:7cbc17ab:86e1e792:669b732f
         Events : 0.86

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       3      57        1        3      active sync   /dev/hdk1


--


---------- Original Message -----------
From: "Guy" <bugzilla@watkins-home.com>
To: "'Gerd Knops'" <gerti@bitart.com>, "'Marc'" <linux-raid@liquid-nexus.net>
Cc: <linux-raid@vger.kernel.org>
Sent: Mon, 18 Oct 2004 02:12:30 -0400
Subject: RE: Poor RAID5 performance on new SMP system

> You missed something!
> "State : dirty, no-errors"
> 
> Mark,
> If you want, send the output of these 2 commands:
> cat /proc/mdstat
> mdadm -D /dev/md?
> 
> Don't forget, with versions of md (or mdadm) older than about 6 
> months, the counts get really off! My 14 disk array is fine..... 
>  Note the: "no-errors"! But: /dev/md2:        Version : 00.90.00
>   Creation Time : Fri Dec 12 17:29:50 2003     Raid Level : raid5    
>  Array Size : 230980672 (220.28 GiB 236.57 GB)    Device Size : 
> 17767744 (16.94 GiB 18.24 GB)   Raid Devices : 14  <<LOOK HERE>> 
>  Total Devices : 12  <<LOOK HERE>> Preferred Minor : 2   
>  Persistence : Superblock is persistent
> 
>     Update Time : Wed Oct 13 01:55:40 2004
>           State : dirty, no-errors  <<LOOK HERE>>
>  Active Devices : 14  <<LOOK HERE>>
> Working Devices : 11  <<LOOK HERE>>
>  Failed Devices : 1   <<LOOK HERE>>
>   Spare Devices : 0   <<LOOK HERE>>
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8      145        1      active sync   /dev/sdj1
>        2       8       65        2      active sync   /dev/sde1
>        3       8      161        3      active sync   /dev/sdk1
>        4       8       81        4      active sync   /dev/sdf1
>        5       8      177        5      active sync   /dev/sdl1
>        6       8       97        6      active sync   /dev/sdg1
>        7       8      193        7      active sync   /dev/sdm1
>        8       8      241        8      active sync   /dev/sdp1
>        9       8      209        9      active sync   /dev/sdn1
>       10       8      113       10      active sync   /dev/sdh1
>       11       8      225       11      active sync   /dev/sdo1
>       12       8      129       12      active sync   /dev/sdi1
>       13       8       33       13      active sync   /dev/sdc1
>            UUID : 8357a389:8853c2d1:f160d155:6b4e1b99
> 
> #cat /proc/mdstat
> Personalities : [raid1] [raid5]
> read_ahead 1024 sectors
> md2 : active raid5 sdc1[13] sdi1[12] sdo1[11] sdh1[10] sdn1[9] 
> sdp1[8] sdm1[7] sdg1[6] sdl1[5] sdf1[4] sdk1[3] sde1[2] sdj1[1] sdd1[0]
>       230980672 blocks level 5, 64k chunk, algorithm 2 [14/14]
> [UUUUUUUUUUUUUU]
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gerd Knops
> Sent: Monday, October 18, 2004 1:37 AM
> To: Marc
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Poor RAID5 performance on new SMP system
> 
> On Oct 17, 2004, at 21:11, Marc wrote:
> 
> > Hi,
> > I recently upgraded my file server to a dual AMD 2800+ on a Tyan Tiger 
> > MPX
> > motherboard. The previous server was using a PIII 700 on an Intel 440BX
> > motherboard. I basically just took the IDE drives and their controllers
> > across to the new machine. The strange thing is that the RAID-5 
> > performance
> > is worse than before! Have a look at the stats below:
> >
> 
> [..]
> 
> >          State : dirty, no-errors
> >  Active Devices : 4
> > Working Devices : 4
> >  Failed Devices : 1
> >   Spare Devices : 0
> >
> 
> Unless I am missing something, a disk is missing and the RAID runs 
> in degraded (=slower) mode.
> 
> Gerd
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

