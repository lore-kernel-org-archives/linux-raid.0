From: Richard Herd <2001oddity@gmail.com>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 14:50:57 +1100
Message-ID: <CAOANJV_giURCH_yi8fMyKGpQ-uRSzF9iwOoV-_qO5sAASvYWwA@mail.gmail.com>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
	<CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
	<20120207143941.58c3ccb6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207143941.58c3ccb6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

OK, git head is: mdadm-3.2.3-21-gda8fe5a

I have 8 disks.  They get muddled about each boot (an issue I have
never addressed).   Ignore sde (esata HD) and sdh (usb boot).

It seems even with --force, dmesg always reports 'kicking non-fresh
sdc/g1 from array!'.  Leaving sdg out as suggested by Phil doesn't
help unfortunately.

root@raven:/neil/mdadm# ./mdadm -Avvv --force
--backup-file=3D/usb/md0.backup /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sdf1 /dev/sdg1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 0.
mdadm:/dev/md0 has an active reshape - checking if critical section
needs to be restored
mdadm: accepting backup with timestamp 1328559119 for array with
timestamp 1328567549
mdadm: restoring critical section
mdadm: added /dev/sdg1 to /dev/md0 as 0
mdadm: added /dev/sda1 to /dev/md0 as 2
mdadm: added /dev/sdc1 to /dev/md0 as 3
mdadm: added /dev/sdf1 to /dev/md0 as 4
mdadm: added /dev/sdd1 to /dev/md0 as 5
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

and dmesg:
[13964.591801] md: bind<sdg1>
[13964.595371] md: bind<sda1>
[13964.595668] md: bind<sdc1>
[13964.595900] md: bind<sdf1>
[13964.599084] md: bind<sdd1>
[13964.599652] md: bind<sdb1>
[13964.600478] md: kicking non-fresh sdc1 from array!
[13964.600493] md: unbind<sdc1>
[13964.612138] md: export_rdev(sdc1)
[13964.612163] md: kicking non-fresh sdg1 from array!
[13964.612183] md: unbind<sdg1>
[13964.624077] md: export_rdev(sdg1)
[13964.628203] raid5: reshape will continue
[13964.628243] raid5: device sdb1 operational as raid disk 1
[13964.628252] raid5: device sdf1 operational as raid disk 4
[13964.628260] raid5: device sda1 operational as raid disk 2
[13964.629614] raid5: allocated 6308kB for md0
[13964.629731] 1: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[13964.629742] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=3D=
0
[13964.629751] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[13964.629760] 2: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[13964.629767] raid5: not enough operational devices for md0 (3/6 faile=
d)
[13964.640403] RAID5 conf printout:
[13964.640409]  --- rd:6 wd:3
[13964.640416]  disk 1, o:1, dev:sdb1
[13964.640423]  disk 2, o:1, dev:sda1
[13964.640429]  disk 4, o:1, dev:sdf1
[13964.640436]  disk 5, o:1, dev:sdd1
[13964.641621] raid5: failed to run raid set md0
[13964.649886] md: pers->run() failed ...

root@raven:/neil/mdadm# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.91
  Creation Time : Tue Jul 12 23:05:01 2011
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Feb  7 09:32:29 2012
          State : active, FAILED, Not Started
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

     New Layout : left-symmetric

           UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (local to host ra=
ven)
         Events : 0.1848341

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       17        1      active sync   /dev/sdb1
       2       8        1        2      active sync   /dev/sda1
       3       0        0        3      removed
       4       8       81        4      active sync   /dev/sdf1
       5       8       49        5      spare rebuilding   /dev/sdd1

On Tue, Feb 7, 2012 at 2:39 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Feb 2012 14:19:06 +1100 Richard Herd <2001oddity@gmail.com>=
 wrote:
>
>> Hi Neil,
>>
>> Thanks.
>>
>> FYI, I've cloned your git repo and compiled and tried using your cod=
e.
>> =A0Unfortunately everything looks the same as below (exactly same
>> output, exactly same dmesg - still wants to kick non-fresh sdc from
>> the array at assemble).
>
> Strange.
>
> Please report output of
> =A0git describe HEAD
>
> and also run the 'mdadm --assemble --force ....' with -vvv as well, a=
nd
> report all of the output.
>
> Also I think some of you devices have changed named a bit. =A0Make su=
re you
> list exactly the 6 devices that were recently in the array. i.e. exac=
tly
> those that report something sensible to "mdadm -E /dev/WHATEVER"
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
