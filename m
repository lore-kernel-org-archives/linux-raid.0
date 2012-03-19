From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 regression: unrecoverable raids
Date: Mon, 19 Mar 2012 22:08:01 +1100
Message-ID: <20120319220801.23671fc5@notabene.brown>
References: <4F6711AB.7010906@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BqDAEjXO8zdODGHCUYjc7i8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F6711AB.7010906@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BqDAEjXO8zdODGHCUYjc7i8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Mar 2012 11:59:55 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Hi,
>=20
> commit 2bb77736ae5dca0a189829fbb7379d43364a9dac
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Jul 27 11:00:36 2011 +1000
>=20
>     md/raid10: Make use of new recovery_disabled handling
>=20
> Caused a serious regression making it impossible to recover certain o2
> layout raid10 arrays if they get enter a double degraded state.
>=20
> If I create an array like this:
>=20
> root@monkeybay ~]# mdadm --create /dev/md25 --raid-devices=3D4 --chunk=3D=
512
> --level=3Draid10 --layout=3Do2  --assume-clean  /dev/sda4 missing missing
> /dev/sdd4

o2 places data thus:

  A  B  C  D
  D  A  B  C

where columns are devices.

You've created an array with no place to store B.
mdadm or really shouldn't let you do that.  That is the bug.

> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md25 started.
>=20
> Then adding a spare like this:
> [root@monkeybay ~]# mdadm -a /dev/md25 /dev/sdb4
> mdadm: added /dev/sdb4
>=20
> The spare ends up being added into slot 4 rather than into the empty
> slot 1 and the array never rebuilds.

How could it rebuild?  There is nowhere to get B from.

I'm surprised this every "worked"... but maybe I'm missing something.

NeilBrown



>=20
> [root@monkeybay ~]# mdadm --detail /dev/md25
> /dev/md25:
>         Version : 1.2
>   Creation Time : Mon Mar 19 12:52:52 2012
>      Raid Level : raid10
>      Array Size : 39059456 (37.25 GiB 40.00 GB)
>   Used Dev Size : 19529728 (18.63 GiB 20.00 GB)
>    Raid Devices : 4
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Mar 19 12:52:56 2012
>           State : clean, degraded
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : offset=3D2
>      Chunk Size : 512K
>=20
>            Name : monkeybay:25  (local to host monkeybay)
>            UUID : afbf95cf:7015f3ff:a788bd4d:03b0fe32
>          Events : 7
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        4        0      active sync   /dev/sda4
>        1       0        0        1      removed
>        2       0        0        2      removed
>        3       8       52        3      active sync   /dev/sdd4
>=20
>        4       8       20        -      spare   /dev/sdb4
> [root@monkeybay ~]#
>=20
> This only seems to happen with o2 arrays, whereas n2 ones rebuild fine.
> I can reproduce the problem if I fail drives 0 and 3 or 1 and 2. Failing
> 1 and 3 or 2 and 4 works. The problem shows both when creating the array
> as above, or if creating it with all four drives and then failing them.
>=20
> I have been staring at this for a while, but it isn't quite obvious to
> me whether it is the recovery procedure that doesn't handle the double
> gap properly or whether it is the re-add that doesn't take the o2 layout
> into account properly.
>=20
> This is a fairly serious bug as once a raid hits this state, it is no
> longer possible to rebuild it even by adding more drives :(
>=20
> Neil. any idea what went wrong with the new bad block handling code in
> this case?
>=20
> Cheers,
> Jes
>=20
> dmesg output:
> md: bind<sda4>
> md: bind<sdd4>
> md/raid10:md25: active with 2 out of 4 devices
> md25: detected capacity change from 0 to 39996882944
>  md25:
> md: bind<sdb4>
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 1, wo:1, o:1, dev:sdb4
>  disk 3, wo:0, o:1, dev:sdd4
> md: recovery of RAID array md25
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for recovery.
> md: using 128k window, over a total of 19529728k.
> md/raid10:md25: insufficient working devices for recovery.
> md: md25: recovery done.
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 1, wo:1, o:1, dev:sdb4
>  disk 3, wo:0, o:1, dev:sdd4
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 3, wo:0, o:1, dev:sdd4
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 2, wo:1, o:1, dev:sdb4
>  disk 3, wo:0, o:1, dev:sdd4
> md: recovery of RAID array md25
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for recovery.
> md: using 128k window, over a total of 19529728k.
> md/raid10:md25: insufficient working devices for recovery.
> md: md25: recovery done.
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 2, wo:1, o:1, dev:sdb4
>  disk 3, wo:0, o:1, dev:sdd4
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 3, wo:0, o:1, dev:sdd4
> RAID10 conf printout:
>  --- wd:2 rd:4
>  disk 0, wo:0, o:1, dev:sda4
>  disk 3, wo:0, o:1, dev:sdd4


--Sig_/BqDAEjXO8zdODGHCUYjc7i8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2cTkTnsnt1WYoG5AQLCgw//aPdtKVogXE0fXP67hyeh6s0q3f4QQtzm
GzrRb4JQPUpycuz2Oj0znETmctIsWEKfAhqyxNnq2EtsGcWs22S5ajoRoAaXLSJa
1N7L/KI9miyI6Lth4jRrNIrz8zrwBs77yclX81EUAPw7NpNBeRQnOtvG04HB4g+1
xR6vGV4Pf1WgfcHidwKMWZjeub/egRLeazkMFBvfl6PLE2N7OajvqbwduR/FYE4b
kfSuC1E0jBWLAbXHw69hgIozzgc2fVLMuzAH5aeGKuMWz6XYFehuA3h8wGafAE+c
3clGLnERjpHrSHfxkZlUf2+1Pk7j/p03psaHinQFQmGWLi4hE9z+zU6IhZagxh3k
YCUc9dcycDngPd2FGOezJcs81yewSCEiwBxTeXZExFsCRkmStJp9fPtENMRiPH5h
NK6n1yxIY6EGgUBt6yP0fm2BMbSXlNq7WSXVx4VTf4zQq+BIFCn3jUMUo9Dg39E4
LfwvwoP+OtPPCW70lZvdgcs1LDBGxhgSIGp+gcRYwsYkme6OSDmcUgUvvjRm3mPi
Gl/lDZrp43VwL7XmqcuQhO4V/SFpy+qEXPkEfv9kg4Jio3FMHgS9auhV0qzGfZD1
jnTH6dOKVOOE/c8hNgp4qrghyT4KODao5Da6yU+rGiNu2iiaOulJiWu7TA7xnWB/
kPpIrKWYoTM=
=SzVf
-----END PGP SIGNATURE-----

--Sig_/BqDAEjXO8zdODGHCUYjc7i8--
