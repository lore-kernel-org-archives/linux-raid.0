From: NeilBrown <neilb@suse.de>
Subject: Re: Interrupted reshape -- mangled backup ?
Date: Thu, 18 Oct 2012 09:33:38 +1100
Message-ID: <20121018093338.3026c803@notabene.brown>
References: <507F2462.2050409@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dsTnZV52YuO1pO3CPkXY3wW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <507F2462.2050409@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Haakon Alstadheim <hakon.alstadheim@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dsTnZV52YuO1pO3CPkXY3wW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Oct 2012 23:34:26 +0200 Haakon Alstadheim
<hakon.alstadheim@gmail.com> wrote:

> I have a Raid5 array with 4 devices that I wanted to see if I could get=20
> a better performance out of, so i tried changing the chunk size from 64K=
=20
> to something bigger. (famous last words) .  I got into some other=20
> trouble and thought I needed a reboot. On reboot I several times managed=
=20
> to mount and specify the device with my backup file during initramfs,=20
> but the reshape stopped every time once the system was at initialized.

So worst-case you can do that again, but insert a "sleep 365d" immediately
after the "mdadm --assemble" is run, so the system never completely
initialises.  Then just wait for the reshape to finish.

When mdadm assembles and array that needs to keep growing it will for a
background process to continue monitoring the reshape process.  Presumably
that background process is getting killed.  I don't know why.

>=20
> This is under debian sqeeze with a 3.2.0-0.bpo.3-686-pae kernel from=20
> backports. I installed mdadm from backports to get the latest version of=
=20
> that as well, and tried rebooting with --freeze-reshape. Suspect that I=20
> mixed up my initrd.img-files and started without --freeze-reshape the=20
> first time after installing the new mdadm. Now mdadm says it can not=20
> find a backup in my backup file. Opening up the backup in emacs, it=20
> seems to contain only NULs. Can't be right, can it? I have been mounting=
=20
> the backup under a directory under /dev/, on the assumption that the=20
> mount wold survive past the initramfs stage.

The backup file could certainly contain lots of nuls, but it shouldn't be
*all* nulls.  At least there should be a header at the start which describes
which area of the device is contained in the backup.

You can continue without a backup.  You still need to specify a backup file,
but if you add "--invalid-backup", it will continue even if the backup file
doesn't contain anything useful.
If the machine was shutdown by a crash during reshape you might suffer
corruption.  If it was a clean shutdown you won't.

--freeze-reshape is intended to be the way to handle this, with=20
   --grow --continue
once you are fully up and running, but I don't think that works correctly f=
or
'native' metadata yet - it was implemented with IMSM metadata in mind.

NeilBrown


