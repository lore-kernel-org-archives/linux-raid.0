From: "Peckins, Steven E" <speckins@illinois.edu>
Subject: Re: RAID6 recovery with 6/9 drives out-of-sync
Date: Wed, 1 Jun 2016 13:16:06 +0000
Message-ID: <5BE0D8AF-C1BF-4DFB-BEAE-8C93898EAC87@illinois.edu>
References: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
 <574DE3B0.8000409@turmel.org>
 <5D9C8773-D76E-409F-8961-41EB3ACD177A@illinois.edu>
 <574ECFE2.9050602@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574ECFE2.9050602@turmel.org>
Content-Language: en-US
Content-ID: <07107A0A17E95742BA6B8AF1920DB8C7@mx.uillinois.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jun 1, 2016, at 7:06 AM, Phil Turmel <philip@turmel.org> wrote:
>=20
> Understood, but be aware that if you have to hotswap one of these sys=
tem
> devices, they may not get the sda or sdb name, preventing a re-add or=
 a
> replacement from joining the array.
>=20
> Since you are having to use /dev/mapper entries for some arrays,
> consider using /dev/disk/by*/ symlinks for your system arrays.

Noted and updated.  (Those two drives are connected to the motherboard =
SATA, and the kernel names have been stable.  All other drives are conn=
ected through on-board SAS controllers and HBAs, etc.)


> I vaguely recall a bug in forced reassembly for many out-of-date driv=
es.
> Please clone and build the latest mdadm userspace[1] and run that mda=
dm
> binary for the forced assembly.  Also show the portion of dmesg that
> corresponds to the attempt.

Good call!  The latest mdadm was able to assemble this array.

ocarina mdadm-latest # ./mdadm --version
mdadm - v3.4 - 28th January 2016
ocarina mdadm-latest # ./mdadm --assemble /dev/md10 --force --verbose /=
dev/dm-{0,1,11,12,13,14,15,16,17,28}
mdadm: looking for devices for /dev/md10
mdadm: /dev/dm-0 is identified as a member of /dev/md10, slot 0.
mdadm: /dev/dm-1 is identified as a member of /dev/md10, slot 1.
mdadm: /dev/dm-11 is identified as a member of /dev/md10, slot 2.
mdadm: /dev/dm-12 is identified as a member of /dev/md10, slot 3.
mdadm: /dev/dm-13 is identified as a member of /dev/md10, slot 4.
mdadm: /dev/dm-14 is identified as a member of /dev/md10, slot 5.
mdadm: /dev/dm-15 is identified as a member of /dev/md10, slot 6.
mdadm: /dev/dm-16 is identified as a member of /dev/md10, slot 7.
mdadm: /dev/dm-17 is identified as a member of /dev/md10, slot 8.
mdadm: /dev/dm-28 is identified as a member of /dev/md10, slot -1.
mdadm: forcing event count in /dev/dm-14(5) from 35 upto 44
mdadm: forcing event count in /dev/dm-15(6) from 35 upto 44
mdadm: forcing event count in /dev/dm-16(7) from 35 upto 44
mdadm: forcing event count in /dev/dm-17(8) from 35 upto 44
mdadm: clearing FAULTY flag for device 5 in /dev/md10 for /dev/dm-14
mdadm: clearing FAULTY flag for device 6 in /dev/md10 for /dev/dm-15
mdadm: clearing FAULTY flag for device 7 in /dev/md10 for /dev/dm-16
mdadm: clearing FAULTY flag for device 8 in /dev/md10 for /dev/dm-17
mdadm: Marking array /dev/md10 as 'clean'
mdadm: added /dev/dm-1 to /dev/md10 as 1
mdadm: added /dev/dm-11 to /dev/md10 as 2
mdadm: added /dev/dm-12 to /dev/md10 as 3
mdadm: added /dev/dm-13 to /dev/md10 as 4
mdadm: added /dev/dm-14 to /dev/md10 as 5
mdadm: added /dev/dm-15 to /dev/md10 as 6
mdadm: added /dev/dm-16 to /dev/md10 as 7
mdadm: added /dev/dm-17 to /dev/md10 as 8
mdadm: added /dev/dm-28 to /dev/md10 as -1
mdadm: added /dev/dm-0 to /dev/md10 as 0
mdadm: /dev/md10 has been started with 9 drives and 1 spare.

Output from dmesg for successful --assemble --force with latest mdadm b=
inary:

