From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 15:03:57 +0200
Message-ID: <496DE2BD.6070905@fastmail.co.uk>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> After reboot, show dmesg/logs, what is the error?
There's no error specific to md - it seems to just ignore sdi. There are 
errors from 'sd' saying sdi has an unknown partition table - but I don't 
care about partition tables since I'm using the whole devices (ie 
/dev/sdi not /dev/sdi1 or whatever). /dev/sdh is the other spare.

Here's some bits from dmesg :

[    9.720380] sd 11:0:0:0: [sdi] 390721968 512-byte hardware sectors 
(200050 MB
)
[    9.720392] sd 11:0:0:0: [sdi] Write Protect is off
[    9.720395] sd 11:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    9.720413] sd 11:0:0:0: [sdi] Write cache: enabled, read cache: 
enabled, doe
sn't support DPO or FUA
[    9.720460] sd 11:0:0:0: [sdi] 390721968 512-byte hardware sectors 
(200050 MB
)
[    9.720471] sd 11:0:0:0: [sdi] Write Protect is off
[    9.720473] sd 11:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    9.720490] sd 11:0:0:0: [sdi] Write cache: enabled, read cache: 
enabled, doe
sn't support DPO or FUA
[    9.720493]  sdi: unknown partition table
[    9.725328] sd 11:0:0:0: [sdi] Attached SCSI disk
...
[   13.735948] md: md2 stopped.
[   13.755547] md: md2 stopped.
[   13.757496] md: bind<sdh>
[   13.757657] md: bind<sdg>
[   13.763358] Driver 'sr' needs updating - please use bus_type methods
[   13.767589] sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   13.767594] Uniform CD-ROM driver Revision: 3.20
[   13.767692] sr 8:0:1:0: Attached scsi CD-ROM sr0
[   13.770178] md: md2 stopped.
[   13.770201] md: unbind<sdg>
[   13.803686] md: export_rdev(sdg)
[   13.803704] md: unbind<sdh>
[   13.806345] md: export_rdev(sdh)
[   13.809153] md: bind<sdg>
[   13.809290] md: bind<sdd>
[   13.809430] md: bind<sdh>
[   13.809577] md: bind<sdf>
[   13.812235] md: md2 stopped.
[   13.812250] md: unbind<sdf>
[   13.818201] md: export_rdev(sdf)
[   13.818217] md: unbind<sdh>
[   13.830018] md: export_rdev(sdh)
[   13.830024] md: unbind<sdd>
[   13.834004] md: export_rdev(sdd)
[   13.834011] md: unbind<sdg>
[   13.834262] md: export_rdev(sdg)
[   13.837616] md: bind<sdg>
[   13.837748] md: bind<sdb>
[   13.837870] md: bind<sdd>
[   13.837992] md: bind<sde>
[   13.838133] md: bind<sdh>
[   13.838280] md: bind<sdf>
[   13.847605] md: md2 stopped.
[   13.847620] md: unbind<sdf>
[   13.860054] md: export_rdev(sdf)
[   13.860063] md: unbind<sdh>
[   13.860091] md: export_rdev(sdh)
[   13.860096] md: unbind<sde>
[   13.860120] md: export_rdev(sde)
[   13.860126] md: unbind<sdd>
[   13.860149] md: export_rdev(sdd)
[   13.860154] md: unbind<sdb>
[   13.860176] md: export_rdev(sdb)
[   13.860182] md: unbind<sdg>
[   13.860204] md: export_rdev(sdg)
[   13.863504] md: bind<sdg>
[   13.863636] md: bind<sdb>
[   13.863759] md: bind<sdd>
[   13.863877] md: bind<sdc>
[   13.863999] md: bind<sde>
[   13.864139] md: bind<sdh>
[   13.864285] md: bind<sdf>
[   13.873381] raid5: device sdf operational as raid disk 0
[   13.873383] raid5: device sde operational as raid disk 5
[   13.873385] raid5: device sdc operational as raid disk 4
[   13.873387] raid5: device sdd operational as raid disk 3
[   13.873389] raid5: device sdb operational as raid disk 2
[   13.873391] raid5: device sdg operational as raid disk 1
[   13.873941] raid5: allocated 6312kB for md2
[   13.873944] raid5: raid level 5 set md2 active with 6 out of 6 
devices, algorithm 2
[   13.873947] RAID5 conf printout:
[   13.873948]  --- rd:6 wd:6
[   13.873950]  disk 0, o:1, dev:sdf
[   13.873952]  disk 1, o:1, dev:sdg
[   13.873953]  disk 2, o:1, dev:sdb
[   13.873955]  disk 3, o:1, dev:sdd
[   13.873957]  disk 4, o:1, dev:sdc
[   13.873958]  disk 5, o:1, dev:sde

I'll give the below a try...

Thanks,

Max.
> I would try:
>
> 1. mdadm --examine --scan
> 2. Put that info into mdadm.conf.
> 3. Reboot, see if its good.
> 4. Otherwise, remove the spare from the array, zero the mdadm superblock.
> 5. Re-add it to the array.
> 6. Worst case, zero out the drive and then re-add it and re-run step 1 
> and
>    add the new information to mdadm.conf.
>

