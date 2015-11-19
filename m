From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Reshape Woes
Date: Wed, 18 Nov 2015 20:23:40 -0500
Message-ID: <564D249C.308@turmel.org>
References: <41BC47FD-C02B-4DDA-BF1C-75032831AA29@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BC47FD-C02B-4DDA-BF1C-75032831AA29@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/18/2015 08:07 PM, Francisco Parada wrote:
> Resending, previous message got rejected due to =E2=80=9CHTML=E2=80=9D=
=2E  Damn Apple Mail ;-)

Heh, but let me fix that typo:  Damn Apple ;-)

> Hi all,
>=20
> I thought I had corrected all the flaws in my setup, but I was mistak=
en.  I took care of my hard drive timeout mismatch encountered via a th=
read a little over a week ago, subjected =E2=80=9CRAID 6 Not Mounting (=
Block device is empty), by adding =E2=80=9Csmartctl -l scterc,70,70 /de=
v/sdX=E2=80=9D and =E2=80=9Cfor x in /sys/block/*/device/timeout ; do e=
cho 180 > $x ; done=E2=80=9D to my boot scripts.  I took care of my PSU=
 issue, by replacing my enclosure=E2=80=99s defective PSU, with a new P=
SU which tested out OK with a multimeter.  Today, however, I report som=
e bad news once again. =20

Ugly.

> After having stressed my rebuilt array for a few days, by adding larg=
e sums of data and noting no further syslog errors, I decided that I co=
uld not live with 18GB of disk space remaining.  Since my last post, I=E2=
=80=99ve accumulated an additional Terrabyte, and so I ran out of space=
=2E  At the ready, I had a spare drive, so I decided to run "mdadm --gr=
ow --raid-devices=3D7 --backup-file=3D/root/grow_md126.bak /dev/md126=E2=
=80=9D, to go from a 6 drive RAID 6 array to my 7 drive array.  All was=
 good for about a minute, and then my nightmare began.  Luckily, I have=
 a backup of prior to my Terrabyte, which is alright if I lose, just ra=
ther not.

Time to toss some enclosures and/or cables.

> mdstat output:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Every 1.0s: cat /proc/mdstat                                         =
                                               Wed Nov 18 19:25:02 2015
>=20
> Personalities : [raid0] [linear] [multipath] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md126 : active raid6 sdh[0](F) sdk[6] sdg[5](F) sdf[4](F) sde[3](F) s=
dj[2] sdi[1]
>       11720540160 blocks super 1.2 level 6, 512k chunk, algorithm 2 [=
7/3] [_UU___U]
>       [>....................]  reshape =3D  0.0% (2726560/2930135040)=
 finish=3D193325.8min speed=3D252K/sec
>       bitmap: 1/22 pages [4KB], 65536KB chunk

Hmmm.  Slow as molasses.

> The device is still mounted and I can access all the data in it.

Probably not.  You are just seeing kernel block cache effects, I suspec=
t.

> At 18:55:24, I started my rebuild:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> Nov 18 18:55:24 DoctorBanner mdadm[1127]: RebuildStarted event detect=
ed on md device /dev/md126
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Uhm, what?  What command or action did you take?  Or are you simply
doing a "flashback" to the start of this process?

> Then 3 seconds later (18:55:27), the first =E2=80=9Creshape interrupt=
ed=E2=80=9D message appeared, but I didn=E2=80=99t notice, because the =
array was chugging along at 9KB/s according to /proc/mdstat:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> Nov 18 18:55:27 DoctorBanner kernel: [77563.553030] md: md126: reshap=
e interrupted.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> At some point before the following entries and after starting the res=
hape, I ran =E2=80=9Cecho 50000 > /proc/sys/dev/raid/speed_limit_min=E2=
=80=9D to help speed up the reshape, and so I think this is what starte=
d causing the issue.
>=20
> It continued to reshape for about 5 minutes, and then things got real=
ly ugly:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163377] ata7.00: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163382] ata7.01: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163384] ata7.02: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163385] ata7.03: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163386] ata7.04: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163388] ata7.05: failed t=
o read SCR 1 (Emask=3D0x40)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163392] ata7.15: exceptio=
n Emask 0x10 SAct 0x0 SErr 0x400000 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163394] ata7.15: irq_stat=
 0x08000000, interface fatal error
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163397] ata7.15: SError: =
{ Handshk }
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163399] ata7.00: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163402] ata7.00: failed c=
ommand: WRITE DMA EXT
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163406] ata7.00: cmd 35/0=
0:40:40:fd:56/00:05:00:00:00/e0 tag 23 dma 688128 out
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163406]          res 50/0=
0:00:7f:6b:6c/00:00:00:00:00/e0 Emask 0x100 (unknown error)
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163408] ata7.00: status: =
{ DRDY }
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163410] ata7.01: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163412] ata7.02: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163414] ata7.03: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163416] ata7.04: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163418] ata7.05: exceptio=
n Emask 0x100 SAct 0x0 SErr 0x0 action 0x6 frozen
> Nov 18 19:00:31 DoctorBanner kernel: [77868.163422] ata7.15: hard res=
etting link
> Nov 18 19:00:41 DoctorBanner kernel: [77878.160885] ata7.15: softrese=
t failed (1st FIS failed)
> Nov 18 19:00:41 DoctorBanner kernel: [77878.160893] ata7.15: hard res=
etting link
> Nov 18 19:00:51 DoctorBanner kernel: [77888.162415] ata7.15: softrese=
t failed (1st FIS failed)
> Nov 18 19:00:51 DoctorBanner kernel: [77888.162423] ata7.15: hard res=
etting link
> Nov 18 19:01:26 DoctorBanner kernel: [77923.153671] ata7.15: softrese=
t failed (1st FIS failed)
> Nov 18 19:01:26 DoctorBanner kernel: [77923.153679] ata7.15: limiting=
 SATA link speed to 1.5 Gbps
> Nov 18 19:01:26 DoctorBanner kernel: [77923.153683] ata7.15: hard res=
etting link
> Nov 18 19:01:31 DoctorBanner kernel: [77928.160337] ata7.15: softrese=
t failed (1st FIS failed)
> Nov 18 19:01:31 DoctorBanner kernel: [77928.160344] ata7.15: failed t=
o reset PMP, giving up
> Nov 18 19:01:31 DoctorBanner kernel: [77928.160347] ata7.15: Port Mul=
tiplier detaching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
>=20
> Which then proceeded to rejecting I/O and offlining devices (full sys=
log attached).
>=20
> I=E2=80=99m kind of alright with losing this one, since now I have a =
decent backup.  But is it even possible to recover from something like =
a failure this while it=E2=80=99s reshaping?

Stop the array completely.  Use --assemble --force with all of the
drives, including the new one.  Include the same --backup-file.

> I=E2=80=99m going to start chalking it up to the PCIe Port Multiplier=
 being the root of the problem.

Likely.  Are the port multipliers capable of the same speeds as the
drives and controllers?

> What do you guys think?

New enclosures & controllers so you can ditch the port multipliers?

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
