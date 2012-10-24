From: NeilBrown <neilb@suse.de>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Wed, 24 Oct 2012 16:14:40 +1100
Message-ID: <20121024161440.239ea8b8@notabene.brown>
References: <CACY-59cbWX9Gu_xsfqv_p8=Q7CabWZuj=ZH2K41j4N0-o-8WLw@mail.gmail.com>
	<2012102411171145340220@meganovo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2rGDIS//KivdiGzzhv5g0G="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012102411171145340220@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: hanguozhong <hanguozhong@meganovo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, stan <stan@hardwarefreak.com>
List-Id: linux-raid.ids

--Sig_/2rGDIS//KivdiGzzhv5g0G=
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Oct 2012 11:17:15 +0800 hanguozhong <hanguozhong@meganovo.com>
wrote:

> >From: GuoZhong Han
> >Date: 2012-10-10 10:44
> >To: linux-raid
> >Subject: task xfssyncd blocked while raid5 was in recovery
>  =20
> >Hello, every one:
> >Recently, a problem has troubled me for a long time.
> >I created a 4*2T (sda, sdb, sdc, sdd) raid5 with XFS file system, 128K c=
huck size and 2048 strip_cache_size. The mdadm 3.2.2, kernel 2.6.38 and mkf=
s.xfs 3.1.1 were used. When the raid5 was in >recovery and the schedule rea=
ched 47%, I/O errors occurred in sdb. The following was the output:
>=20
> >......
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >ata2: status=3D0x41 { DriveReady Error }
> >ata2: error=3D0x04 { DriveStatusError }
> >ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> >=A1=AD=A1=AD
> >d 0:0:1:0: [sdb]  Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> >sd 0:0:1:0: [sdb]  Sense Key : Aborted Command [current] [descriptor]
> >Descriptor sense data with sense descriptors (in hex):
> >        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
> >        00 00 00 f7=20
> > sd 0:0:1:0: [sdb]  Add. Sense: No additional sense information
> > sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 6f 4c cc 80 00 04 00 00
> > end_request: I/O error, dev sdb, sector 1867304064
> > hrtimer: interrupt took 28024956 ns
> > ata2: status=3D0x41 { DriveReady Error }
> > ata2: error=3D0x04 { DriveStatusError }
> > ata2: translatedserver RspCode F688 Ctrl 0 Idx A6F Len 70 ATA stat/err =
0x
> > 41/04 to SCSI SK00 00 64 65 35 64 62 65 65 31 3A 32 64 38 35 63 37 30 6=
3 3A 39 64 31 63 33 63 38 39 3A 32 32 64 39 32 65 32 31 00 00 00 00 00 00/A=
SC/ASCQ 0xb/00 /00
> > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2F=
 00 00 00 ata2: status=3D0x4
> > 1 { DriveReady Error }
> > ata2: error=3D0x04 { DriveStatusError }
> > ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> > sd 0:0:1:0: [sdb]  Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> > sd 0:0:1:0: [sdb]  Sense Key : Aborted Command [current] [descriptor]
> > Descriptor sense data with sense descriptors (in hex):
> >         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
> >         00 00 00 f7=20
> > sd 0:0:1:0: [sdb]  Add. Sense: No additional sense information
> > sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 6f 4c a4 80 00 04 00 00
> > end_request: I/O error, dev sdb, sector 1867293824
> > ata2: status=3D0x41 { DriveReady Error }
> > =A1=AD=A1=AD
>=20
> > Then, there were lots of error messages about the file system. The foll=
owing was the output:
>=20
> > ......
> > INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000
> >   frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)
> >   frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)
> >   frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp 0xfffffe=
008d7ffd18)
> >   frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)
> >   frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18)
> >   frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)
> >  frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe50)
> >   frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)
> >   frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)
> >   frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)
> >   frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)
> >   frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)
> >   frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80)
> >   frame 13: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp 0xffff=
fe008d7fffe8)
> > INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000
> >   frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)
> >   frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)
> >   frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp 0xfffffe=
008d7ffd18)
> >   frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)
> >   frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18)
> >   frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)
> >   frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe5=
0)
> >   frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)
> >   frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)
> >   frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)
> >   frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)
> >   frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)
> >   frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80)
> >   frame 13: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp 0xffff=
fe008d7fffe8)
> > INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000
> >   frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)
> >   frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)
> >   frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp 0xfffffe=
008d7ffd18)
> >   frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)
> >   frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18)
> >   frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)
> >   frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe5=
0)
> >   frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)
> >   frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)
> >   frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)
> >   frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)
> >   frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)
> >   frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80)
> > ......
>=20
> > The output said =A1=B0INFO: task xfssyncd/md127:1058 blocked for more t=
han 120 seconds=A1=B1. What did that mean? I used =A1=B0cat /proc/mdstat=A1=
=B1 to see the state of the raid5. The output was:
>=20
> > Personalities : [raid0] [raid6] [raid5] [raid4]=20
> > md127 : active raid5 sdd[3] sdc[2] sdb[1](F) sda[0]
> >       5860540032 blocks super 1.2 level 5, 128k chunk, algorithm 2 [4/3=
] [U_UU]
> >         resync=3DPENDING
>      =20
> > unused devices: <none>
>=20
> >      The state of the raid5 was =A1=B0PENDING=A1=B1. I had never seen s=
uch a state of raid5 before. After that, I wrote a program to access the ra=
id5, there was no response any more. Then I used =A1=B0ps aux| > task xfssy=
ncd=A1=B1 to see the state of =A1=B0xfssyncd=A1=B1. Unfortunately, there wa=
s no response yet. Then I tried =A1=B0ps aux=A1=B1. There were outputs, but=
 the program could exit with =A1=B0Ctrl+d=A1=B1 or =A1=B0Ctrl+z=A1=B1. And =
