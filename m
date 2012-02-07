From: Richard Herd <2001oddity@gmail.com>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 16:02:27 +1100
Message-ID: <CAOANJV8kQ2U3LaZiH0QXtaPGeEh5wQ110B9d_CU_77E5Kwit7Q@mail.gmail.com>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
	<CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
	<20120207143941.58c3ccb6@notabene.brown>
	<CAOANJV_giURCH_yi8fMyKGpQ-uRSzF9iwOoV-_qO5sAASvYWwA@mail.gmail.com>
	<20120207152501.5541d379@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207152501.5541d379@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Hmm - see you're point about the kernel...

Kernel updated.  I'm now running 2.6.38.

I went to work on it a bit more under 2.6.38 - I'm not sure here, it
wouldn't take all the disks as before, but this time seems to have
assembled (with --force) using 4 of the disks.

Trying to re-add the 5th and 6th didn't throw the same warning as
before (failed to re-add and not adding as spare), it said ''re-added
/dev/xxx to /dev/md0' but when checking detail we can see they were
added as spares not as part of the array.

Anyway, with the array assembled and running, I have got the
filesystem mounted and am quickly smashing an rsync to mirror what I
can (8TB, how long could it take? lol).

Thanks so much for your help guys - once I got the hint on the kernel
it wasn't too hard to get the array assembled again.  Now it's just a
waiting game I guess to see how much of the data is intact.  Also, at
what point would those two disks now marked as spare be re-synced into
the array?  After the reshape completes?

Really appreciate your help :-)

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sde1[6](S) sdg1[7](S) sdc1[1] sdf1[4] sdd1[3] sdb1[2=
]
      7814047744 blocks super 0.91 level 6, 64k chunk, algorithm 18
[6/4] [_UUUU_]
      [>....................]  reshape =3D  3.9% (78086144/1953511936)
finish=3D11710.7min speed=3D2668K/sec

unused devices: <none>


root@raven:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.91
  Creation Time : Tue Jul 12 23:05:01 2011
     Raid Level : raid6
     Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Feb  7 15:52:10 2012
          State : clean, degraded, reshaping
 Active Devices : 4
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric-6
     Chunk Size : 64K

 Reshape Status : 3% complete
     New Layout : left-symmetric

           UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (local to host ra=
ven)
         Events : 0.1850269

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       8       49        3      active sync   /dev/sdd1
       4       8       81        4      active sync   /dev/sdf1
       5       0        0        5      removed

       6       8       65        -      spare   /dev/sde1
       7       8       97        -      spare   /dev/sdg1




On Tue, Feb 7, 2012 at 3:25 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Feb 2012 14:50:57 +1100 Richard Herd <2001oddity@gmail.com>=
 wrote:
>
>> Hi Neil,
>>
>> OK, git head is: mdadm-3.2.3-21-gda8fe5a
>>
>> I have 8 disks. =A0They get muddled about each boot (an issue I have
>> never addressed). =A0 Ignore sde (esata HD) and sdh (usb boot).
>>
>> It seems even with --force, dmesg always reports 'kicking non-fresh
>> sdc/g1 from array!'. =A0Leaving sdg out as suggested by Phil doesn't
>> help unfortunately.
>>
>> root@raven:/neil/mdadm# ./mdadm -Avvv --force
>> --backup-file=3D/usb/md0.backup /dev/md0 /dev/sda1 /dev/sdb1 /dev/sd=
c1
>> /dev/sdd1 /dev/sdf1 /dev/sdg1
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 5.
>> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 0.
>> mdadm:/dev/md0 has an active reshape - checking if critical section
>> needs to be restored
>> mdadm: accepting backup with timestamp 1328559119 for array with
>> timestamp 1328567549
>> mdadm: restoring critical section
>> mdadm: added /dev/sdg1 to /dev/md0 as 0
>> mdadm: added /dev/sda1 to /dev/md0 as 2
>> mdadm: added /dev/sdc1 to /dev/md0 as 3
>> mdadm: added /dev/sdf1 to /dev/md0 as 4
>> mdadm: added /dev/sdd1 to /dev/md0 as 5
>> mdadm: added /dev/sdb1 to /dev/md0 as 1
>> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
>
>
> Hmmm.... maybe your kernel isn't quite doing the right thing.
> =A0commit 674806d62fb02a22eea948c9f1b5e58e0947b728 is important.
> It is in 2.6.35. =A0What kernel are you running?
> Definitely something older given the "1: w=3D1 pa=3D18...." messages.=
 =A0They
> disappear in 2.6.34.
>
> So I'm afraid you're going to need a new kernel.
>
> NeilBrown
>
>
>
>
>>
>> and dmesg:
>> [13964.591801] md: bind<sdg1>
>> [13964.595371] md: bind<sda1>
>> [13964.595668] md: bind<sdc1>
>> [13964.595900] md: bind<sdf1>
>> [13964.599084] md: bind<sdd1>
>> [13964.599652] md: bind<sdb1>
>> [13964.600478] md: kicking non-fresh sdc1 from array!
>> [13964.600493] md: unbind<sdc1>
>> [13964.612138] md: export_rdev(sdc1)
>> [13964.612163] md: kicking non-fresh sdg1 from array!
>> [13964.612183] md: unbind<sdg1>
>> [13964.624077] md: export_rdev(sdg1)
>> [13964.628203] raid5: reshape will continue
>> [13964.628243] raid5: device sdb1 operational as raid disk 1
>> [13964.628252] raid5: device sdf1 operational as raid disk 4
>> [13964.628260] raid5: device sda1 operational as raid disk 2
>> [13964.629614] raid5: allocated 6308kB for md0
>> [13964.629731] 1: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
>> [13964.629742] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=
=3D0
>> [13964.629751] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
>> [13964.629760] 2: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=
=3D0
>> [13964.629767] raid5: not enough operational devices for md0 (3/6 fa=
iled)
>> [13964.640403] RAID5 conf printout:
>> [13964.640409] =A0--- rd:6 wd:3
>> [13964.640416] =A0disk 1, o:1, dev:sdb1
>> [13964.640423] =A0disk 2, o:1, dev:sda1
>> [13964.640429] =A0disk 4, o:1, dev:sdf1
>> [13964.640436] =A0disk 5, o:1, dev:sdd1
>> [13964.641621] raid5: failed to run raid set md0
>> [13964.649886] md: pers->run() failed ...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
