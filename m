From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 06:51:40 +1100
Message-ID: <20111209065140.107aa286@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
	<20111208091651.2a56dd5b@notabene.brown>
	<2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YSHg5fBVjcgMzeP1lYAf./V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YSHg5fBVjcgMzeP1lYAf./V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Dec 2011 11:17:12 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

>=20
> On Dec 7, 2011, at 2:16 PM, NeilBrown wrote:
>=20
> > On Wed, 7 Dec 2011 14:00:00 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> >=20
> >>=20
> >> On Dec 7, 2011, at 12:57 PM, NeilBrown wrote:
> >>=20
> >>> On Wed, 7 Dec 2011 12:42:26 -0800 Eli Morris <ermorris@ucsc.edu> wrot=
e:
> >>>=20
> >>>> Hi All,
> >>>>=20
> >>>> I thought maybe someone could help me out. I have a 16 disk software=
 RAID that we use for backup. This is at least the second time this happene=
d- all at once, four of the drives report as 'removed' when none of them ac=
tually were. These drives also disappeared from the 'lsscsi' list until I r=
estarted the disk expansion chassis where they live.=20
> >>>>=20
> >>>> These are the dreaded Caviar Green drives. We bought 16 of them as a=
n upgrade for a hardware RAID originally, because the tech from that compan=
y said they would work fine. After running them for a while, four drives dr=
opped out of that array. So I put them in the software RAID expansion chass=
is they are in now, thinking I might have better luck. In this configuratio=
n, this happened once before. That time, the drives looked to all have sign=
ificant numbers of bad sectors, so I got those ones replaced and thought th=
at that might have been the problem all along. Now it has happened again. S=
o I have two fairly predictable questions and I'm hoping someone might be a=
ble to offer a suggestion:
> >>>>=20
> >>>> 1) Any ideas on how to get this array working again without starting=
 from scratch? It's all backup data, so it's not do or die, but it is also =
30 TB and I really don't want to rebuild the whole thing again from scratch.
> >>>=20
> >>> 1/ Stop the array
> >>>   mdadm -S /dev/md5
> >>>=20
> >>> 2/ Make sure you can read all of the devices
> >>>=20
> >>>   mdadm -E /dev/some-device
> >>>=20
> >>> 3/ When you are confident that the hardware is actually working, reas=
semble
> >>>  the array with --force
> >>>=20
> >>>   mdadm -A /dev/md5 --force /dev/sd[a-o]1
> >>> (or whatever gets you a list of devices.)
> >>>=20
> >>>>=20
> >>>> I tried the re-add command and the error was something like 'not all=
owed'
> >>>>=20
> >>>> 2) Any idea on how to stop this from happening again? I was thinking=
 of playing with the disk timeout in the OS (not the one on the drive firmw=
are).=20
> >>>=20
> >>> Cannot help there, sorry - and you really should solve this issue bef=
ore you
> >>> put the array back together or it'll just all happen again.
> >>>=20
> >>> NeilBrown
> >>>=20
> >>>>=20
> >>>> If anyway can help, I'd greatly appreciate it, because, at this poin=
t, I have no idea what to do about this mess.=20
> >>>>=20
> >>>> Thanks!
> >>>>=20
> >>>> Eli
> >>>>=20
> >>>>=20
> >>>> [root@stratus ~]# mdadm --detail /dev/md5
> >>>> /dev/md5:
> >>>>       Version : 1.2
> >>>> Creation Time : Wed Oct 12 16:32:41 2011
> >>>>    Raid Level : raid5
> >>>> Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
> >>>>  Raid Devices : 16
> >>>> Total Devices : 13
> >>>>   Persistence : Superblock is persistent
> >>>>=20
> >>>>   Update Time : Mon Dec  5 12:52:46 2011
> >>>>         State : active, FAILED, Not Started
> >>>> Active Devices : 12
> >>>> Working Devices : 13
> >>>> Failed Devices : 0
> >>>> Spare Devices : 1
> >>>>=20
> >>>>        Layout : left-symmetric
> >>>>    Chunk Size : 512K
> >>>>=20
> >>>>          Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.u=
csc.edu)
> >>>>          UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
> >>>>        Events : 32
> >>>>=20
> >>>>   Number   Major   Minor   RaidDevice State
> >>>>      0       8        1        0      active sync   /dev/sda1
> >>>>      1       0        0        1      removed
> >>>>      2       8       33        2      active sync   /dev/sdc1
> >>>>      3       8       49        3      active sync   /dev/sdd1
> >>>>      4       8       65        4      active sync   /dev/sde1
> >>>>      5       8       81        5      active sync   /dev/sdf1
> >>>>      6       8       97        6      active sync   /dev/sdg1
> >>>>      7       8      113        7      active sync   /dev/sdh1
> >>>>      8       0        0        8      removed
> >>>>      9       8      145        9      active sync   /dev/sdj1
> >>>>     10       8      161       10      active sync   /dev/sdk1
> >>>>     11       8      177       11      active sync   /dev/sdl1
> >>>>     12       8      193       12      active sync   /dev/sdm1
> >>>>     13       8      209       13      active sync   /dev/sdn1
> >>>>     14       0        0       14      removed
> >>>>     15       0        0       15      removed
> >>>>=20
> >>>>     16       8      225        -      spare   /dev/sdo1
> >>>> [root@stratus ~]#=20
> >>>>=20
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>=20
> >>=20
> >> Hi Neil,
> >>=20
> >> Thanks. I gave it a try and I think I got close to getting it back. Ma=
ybe. Here is the output from one of the drives that showed up as 'removed' =
below. It looks OK to me, but I'm not really sure what trouble signs to loo=
k for. After stopping the array, I tried to reconstruct it, and here is wha=
t I got below. I don't know why the drives would be busy. Short of rebootin=
g, which I can't do at the moment, is there a way to check why they are bus=
y and force them to stop? I don't have them mounted or anything. Or do you =
think that means the hardware is not responding properly?
> >>=20
> >> Thanks,
> >>=20
> >> Eli
> >>=20
> >> mdadm -A /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev=
/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1=
 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
