From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm creates corrupt superblock
Date: Thu, 20 Nov 2014 08:47:09 +1100
Message-ID: <20141120084709.36583d80@notabene.brown>
References: <544FDB1C.5030306@hanswkraus.com>
	<20141029080019.272bc844@notabene.brown>
	<545157E4.3090204@hanswkraus.com>
	<546C68F9.7070307@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/76US1_5ug=kwj7t=Zr/GzLK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546C68F9.7070307@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/76US1_5ug=kwj7t=Zr/GzLK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2014 10:55:05 +0100 Hans Kraus <hans@hanswkraus.com> wrote:

> Hi,
>=20
> I think I found the problem. 'badblocks' reports sector 64 of the HD as
> errornous. But the HD neither reports a read error nor remaps that
> sector.
>=20
> Is it possible to parametrize mdadm that it doesn't use that sector?

I'm surprised that md is using sector 64.
The superblock is at sectors 8,9
The bitmap at 16..24, or something like that
The data is at 262144 onwards.

But that are offsets in sdb1, maybe the '64' is a sector number in 'sdb'.

Where does 'sdb1' start in 'sdb'??

NeilBrown


>=20
> Regards, Hans
>=20
> Am 29.10.2014 22:11, schrieb Hans Kraus:
> > Hi Neil,
> >
> > many thanks for your response. I rebooted the machine and got new drive
> > assignments. The drive in question is now sdc1. mdadm gave an error with
> > the dump, results below (nothing to report by dmesg) [by the way, I
> > wasn'nt even able to create an array on that drive with
> > 'mdadm --create --level=3D1 -n 2 /dev/sdc1 missing', same error(s)]:
> > -----------------------------------------------------------------------=
--
> > root@nashorn:~# mdadm -E /dev/sdb1
> > /dev/sdb1:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x1
> >       Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
> >             Name : nashorn:126  (local to host nashorn)
> >    Creation Time : Mon Oct 27 15:58:38 2014
> >       Raid Level : raid1
> >     Raid Devices : 2
> >
> >   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
> >       Array Size : 976630488 (931.39 GiB 1000.07 GB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D0 sectors
> >            State : clean
> >      Device UUID : f7a91c46:e4cda0c0:1b770fd7:876634f8
> >
> > Internal Bitmap : 8 sectors from superblock
> >      Update Time : Wed Oct 29 18:42:16 2014
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 939b22d1 - correct
> >           Events : 3325
> >
> >
> >     Device Role : Active device 0
> >     Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> > root@nashorn:~#
> > -----------------------------------------------------------------------=
--
> > root@nashorn:~# mdadm -E /dev/sdh1
> > /dev/sdh1:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x1
> >       Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
> >             Name : nashorn:126  (local to host nashorn)
> >    Creation Time : Mon Oct 27 15:58:38 2014
> >       Raid Level : raid1
> >     Raid Devices : 2
> >
> >   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
> >       Array Size : 976630488 (931.39 GiB 1000.07 GB)
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262046 sectors, after=3D0 sectors
> >            State : clean
> >      Device UUID : 089d1d0e:4d5ca222:dd716acb:0813815c
> >
> > Internal Bitmap : 8 sectors from superblock
> >      Update Time : Wed Oct 29 18:42:16 2014
> >    Bad Block Log : 512 entries available at offset 82 sectors
> >         Checksum : 16454b96 - correct
> >           Events : 3325
> >
> >
> >     Device Role : Active device 1
> >     Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> > root@nashorn:~#
> > -----------------------------------------------------------------------=
--
> > root@nashorn:~# mdadm -E /dev/sdc1
> > /dev/sdc1:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x1
> >       Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
> >             Name : nashorn:126  (local to host nashorn)
> >    Creation Time : Mon Oct 27 15:58:38 2014
> >       Raid Level : raid1
> >     Raid Devices : 2
> >
> >   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
> >       Array Size : 0
> >    Used Dev Size : 0
> >      Data Offset : 262144 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D262056 sectors, after=3D1953260976 sectors
> >            State : clean
> >      Device UUID : 4d1420c6:79978477:e86412b1:24beebfc
> >
> > Internal Bitmap : 8 sectors from superblock
> >      Update Time : Tue Oct 28 11:53:49 2014
> >    Bad Block Log : 512 entries available at offset 72 sectors
> >         Checksum : 6f02d040 - expected 891eedff
> >           Events : 0
> >
> >
> >     Device Role : spare
> >     Array State : RR ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> > -----------------------------------------------------------------------=
--
> > root@nashorn:~# mkdir -p /tmp/dump
> > root@nashorn:~# mdadm --dump /tmp/dump /dev/sdc1
> > mdadm: Failed to copy metadata from /dev/sdc1 to /tmp/dump/sdc1
> > -----------------------------------------------------------------------=
--
> > Kind regards, Hans
> >
> > Am 28.10.2014 22:00, schrieb NeilBrown:
> >> On Tue, 28 Oct 2014 19:06:20 +0100 Hans Kraus <hans@hanswkraus.com>
> >> wrote:
> >>
> >>> Hi,
> >>>
> >>> I debugged my problem a bit more: it seems that mdadm creates a defect
> >>> superblock. That's repeatedly happening, but only for one drive. I
> >>> copied zeros to that drive (via ddrescue /dev/zero ...) and the drive
> >>> looks OK. The info I got:
> >>>
> >>
> >> and you send me the metadata of all your devices please?
> >>
> >>     mkdir /tmp/dump
> >>     mdadm --dump /tmp/dump /dev/sde1
> >>     tar czvf /tmp/dump.tgz /tmp/dump
> >>
> >> and then send /tmp/dump.tgz
> >>
> >> Thanks.
> >>
> >> NeilBrown
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>> root@nashorn:/home/kraush/work/smartctrl# mdadm --zero-superblock
> >>> /dev/sde1
> >>> mdadm: Unrecognised md component device - /dev/sde1
> >>> root@nashorn:/home/kraush/work/smartctrl# mdadm --add /dev/md126
> >>> /dev/sde1
> >>> mdadm: add new device failed for /dev/sde1 as 4: Invalid argument
> >>> root@nashorn:/home/kraush/work/smartctrl# mdadm -E /dev/sde1
> >>> /dev/sde1:
> >>>             Magic : a92b4efc
> >>>           Version : 1.2
> >>>       Feature Map : 0x1
> >>>        Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
> >>>              Name : nashorn:126  (local to host nashorn)
> >>>     Creation Time : Mon Oct 27 15:58:38 2014
> >>>        Raid Level : raid1
> >>>      Raid Devices : 2
> >>>
> >>>    Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
> >>>        Array Size : 0
> >>>     Used Dev Size : 0
> >>>       Data Offset : 262144 sectors
> >>>      Super Offset : 8 sectors
> >>>      Unused Space : before=3D262056 sectors, after=3D1953260976 secto=
rs
> >>>             State : clean
> >>>       Device UUID : 4d1420c6:79978477:e86412b1:24beebfc
> >>>
> >>> Internal Bitmap : 8 sectors from superblock
> >>>       Update Time : Tue Oct 28 11:53:49 2014
> >>>     Bad Block Log : 512 entries available at offset 72 sectors
> >>>          Checksum : 6f02d040 - expected 891eedff
> >>>            Events : 0
> >>>
> >>>
> >>>      Device Role : spare
> >>>      Array State : RR ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> >>> root@nashorn:/home/kraush/work/smartctrl#
> >>> ---------------------------------------------------------------------=
--------------------------------------
> >>>
> >>> root@nashorn:/home/kraush/work/smartctrl# cat /proc/mdstat
> >>> Personalities : [raid1] [raid6] [raid5] [raid4]
> >>> md127 : active (auto-read-only) raid6 sda1[0] sdk1[6](S) sdl2[7](S)
> >>> sdh1[5] sdg1[4] sdf1[3] sdc1[2] sdb1[1]
> >>>         1953017856 blocks super 1.2 level 6, 512k chunk, algorithm 2
> >>> [6/6] [UUUUUU]
> >>>         bitmap: 0/4 pages [0KB], 65536KB chunk
> >>>
> >>> md10 : active (auto-read-only) raid1 sdi2[0] sdl3[1]
> >>>         87833408 blocks super 1.2 [2/2] [UU]
> >>>         bitmap: 0/1 pages [0KB], 65536KB chunk
> >>>
> >>> md126 : active raid1 sdd1[3] sdj1[2]
> >>>         488254464 blocks super 1.2 [2/2] [UU]
> >>>         bitmap: 0/4 pages [0KB], 65536KB chunk
> >>>
> >>> md0 : active raid1 sdl1[4] sdd2[3] sdi1[5]
> >>>         156157824 blocks super 1.2 [3/1] [U__]
> >>>         [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]=
  recovery =3D 95.6% (149290048/156157824)
> >>> finish=3D8.4min speed=3D13496K/sec
> >>>         bitmap: 1/2 pages [4KB], 65536KB chunk
> >>>
> >>> unused devices: <none>
> >>> root@nashorn:/home/kraush/work/smartctrl#
> >>> ---------------------------------------------------------------------=
--------------------------------------
> >>>
> >>> dmesg:
> >>> [33299.387382] md: invalid superblock checksum on sde1
> >>> [33299.387385] md: sde1 does not have a valid v1.2 superblock, not
> >>> importing!
> >>> [33299.387408] md: md_import_device returned -22
> >>> root@nashorn:/home/kraush/work/smartctrl#
> >>> ---------------------------------------------------------------------=
--------------------------------------
> >>>
> >>> root@nashorn:/home/kraush/work/mdadm# mdadm --version
> >>> mdadm - v3.3-161-gfed12d4 - 21st August 2014
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>
> >>>
> >>> Kind regards, Hans
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/76US1_5ug=kwj7t=Zr/GzLK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVG0P3Tnsnt1WYoG5AQImVhAAl985CZ2txegsGWP/do52YGcDqEdXncEv
Y6D2MipFKOMqtmjkxYHtjtEyiJAZ6rrGZMVm/5QHo0aozsqLZJxPAYQfO8HZGx4P
tqk3BG66dodUL50n+SKZY8jQ7qqjkqW/qNdihpjM57Ls7RkeE2qg87Sz0IQxchu4
7i+264bL+M3uHSIQfO32uKPxpprJQ1UbaQFEDru0BMupbZd24upGdYQ5HotqD8q5
w+IX8n16yonVC3ZkxkYxBbGoFa34OnIeHiFUrkBzNB1kDkTICWhPk4rFfti/uIFG
JZCOu8HMJbQNtodwC92GxZA9sAODAeo2Rgn/fuARXhcaT+GAlwU4Q3g6B45geMpq
TXPDDZveqG0MpfmFgiL7USxWITlDyZPLb4Tmw2AWEHihtMXX5e15ciIMW+WEzFM/
VPayuicfel/nCrciIQ2H0AqcXsYhOIBXwwjN7VHo3cAyNe+FoLGlr8rLCwmN9YBm
t8PcS/yGCqhZdmhMGXpyNj08nq5owNxHh85t0Jljyaoh2oTo/ph4sPl8VAQki7vY
QasYtQcHfV0iPWWGp37P/lJkaMbeXa8sC0FMr+WC9SoPtgBdsS5WcCdv937AzVPn
LfQCD/kthU+QOsXzmpZCLSWFNhRRR0OYw3sGBDCpJ8c52b1RZ0W7pqsvv9WFSN6U
FllrA5c0B2c=
=DRdz
-----END PGP SIGNATURE-----

--Sig_/76US1_5ug=kwj7t=Zr/GzLK--
