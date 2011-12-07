From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 07:57:09 +1100
Message-ID: <20111208075709.587ac227@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qW.8EBeuMWvNM1i3FOC==Zl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qW.8EBeuMWvNM1i3FOC==Zl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 12:42:26 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

> Hi All,
>=20
>  I thought maybe someone could help me out. I have a 16 disk software RAI=
D that we use for backup. This is at least the second time this happened- a=
ll at once, four of the drives report as 'removed' when none of them actual=
ly were. These drives also disappeared from the 'lsscsi' list until I resta=
rted the disk expansion chassis where they live.=20
>=20
> These are the dreaded Caviar Green drives. We bought 16 of them as an upg=
rade for a hardware RAID originally, because the tech from that company sai=
d they would work fine. After running them for a while, four drives dropped=
 out of that array. So I put them in the software RAID expansion chassis th=
ey are in now, thinking I might have better luck. In this configuration, th=
is happened once before. That time, the drives looked to all have significa=
nt numbers of bad sectors, so I got those ones replaced and thought that th=
at might have been the problem all along. Now it has happened again. So I h=
ave two fairly predictable questions and I'm hoping someone might be able t=
o offer a suggestion:
>=20
> 1) Any ideas on how to get this array working again without starting from=
 scratch? It's all backup data, so it's not do or die, but it is also 30 TB=
 and I really don't want to rebuild the whole thing again from scratch.

1/ Stop the array
    mdadm -S /dev/md5

2/ Make sure you can read all of the devices
=20
    mdadm -E /dev/some-device

3/ When you are confident that the hardware is actually working, reassemble
   the array with --force

    mdadm -A /dev/md5 --force /dev/sd[a-o]1
(or whatever gets you a list of devices.)

>=20
> I tried the re-add command and the error was something like 'not allowed'
>=20
> 2) Any idea on how to stop this from happening again? I was thinking of p=
laying with the disk timeout in the OS (not the one on the drive firmware).=
=20

Cannot help there, sorry - and you really should solve this issue before you
put the array back together or it'll just all happen again.

NeilBrown

>=20
> If anyway can help, I'd greatly appreciate it, because, at this point, I =
have no idea what to do about this mess.=20
>=20
> Thanks!
>=20
> Eli
>=20
>=20
> [root@stratus ~]# mdadm --detail /dev/md5
> /dev/md5:
>         Version : 1.2
>   Creation Time : Wed Oct 12 16:32:41 2011
>      Raid Level : raid5
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 16
>   Total Devices : 13
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Dec  5 12:52:46 2011
>           State : active, FAILED, Not Started
>  Active Devices : 12
> Working Devices : 13
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc=
.edu)
>            UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
>          Events : 32
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       0        0        1      removed
>        2       8       33        2      active sync   /dev/sdc1
>        3       8       49        3      active sync   /dev/sdd1
>        4       8       65        4      active sync   /dev/sde1
>        5       8       81        5      active sync   /dev/sdf1
>        6       8       97        6      active sync   /dev/sdg1
>        7       8      113        7      active sync   /dev/sdh1
>        8       0        0        8      removed
>        9       8      145        9      active sync   /dev/sdj1
>       10       8      161       10      active sync   /dev/sdk1
>       11       8      177       11      active sync   /dev/sdl1
>       12       8      193       12      active sync   /dev/sdm1
>       13       8      209       13      active sync   /dev/sdn1
>       14       0        0       14      removed
>       15       0        0       15      removed
>=20
>       16       8      225        -      spare   /dev/sdo1
> [root@stratus ~]#=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/qW.8EBeuMWvNM1i3FOC==Zl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt/TMDnsnt1WYoG5AQJe6hAAutGSfNCmAIungv1c58HuJwKhAfyVVTvt
E/z7HwnTSPAH+SBqg8tBHl5TPT//mH6dhLib19t2D6D8ihJl7hdbX3+b7xWzLJLd
/pIt727CGhnEqr32xLFkCrtQQU1WLs09oz0rXvd+pYwF4NvJIAi8FLIa8MPo5fkn
LEoHzq2oF28McvIRc5YjyNT/MAw5+5S4JeTqLxhqfhTNs882+2yEZpqSN1P+BCn8
3ecsml8jsNV/ngAN8Q1dv44iNZunk6btfI3iTWfzr7V7He+FEN4STXzDYaKTqaHX
K0Ge8cwBAUiZ5AiEfKrFsl3y/xI+jirJ3cW9U94UWmhVvBGvqipoRd+WyKBSzoj6
1sAquYpIGsPXoI6ReEvISL6ArlgM1sK77+xF/7QMwAohZUjnoRHLS2LKs/H7wVfb
DCxaYJ+OcB+lE2dH1VYN+vLNVqLBBZvSlZ1ck2duG0s38VUeMBDNSWUrEN/js4pw
rT8L1iD+q/Wf3unQLEi//g18jGY9buu2BbJ8MysRXmZGzfFP2ckxfpmvpHm6aTNX
2awql3n0V0LK1jrKzughJgo5ewwAWPCvmOEfNUJacuQMnkM6R5jqgDhMph1GqF74
XbioGhuWJY+kGA6PUf36B4tUxT+zAj4tpvbL1WVoMCNJMQ2BQuY3DYFKFvrcHn4W
2YHXDuYQqKI=
=bU1M
-----END PGP SIGNATURE-----

--Sig_/qW.8EBeuMWvNM1i3FOC==Zl--