> >> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
> >> mdadm: failed to add /dev/sdp1 to /dev/md5: Device or resource busy
> >> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to =
start the array.
> >=20
> > This means that the device is busy....
> > Maybe it got attach to another md array.  What is in /proc/mdstat.  May=
be you
> > have to stop something else.
> >=20
> > NeilBrown
>=20
> I found somewhere that dmraid can grab the drives and not release them, s=
o I removed the dmraid packages and set the nodrmraid flag on the boot line=
. Since I did that I get:
>=20
> mdadm: cannot open device /dev/sda1: Device or resource busy
> mdadm: /dev/sda1 has no superblock - assembly aborted
>=20
> which is a little odd, since last time it complained that /sdo1 and /sdp1=
 where busy and didn't say anything about drive /sda1. Anyway through, I re=
ad some instructions here:=20
>=20
> http://en.wikipedia.org/wiki/Mdadm#Known_problems
>=20
> that suggest that I zero the superblock on /dev/sda1
>=20
> I don't know too much about this, but I thought the superblock contained =
information about the RAID array. If I zero it, will that screw up the arra=
y that I'm trying to recover or is it the thing to try? I also am wondering=
 if this might have caused the problem to begin with, like dmraid grabbed f=
our of my drives when I did the last routine reboot, since I had four drive=
s come up as "removed" all of a sudden.=20
>=20
> thanks for any advice,
>=20
> Eli
> =20


Don't zero anything until you are sure you know what the problem is and why
that would fix it.  I probably won't in this case.

There are a number of things that can keep a device busy:
 - mounted filesystem - unlikely here
 - enabled as swap - unlikely
 - in an md array - /proc/mdstat shows there aren't any
 - in a dm array - "dmsetup table" will show you, "dmsetup remove_all" will
   remove the dm arrays
 - some process has an exclusive open - again, unlikely.

Cannot think of anything else just now.

Are there any message appearing in the kernel logs (or 'dmesg' output)
when you try to assemble the array.

Try running the --assemble with --verbose and  post the result.

NeilBrown


--Sig_/YSHg5fBVjcgMzeP1lYAf./V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuEVWznsnt1WYoG5AQJQMg/+KCXdPsxV73ACHSell/b3liYIi/Kbfu7b
MeWht3dSh7tcw2gUswxGIGZwLKIvirBvBS9ZvDp1XjC6p/9C3jmB3h82FC0xTcqH
CFetLpGRofSfWIahA0sR3O9euzoSXonvni3fuP7RsCruHHSP49P9QziD2lDDj1bt
M83pKoEhpbJ6VjuSwbjw1JfqRe3eMMnso7MBIcW9TmA/BWPSKW3zOniBKBP3kMra
EXgKQbw60g+KmYNMhmmpylTv3FERkv7tRtw+nsoZ2V8+RUA22yY9oZTrmFqZm175
htw3n/UHTI4MpHFsWyKbe4apIO7+KYwCKbXhuvsIAnhLp3MbpUfxtjuBCNhF5txz
0JhCSIvPtVauJGcavvwOOWPmKyv0Fr5L60Eb8uqGZ+ZC0mXlwEcVnJC6XBtf01yX
0Mm359jyb9tYqC4PaBvp4enxBEqMyk2FfA2qhL2NeYdS3sokdGvQzz26DPUq0IVW
0urH2JKrSlASygwBg7NDAq4BSbSU4vkaXVc6PL4TZBL9MUOyj0F8nZnz22EoEl4v
mcKlVFEWdQNsbMJogKcqU7aBqiqY0IANMB687MiP2tZIAAEUI1if+kpZLjRxGWyg
zvwNSAPpBW9q0dz4RgcHPvD2Izgnpiuj7ioBUnn7Yph9j/aezXyq8B8/L2ROmUaz
ArUREVv/hhk=
=gv0a
-----END PGP SIGNATURE-----

--Sig_/YSHg5fBVjcgMzeP1lYAf./V--