[Wed Jun  1 08:23:15 2016] md: md10 stopped.
[Wed Jun  1 08:23:15 2016] md: bind<dm-1>
[Wed Jun  1 08:23:15 2016] md: bind<dm-11>
[Wed Jun  1 08:23:15 2016] md: bind<dm-12>
[Wed Jun  1 08:23:15 2016] md: bind<dm-13>
[Wed Jun  1 08:23:15 2016] md: bind<dm-14>
[Wed Jun  1 08:23:15 2016] md: bind<dm-15>
[Wed Jun  1 08:23:15 2016] md: bind<dm-16>
[Wed Jun  1 08:23:15 2016] md: bind<dm-17>
[Wed Jun  1 08:23:15 2016] md: bind<dm-28>
[Wed Jun  1 08:23:15 2016] md: bind<dm-0>
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-0 operational as rai=
d disk 0
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-17 operational as ra=
id disk 8
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-16 operational as ra=
id disk 7
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-15 operational as ra=
id disk 6
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-14 operational as ra=
id disk 5
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-13 operational as ra=
id disk 4
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-12 operational as ra=
id disk 3
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-11 operational as ra=
id disk 2
[Wed Jun  1 08:23:15 2016] md/raid:md10: device dm-1 operational as rai=
d disk 1
[Wed Jun  1 08:23:15 2016] md/raid:md10: allocated 9558kB
[Wed Jun  1 08:23:15 2016] md/raid:md10: raid level 6 active with 9 out=
 of 9 devices, algorithm 2
[Wed Jun  1 08:23:15 2016] RAID conf printout:
[Wed Jun  1 08:23:15 2016]  --- level:6 rd:9 wd:9
[Wed Jun  1 08:23:15 2016]  disk 0, o:1, dev:dm-0
[Wed Jun  1 08:23:15 2016]  disk 1, o:1, dev:dm-1
[Wed Jun  1 08:23:15 2016]  disk 2, o:1, dev:dm-11
[Wed Jun  1 08:23:15 2016]  disk 3, o:1, dev:dm-12
[Wed Jun  1 08:23:15 2016]  disk 4, o:1, dev:dm-13
[Wed Jun  1 08:23:15 2016]  disk 5, o:1, dev:dm-14
[Wed Jun  1 08:23:15 2016]  disk 6, o:1, dev:dm-15
[Wed Jun  1 08:23:15 2016]  disk 7, o:1, dev:dm-16
[Wed Jun  1 08:23:15 2016]  disk 8, o:1, dev:dm-17
[Wed Jun  1 08:23:15 2016] md10: detected capacity change from 0 to 140=
02780897280
[Wed Jun  1 08:23:15 2016] RAID conf printout:
[Wed Jun  1 08:23:15 2016]  --- level:6 rd:9 wd:9
[Wed Jun  1 08:23:15 2016]  disk 0, o:1, dev:dm-0
[Wed Jun  1 08:23:15 2016]  disk 1, o:1, dev:dm-1
[Wed Jun  1 08:23:15 2016]  disk 2, o:1, dev:dm-11
[Wed Jun  1 08:23:15 2016]  disk 3, o:1, dev:dm-12
[Wed Jun  1 08:23:15 2016]  disk 4, o:1, dev:dm-13
[Wed Jun  1 08:23:15 2016]  disk 5, o:1, dev:dm-14
[Wed Jun  1 08:23:15 2016]  disk 6, o:1, dev:dm-15
[Wed Jun  1 08:23:15 2016]  disk 7, o:1, dev:dm-16
[Wed Jun  1 08:23:15 2016]  disk 8, o:1, dev:dm-17
[Wed Jun  1 08:23:15 2016]  md10: unknown partition table

Uneventful dmesg output from EARLIER unsuccessful attempt with mdadm 3.=
3:

[Wed Jun  1 07:35:22 2016] md: md10 stopped.
[Wed Jun  1 07:35:22 2016] md: bind<dm-1>
[Wed Jun  1 07:35:22 2016] md: bind<dm-11>
[Wed Jun  1 07:35:22 2016] md: bind<dm-12>
[Wed Jun  1 07:35:22 2016] md: bind<dm-13>
[Wed Jun  1 07:35:22 2016] md: bind<dm-14>
[Wed Jun  1 07:35:22 2016] md: bind<dm-15>
[Wed Jun  1 07:35:22 2016] md: bind<dm-16>
[Wed Jun  1 07:35:22 2016] md: bind<dm-17>
[Wed Jun  1 07:35:22 2016] md: bind<dm-28>
[Wed Jun  1 07:35:22 2016] md: bind<dm-0>
[Wed Jun  1 07:35:22 2016] md: md10 stopped.
[Wed Jun  1 07:35:22 2016] md: unbind<dm-0>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-0)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-28>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-28)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-17>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-17)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-16>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-16)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-15>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-15)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-14>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-14)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-13>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-13)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-12>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-12)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-11>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-11)
[Wed Jun  1 07:35:22 2016] md: unbind<dm-1>
[Wed Jun  1 07:35:22 2016] md: export_rdev(dm-1)

I activated the lvm volume and mounted the filesystem.  Everything look=
s intact.

Thanks for your help recovering this array!  I had been avoiding updati=
ng mdadm while I was recovering this as I had read of potential issues =
while recovering arrays created with earlier versions.

=97steve


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