> when I tested the write performance for raid5, I/O errors often occurred.=
 I did not know why this I/O errors occurred so frequently.=20
> >      What was the problem? Can any one help me?
>=20
>       At first, I thought it was a bug of xfs filesystem. Then I change t=
he filesystem to ext4. I used sda, sdb, sdc and sdd to build a raid5 again.=
=20
>       When the raid5 was in recovery, I/O errors occurred in "sdb". And t=
he state of the raid5 tend to "PENDING" again.=20
>       I used "ps aux|grep 127" to see the status of the programs. The fol=
lowing were the outputs:
>=20
>       root      1197  0.0  0.0      0     0 ?        D    Oct23   0:03 [j=
bd2/md127-8]
>       root      1157 75.6  0.0      0     0 ?        R    Oct23 908:02 [m=
d127_raid5]
>       root      1159  1.2  0.0      0     0 ?        S    Oct23  14:36 [m=
d127_resync]
>       root      1381  0.0  0.0      0     0 ?        D    Oct23   0:12 [f=
lush-9:127]
>=20
>       The state of "md127_raid5", "jbd2/md127-8", "md127_resync", and "fl=
ush-9:127" did not change to other state when I used "ps aux|grep 127" many=
 times.
>       And the %cpu of "md127_raid5" had been the highest in about 75.6%. =
Programs to read and write to "md127" seemed hang, there was no response.
>       I has no other way, unless restart the machine.
>      =20
>       The following were the outputs of "smartctl -A /dev/sde":
>       # ./smartctl -A /dev/sde=20
>       smartctl 5.39.1 2010-01-28 r3054 [tilegx-unknown-linux-gnu] (local =
build)
>       Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourcefo=
rge.net
>=20
>       Probable ATA device behind a SAT layer
>       Try an additional '-d ata' or '-d sat' argument.
> =20
>       I use the tilera platform, the newest kernel I can update is 3.0.38=
. Now I try to update my kernel to this version.
>       But I do not know if this problem have fixed in 3.0.38. If you have=
 better solutions, please tell me.=20


Might be fixed by upstream commit:

commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
Author: Shaohua Li <shli@kernel.org>
Date:   Tue Jul 3 15:57:19 2012 +1000

    raid5: delayed stripe fix

which is in 3.0.38.
If it isn't that, I don't know what it is.

So it is worth trying 3.0.38.

NeilBrown

--Sig_/2rGDIS//KivdiGzzhv5g0G=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUId5QDnsnt1WYoG5AQLf5Q//b/CSmKN4eQfnxg32GWf21qJicwrCA8a6
DR4+fZjAQyeCGbTrNhtygymr4X0BQyGDGhyBToDtKT8xncgiL2hzU+vgLi2zP6aJ
ZSorIMPeI5k+9ntN+qCc9tva0wiT12Mvi8mIcbH4gQJeYY5rW899w6/EBJW72Ci7
BPI26v/k5GbK17CdI3FQF3nuM05zX+wlh8JMxbC2I7pzagWCxVBECP1K49JtG5xK
qeg/y7UPMPBdoQ1WrVyeOfSIf4HqQTpDcaYoftGqETgG2bNzW4VumTzUnXUk683k
15PptDFxS94UJAe8rYdmXP7dD0EfFk+kX8lZqmxKaGC/MLijNQjg+SHCbvt4ZgZo
u/aefjTiKbr6jl5m+Ai69hEIbWukwMTvfykEiyHa9+dM3UpDMz5McU5lj6daHVw0
JqjLdr9b2AskIyI2dn/VduYAfZkljPcGM++8HH/1jMLzG24NlvsqiIWsWY6zn6Ni
DAFO1uPxvJkFVa70A3Bd2GAndnb/YuelIZs/p67FxJHlwIf0Gn6tRi+cAkDsj1zQ
uECO8m3fttm8TIgBcTmuEZFKJOoOzCHBV/xlqxJ03HTtttJPJWsMWJQJR2FLGsVZ
fK2y3Mql8ZTd7Nt14sIs/OPeVVIe2eacOqwZj1oKeLolH2K/pZIetYRUT7eAfrPi
daCHnma4g0E=
=7Kri
-----END PGP SIGNATURE-----

--Sig_/2rGDIS//KivdiGzzhv5g0G=--
