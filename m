From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Fw: sdc1 does not have a valid v0.90 superblock, not importing!
Date: Thu, 12 Aug 2010 00:01:45 +0200
Message-ID: <4C631DC9.5090004@stud.tu-ilmenau.de>
References: <275171.86984.qm@web51303.mail.re2.yahoo.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <275171.86984.qm@web51303.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Jon Hardcastle <jd_hardcastle@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had exactly the same problem this week with a costumer raid.  Solved
it via:
- calculate the hardware block where the Superblock resides
- dd if=/dev/sdXY of=superblock seek=block_of_superblock bs=512
- hexedit superblock checksum
- dd of=/dev/sdXY if=superblock skip=block_of_superblock bs=512

this is not the correct way to go.  But noticing that only ONE BIT was
skipped in the checksum, but all the other EXAMINE-information seemed
right, I thought it's the only way to go to get ahold of the data on the
array.

hope it helps,
Stefan


Am 10.08.2010 23:35, schrieb Jon Hardcastle:
> Help!
> 
> Long story short - I was watching a movie off my RAID6 array. Got a smart error warning 
> 
> 'Device: /dev/sdc [SAT], ATA error count increased from 30 to 31'
> 
> I went to investigate and found:
> 
> Error 31 occurred at disk power-on lifetime: 8461 hours (352 days + 13 
> hours)
> 
>   When the command that caused the error occurred, the device was active
>  or idle.
> 
> 
> 
>   After command completion occurred, registers were:
> 
>   ER ST SC SN CL CH DH
> 
>   -- -- -- -- -- -- --
> 
>   84 51 28 50 bd 49 47
> 
> 
> 
>   Commands leading to the command that caused the error were:
> 
>   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
> 
>   -- -- -- -- -- -- -- --  ----------------  --------------------
> 
>   61 38 08 3f bd 49 40 08      00:38:33.100  WRITE FPDMA QUEUED
> 
>   61 08 00 7f bd 49 40 08      00:38:33.100  WRITE FPDMA QUEUED
> 
>   61 08 00 97 bd 49 40 08      00:38:33.000  WRITE FPDMA QUEUED
> 
>   ea 00 00 00 00 00 a0 08      00:38:33.000  FLUSH CACHE EXT
> 
>   61 08 00 bf 4b 38 40 08      00:38:33.000  WRITE FPDMA QUEUED
> 
> I then emailed myself some error logs and shut the machine down. This drive has caused me problems before - the last time when the cat knocked the computer over and dislodged the controller card. But several echo "check" sync_action later and several weeks I have not had a peep out of it.
> 
> ANYWAYS. after the reboot the array wont assemble (is that normal?)
> 
> Aug 10 22:00:07 mangalore kernel: md: running: 
> <sdg1><sdf1><sde1><sdd1><sdb1> <sda1>
> 
> Aug 10 22:00:07 mangalore kernel: raid5: md4 is not clean -- starting 
> background reconstruction
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sdg1 operational as raid
>  disk 0
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sdf1 operational as raid
>  disk 6
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sde1 operational as raid
>  disk 2
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sdd1 operational as raid
>  disk 4
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sdb1 operational as raid
>  disk 5
> 
> Aug 10 22:00:07 mangalore kernel: raid5: device sda1 operational as raid
>  disk 1
> 
> Aug 10 22:00:07 mangalore kernel: raid5: allocated 7343kB for md4
> 
> Aug 10 22:00:07 mangalore kernel: 0: w=1 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: 6: w=2 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: 2: w=3 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: 4: w=4 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: 5: w=5 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: 1: w=6 pa=0 pr=7 m=2 a=2 r=7 op1=0 
> op2=0
> 
> Aug 10 22:00:07 mangalore kernel: raid5: cannot start dirty degraded 
> array for md4
> 
> Aug 10 22:00:07 mangalore kernel: RAID5 conf printout:
> 
> Aug 10 22:00:07 mangalore kernel: --- rd:7 wd:6
> 
> Aug 10 22:00:07 mangalore kernel: disk 0, o:1, dev:sdg1
> 
> Aug 10 22:00:07 mangalore kernel: disk 1, o:1, dev:sda1
> 
> Aug 10 22:00:07 mangalore kernel: disk 2, o:1, dev:sde1
> 
> Aug 10 22:00:07 mangalore kernel: disk 4, o:1, dev:sdd1
> 
> Aug 10 22:00:07 mangalore kernel: disk 5, o:1, dev:sdb1
> 
> Aug 10 22:00:07 mangalore kernel: disk 6, o:1, dev:sdf1
> 
> Aug 10 22:00:07 mangalore kernel: raid5: failed to run raid set md4
> 
> Aug 10 22:00:07 mangalore kernel: md: pers->run() failed ...
> 
> Aug 10 22:00:07 mangalore kernel: md: do_md_run() returned -5
> 
> Aug 10 22:00:07 mangalore kernel: md: md4 stopped.
> 
> It appears sdc has an invalid superblock? 
> 
> This is the 'examine' from sdc1 (note the checksum)
> 
> /dev/sdc1:
> 
>           Magic : a92b4efc
> 
>         Version : 0.90.00
> 
>            UUID : 7438efd1:9e6ca2b5:d6b88274: 7003b1d3
> 
>   Creation Time : Thu Oct 11 00:01:49 2007
> 
>      Raid Level : raid6
> 
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> 
>      Array Size : 2441919680 (2328.80 GiB 2500.53 GB)
> 
>    Raid Devices : 7
> 
>   Total Devices : 7
> 
> Preferred Minor : 4
> 
> 
> 
>     Update Time : Tue Aug 10 21:39:49 2010
> 
>           State : active
> 
>  Active Devices : 7
> 
> Working Devices : 7
> 
>  Failed Devices : 0
> 
>   Spare Devices : 0
> 
>        Checksum : b335b4e3 - expected b735b4e3
> 
>          Events : 1860555
> 
> 
> 
>          Layout : left-symmetric
> 
>      Chunk Size : 64K
> 
> 
> 
>       Number   Major   Minor   RaidDevice State
> 
> this     3       8       33        3      active sync   /dev/sdc1
> 
> 
> 
>    0     0       8       97        0      active sync   /dev/sdg1
> 
>    1     1       8        1        1      active sync   /dev/sda1
> 
>    2     2       8       65        2      active sync   /dev/sde1
> 
>    3     3       8       33        3      active sync   /dev/sdc1
> 
>    4     4       8       49        4      active sync   /dev/sdd1
> 
>    5     5       8       17        5      active sync   /dev/sdb1
> 
>    6     6       8       81        6      active sync   /dev/sdf1
> Anyways... I am ASSUMING mdadm has not assembled the array to be on the safe side? i have not done anything.. no force... no assume clean.. I wanted to be sure?
> 
> Should i remove sdc1 from the array? It should then assemble? I have 2 spare drives that I am getting around to using to replace this drive and the other 500GB.. so should I remove sdc1... and try and re-add or just put the new drive in?
> 
> atm I have 'stop'ped the array and got badblocks running....
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

