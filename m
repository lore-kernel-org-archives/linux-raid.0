From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Mon, 11 Nov 2013 17:18:37 -0500
Message-ID: <001401cedf2b$f8eca850$eac5f8f0$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <20131112085825.16ca8446@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131112085825.16ca8446@notabene.brown>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'joystick' <joystick@shiftmail.org>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Monday, November 11, 2013 4:58 PM
To: Justin Piszcz
Cc: joystick; linux-raid
Subject: Re: 3.12: raid-1 mismatch_cnt question

On Mon, 11 Nov 2013 13:52:23 -0500 Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:

[ .. ]

I cannot promise that my code is bug free, but if it wasn't getting this
locking correct, that would be a very serious bug.  I think this possibility
is quite unlikely.

NeilBrown

--

FWIW:

Mount points/options:
# grep md /etc/fstab
/dev/md0        /boot            ext3    defaults                   0  0
/dev/md1        /                ext4    defaults,discard           0  0

Both SSD's are plugged directly into the motherboard's 2 x 6Gbps ports
(Intel chipset/X9SRL-F mobo)

# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Nov  2 10:10:14 2012
     Raid Level : raid1
     Array Size : 1048512 (1024.11 MiB 1073.68 MB)
  Used Dev Size : 1048512 (1024.11 MiB 1073.68 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Nov 11 13:50:08 2013
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 08624db8:4840de94:c44c77eb:7ee19756
         Events : 0.441

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       17        1      active sync   /dev/sdb1

# mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Nov  2 10:10:27 2012
     Raid Level : raid1
     Array Size : 233381376 (222.57 GiB 238.98 GB)
  Used Dev Size : 233381376 (222.57 GiB 238.98 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Nov 11 17:12:37 2013
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 03a64f68:595e7c61:c44c77eb:7ee19756
         Events : 0.340396

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       18        1      active sync   /dev/sdb2

# cat /proc/mdstat 
Personalities : [raid1] 
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      
md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]
      
unused devices: <none>

At boot:
[   12.579770] md: raid1 personality registered for level 1
[   13.777189] md: Waiting for all devices to be available before autodetect
[   13.790829] md: If you don't use raid, use raid=noautodetect
[   13.804604] md: Autodetecting RAID arrays.
[   13.820461] md: Scanned 4 and added 4 devices.
[   13.834231] md: autorun ...
[   13.847869] md: considering sdc2 ...
[   13.861458] md:  adding sdc2 ...
[   13.874984] md: sdc1 has different UUID to sdc2
[   13.888487] md:  adding sdb2 ...
[   13.901934] md: sdb1 has different UUID to sdc2
[   13.915469] md: created md1
[   13.928790] md: bind<sdb2>
[   13.942004] md: bind<sdc2>
[   13.955088] md: running: <sdc2><sdb2>
[   13.968212] md/raid1:md1: active with 2 out of 2 mirrors
[   13.981297] md1: detected capacity change from 0 to 238982529024
[   13.994501] md: considering sdc1 ...
[   14.007674] md:  adding sdc1 ...
[   14.020775] md:  adding sdb1 ...
[   14.033718] md: created md0
[   14.046545] md: bind<sdb1>
[   14.059301] md: bind<sdc1>
[   14.071918] md: running: <sdc1><sdb1>
[   14.084644] md/raid1:md0: active with 2 out of 2 mirrors
[   14.097321] md0: detected capacity change from 0 to 1073676288
[   14.110059] md: ... autorun DONE.
[   14.123179]  md1: unknown partition table
[   14.138285] EXT4-fs (md1): mounted filesystem with ordered data mode.
Opts: (null)
[   14.640887]  md0:
[   15.785971] EXT4-fs (md1): re-mounted. Opts: discard
[   15.970284] EXT3-fs (md0): using internal journal
[   15.970285] EXT3-fs (md0): mounted filesystem with writeback data mode

Justin.

