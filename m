From: Erwan Leroux <erwan.lerou@gmail.com>
Subject: Re: mdadm forces resync every boot
Date: Sat, 6 Aug 2011 12:18:18 +0200
Message-ID: <CAHX8RiTFTQsrK+nprPRMC9DCZ86BLdv4yKsbo5b8RQONTNB+8g@mail.gmail.com>
References: <4E3C06D1.6030301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3C06D1.6030301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Frey <djqfrey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can you post the content of /etc/mdadm/mdadm.conf ?

I noticed that if the ARRAY line contains the name parameter, the raid
is not started properly
ARRAY /dev/md/raid metadata=3D1.2
UUID=3D906ce226:19afa04f:12aab3c1:f91daa96 name=3DServeur:raid

you just have to remove the parameter and everything go back to normal.

Mayre be you're in this case, but you mentionned dual-boot, so perhaps
your problem is related to

Cordialy,

Erwan Leroux



2011/8/5 Daniel Frey <djqfrey@gmail.com>:
> Hi all,
>
> I've been fighting with my raid array (imsm - raid10) for several wee=
ks
> now. I've now replaced all four drives in my array as the constant
> rebuilding caused a smart error to trip on the old drives; unfortunat=
ely
> mdadm is still resyncing the array at every boot.
>
> One thing I would like to clarify is does mdadm need to disassemble t=
he
> array before reboot. At this point, I can't tell if my system is
> currently doing this. Googling around it seems some say that this ste=
p
> is unnecessary.
>
> I've managed to update initramfs to 3.2.1 and the local system to 3.2=
=2E1
> but the problem still persists.
>
> The last thing my system does is remount root ro, which it does
> successfully. However, at the next start:
>
> [ =A0 12.657829] md: md127 stopped.
> [ =A0 12.660652] md: bind<sdc>
> [ =A0 12.660939] md: bind<sdb>
> [ =A0 12.661212] md: bind<sda>
> [ =A0 12.661282] md: bind<sdd>
> [ =A0 12.664972] md: md126 stopped.
> [ =A0 12.665284] md: bind<sdd>
> [ =A0 12.665383] md: bind<sdc>
> [ =A0 12.665476] md: bind<sdb>
> [ =A0 12.665568] md: bind<sda>
> [ =A0 12.669218] md/raid10:md126: not clean -- starting background
> reconstruction
> [ =A0 12.669221] md/raid10:md126: active with 4 out of 4 devices
> [ =A0 12.669241] md126: detected capacity change from 0 to 1000210432=
000
> [ =A0 12.678356] md: md126 switched to read-write mode.
> [ =A0 12.678390] md: resync of RAID array md126
> [ =A0 12.678393] md: minimum _guaranteed_ =A0speed: 1000 KB/sec/disk.
> [ =A0 12.678395] md: using maximum available idle IO bandwidth (but n=
ot
> more than 200000 KB/sec) for resync.
> [ =A0 12.678399] md: using 128k window, over a total of 976768256 blo=
cks.
>
> and cat /proc/mdstat shows it resyncing:
>
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10]
> md126 : active raid10 sda[3] sdb[2] sdc[1] sdd[0]
> =A0 =A0 =A0976768000 blocks super external:/md127/0 64K chunks 2 near=
-copies
> [4/4] [UUUU]
> =A0 =A0 =A0[=3D=3D>..................] =A0resync =3D 12.2% (119256896=
/976768256)
> finish=3D100.7min speed=3D141865K/sec
>
> md127 : inactive sdd[3](S) sda[2](S) sdb[1](S) sdc[0](S)
> =A0 =A0 =A09028 blocks super external:imsm
>
> unused devices: <none>
>
> When it resyncs it is fine until the next power down.
>
> Some other details:
>
> # mdadm --detail-platform
> =A0 =A0 =A0 Platform : Intel(R) Matrix Storage Manager
> =A0 =A0 =A0 =A0Version : 9.6.0.1014
> =A0 =A0RAID Levels : raid0 raid1 raid10 raid5
> =A0 =A0Chunk Sizes : 4k 8k 16k 32k 64k 128k
> =A0 =A0 =A0Max Disks : 7
> =A0 =A0Max Volumes : 2
> =A0I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
> =A0 =A0 =A0 =A0 =A0Port0 : /dev/sda (WD-WCAYUJ525606)
> =A0 =A0 =A0 =A0 =A0Port1 : /dev/sdb (WD-WCAYUJ525636)
> =A0 =A0 =A0 =A0 =A0Port2 : /dev/sdc (WD-WCAYUX093587)
> =A0 =A0 =A0 =A0 =A0Port3 : /dev/sdd (WD-WCAYUX092774)
> =A0 =A0 =A0 =A0 =A0Port4 : - non-disk device (TSSTcorp CDDVDW SH-S203=
B) -
> =A0 =A0 =A0 =A0 =A0Port5 : - no device attached -
>
> # mdadm --detail --scan
> ARRAY /dev/md/imsm0 metadata=3Dimsm UUID=3Dec239ccc:22b7330b:0c4808ff=
:82dd176b
> ARRAY /dev/md/HDD_0 container=3D/dev/md/imsm0 member=3D0
> UUID=3Df61f87fc:1e85f04b:59e873c5:0afdb987
>
> # ls /dev/md
> HDD_0 =A0HDD_0p1 =A0HDD_0p2 =A0HDD_0p3 =A0HDD_0p4 =A0imsm0
>
> Everything seems to be working. Also, I can't reproduce the results i=
n
> Windows Vista x64 (dual-boot.) When I go from linux -> Windows, Windo=
ws
> detects the array as bad and reinitializes it as well, but if I reboo=
t
> into Windows the array survives without being marked bad.
>
> Can anyone shed some light on this? I've been bashing my head on my d=
esk
> for too long and have run out of ideas.
>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