>=20
> My bumbling has been happening with a current, correct,=20
> /etc/mdadm/mdadm.conf containigng:
> --------
> DEVICE /dev/sdh /dev/sde /dev/sdc /dev/sdd
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> HOMEHOST <system>
> ARRAY /dev/md1 level=3Draid5 num-devices=3D4=20
> UUID=3D583001c4:650dcf0c:404aaa6f:7fc38959 spare-group=3Dmain
> -------
> The show-stopper happened with an initramfs and a script in=20
> /scripts/local-top/mdadm along the lines of:
> -------
> /sbin/mdadm --assemble -f --backup-file=3D/dev/bak/md1-backup /dev/md1=20
> --run --auto=3Dyes /dev/sdh /dev/sde /dev/sdc /dev/sdd
> -------
>=20
> At times I have also had to use the env-variable MDADM_GROW_ALLOW_OLD=3D1
>=20
> Below is the output of mdadm -Evvvvs:
> --------
>=20
>=20
> /dev/sdh:
>            Magic : a92b4efc
>          Version : 0.91.00
>             UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
>    Creation Time : Wed Dec  3 19:45:33 2008
>       Raid Level : raid5
>    Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>       Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 1
>=20
>    Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
>    New Chunksize : 131072
>=20
>      Update Time : Wed Oct 17 02:15:53 2012
>            State : active
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 14da0760 - correct
>           Events : 778795
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>        Number   Major   Minor   RaidDevice State
> this     0       8      112        0      active sync   /dev/sdh
>=20
>     0     0       8      112        0      active sync   /dev/sdh
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       32        2      active sync   /dev/sdc
>     3     3       8       64        3      active sync   /dev/sde
> /dev/sde:
>            Magic : a92b4efc
>          Version : 0.91.00
>             UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
>    Creation Time : Wed Dec  3 19:45:33 2008
>       Raid Level : raid5
>    Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>       Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 1
>=20
>    Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
>    New Chunksize : 131072
>=20
>      Update Time : Wed Oct 17 02:15:53 2012
>            State : active
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 14da0736 - correct
>           Events : 778795
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>        Number   Major   Minor   RaidDevice State
> this     3       8       64        3      active sync   /dev/sde
>=20
>     0     0       8      112        0      active sync   /dev/sdh
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       32        2      active sync   /dev/sdc
>     3     3       8       64        3      active sync   /dev/sde
> /dev/sdc:
>            Magic : a92b4efc
>          Version : 0.91.00
>             UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
>    Creation Time : Wed Dec  3 19:45:33 2008
>       Raid Level : raid5
>    Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>       Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 1
>=20
>    Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
>    New Chunksize : 131072
>=20
>      Update Time : Wed Oct 17 02:15:53 2012
>            State : active
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 14da0714 - correct
>           Events : 778795
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>        Number   Major   Minor   RaidDevice State
> this     2       8       32        2      active sync   /dev/sdc
>=20
>     0     0       8      112        0      active sync   /dev/sdh
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       32        2      active sync   /dev/sdc
>     3     3       8       64        3      active sync   /dev/sde
> /dev/sdd:
>            Magic : a92b4efc
>          Version : 0.91.00
>             UUID : 583001c4:650dcf0c:404aaa6f:7fc38959
>    Creation Time : Wed Dec  3 19:45:33 2008
>       Raid Level : raid5
>    Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
>       Array Size : 2930287488 (2794.54 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 1
>=20
>    Reshape pos'n : 2368561152 (2258.84 GiB 2425.41 GB)
>    New Chunksize : 131072
>=20
>      Update Time : Wed Oct 17 02:15:53 2012
>            State : active
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 14da0722 - correct
>           Events : 778795
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>        Number   Major   Minor   RaidDevice State
> this     1       8       48        1      active sync   /dev/sdd
>=20
>     0     0       8      112        0      active sync   /dev/sdh
>     1     1       8       48        1      active sync   /dev/sdd
>     2     2       8       32        2      active sync   /dev/sdc
>     3     3       8       64        3      active sync   /dev/sde
> ---------------------------
>=20
> I guess the moral of all this is that if you want to use mdadm you=20
> should pay attention and not be in too much of a hurry :-/ .
> I'm just hoping that I can get my system back. This raid contains my=20
> entire system, and will take a LOT of work to recreate. Mail, calendars=20
> ... . Backups are a couple of weeks old ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/dsTnZV52YuO1pO3CPkXY3wW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUH8yQjnsnt1WYoG5AQJO6A/+KAZO/shGLJJToFRr6Ciqtwg/Ep6/EYIa
zXMTvvgv4x8JpTYUzfyQBP6kf0KH7JtnJRL+OsH0UeL9yoFbS/MGFO8MG/QQv05l
nydR1+500dztRP84YR5vHBtu60hVTg66+QpKpw16NYWllfcl/8ylCTesva6D5r5N
VmRKHF5zRDSyNQAAKN0DjSwpw6ve+Rkco+rwYrh8VTTzTmVUKBCkykAhIh/3Wdgt
6nFiCxMNx0R6+ZlDdEqVOQexY7cDQ9wsZvi0DqNDkx8BDmbgDklM46SzIudzql7p
2PeV6ZV5TMqjMyMqG6TsNCXQZbEgpjJ0EwGvFmgy9Ie0MKosenlPn+efoG5SEc3O
uV7FW6qsal1mI1HcIVnxIjQNQR3rvpLnnpKKuVoRMh+swoz7AGEdBM+nZntpowFV
1aQxcTS6ODVTT4kyerOC8qIOTPqxA5p/rb3+RriNlam2WpNE8Kw5yIcJnb9yUoMP
giiFiQ3t0XaiEwsVvvC7lmxNOZ0vM8RNxyUykVQEz2m9RW8j3GXWAZ9gwBuRR+F4
pw9Xfpr4XHR0V/xnA3oTk+oYuW9ufGC+/D5o9Wi3uOHNSE7rL+njxy6JgnpPBG7i
Tzn1BDXktPFpSatTIUw/LULLmD6jsEj8hiI7tf7ZjgVSvHTgpvdwCn72wdMlvI4l
eVCuZI38zmk=
=G1Qt
-----END PGP SIGNATURE-----

--Sig_/dsTnZV52YuO1pO3CPkXY3wW--
