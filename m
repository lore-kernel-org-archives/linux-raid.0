From: NeilBrown <neilb@suse.de>
Subject: Re: Intel RAID problems
Date: Thu, 10 Nov 2011 21:29:44 +1100
Message-ID: <20111110212944.1cf98744@notabene.brown>
References: <CAGUTeF1qgu86YHXUQ3VGtQYM1akzXkrmuybRq-hPn-cM5+TL7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NrvZgRXwxk_8oFj0FoYVg9/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGUTeF1qgu86YHXUQ3VGtQYM1akzXkrmuybRq-hPn-cM5+TL7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Blair Strater <me@r000t.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NrvZgRXwxk_8oFj0FoYVg9/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Nov 2011 23:26:04 -0600 Blair Strater <me@r000t.com> wrote:

> Hello,
>=20
> In Windows, I created a RAID-5 array on my Intel Matrix Storage
> Manager compatible chipset. Across 5 500GB drives, I made a volume
> named VIDEODATA. It finished initializing on Windows and is currently
> in a Migrate state that will take a total of 36 to complete (so if
> that's the problem I'll just blow up the array and make a new one
> which will only take 12 hours to initialize).
>=20
> The array works fine in Windows but it will not work in Linux (Ubuntu
> 11.10 x64) under mdadm or dmraid. dmraid just creates a mapper that
> claims to have no partitions (an obvious lie), is reported as 2TB when
> the array is actually 1.8TB, and is generally useless.
>=20
> I tried to start the array in mdadm (after uninstalling dmraid and
> rebooting) but it thinks the array contains 5 spares. In 'disk
> utility', RAID array /dev/md127 is listed as "Not running, partially
> assembled".
>=20
> I'm very confused as to how to continue at this point.
>=20
> Here is some output someone told me the list would want:
>=20

Hi Blair,

 When mdadm manages an IMSM array it treats it as a 'container' and 1 or mo=
re
 'arrays'.
 What you see as /dev/md/imsm0 is the container.  It looks correct.
 You should see the array too:  /dev/md/VIDEODATA
 Do you see that?

 It is mentioned in the "-Asvv" output, but that doesn't look quite like wh=
at
 I would expect, so maybe you are running an older version of mdadm than the
 code I am looking at.
 What version do you have: "mdadm -V".

 If you don't have /dev/md/VIDEODATA, try:
    mdadm -Ivv /dev/md/imsm0
 and see what that results in.

 Also, what does=20
   cat /proc/mdstat

 show?
 Do you have an '/etc/mdadm.conf'?  If so, what is in it?

NeilBrown

> r000t@editsuite-linux:~$ sudo mdadm -Q /dev/md/imsm0
> /dev/md/imsm0: 0.00KiB (null) 0 devices, 5 spares. Use mdadm --detail
> for more detail.
>=20
>=20
>=20
> r000t@editsuite-linux:~$ sudo mdadm --detail-platform
>        Platform : Intel(R) Matrix Storage Manager
>         Version : 5.6.2.1002
>     RAID Levels : raid0 raid1 raid10 raid5
>     Chunk Sizes : 4k 8k 16k 32k 64k 128k
>       Max Disks : 6
>     Max Volumes : 2
>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
>           Port0 : /dev/sda (GTA400P6G02A8A)
>           Port1 : /dev/sdb (GTA400P6G03HKA)
>           Port2 : /dev/sdc (9QG2M7BR)
>           Port3 : /dev/sdd (9QG2NHD6)
>           Port4 : /dev/sde (9QG2SD30)
>           Port5 : /dev/sdf (6VPFRLN5)
>=20
>=20
>=20
> r000t@editsuite-linux:~$ sudo mdadm -Asvv
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/sdf6
> mdadm: /dev/sdf6 has wrong uuid.
> mdadm: cannot open device /dev/sdf5: Device or resource busy
> mdadm: /dev/sdf5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdf2
> mdadm: /dev/sdf2 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdf1
> mdadm: /dev/sdf1 has wrong uuid.
> mdadm: cannot open device /dev/sdf: Device or resource busy
> mdadm: /dev/sdf has wrong uuid.
> mdadm: cannot open device /dev/sde: Device or resource busy
> mdadm: /dev/sde has wrong uuid.
> mdadm: cannot open device /dev/sdd: Device or resource busy
> mdadm: /dev/sdd has wrong uuid.
> mdadm: cannot open device /dev/sdc: Device or resource busy
> mdadm: /dev/sdc has wrong uuid.
> mdadm: cannot open device /dev/sdb: Device or resource busy
> mdadm: /dev/sdb has wrong uuid.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm: /dev/sda has wrong uuid.
> mdadm: looking for devices for /dev/md/VIDEODATA
> mdadm: no recogniseable superblock on /dev/sdf6
> mdadm/dev/sdf6 is not a container, and one is required.
> mdadm: cannot open device /dev/sdf5: Device or resource busy
> mdadm/dev/sdf5 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/sdf2
> mdadm/dev/sdf2 is not a container, and one is required.
> mdadm: no recogniseable superblock on /dev/sdf1
> mdadm/dev/sdf1 is not a container, and one is required.
> mdadm: cannot open device /dev/sdf: Device or resource busy
> mdadm/dev/sdf is not a container, and one is required.
> mdadm: cannot open device /dev/sde: Device or resource busy
> mdadm/dev/sde is not a container, and one is required.
> mdadm: cannot open device /dev/sdd: Device or resource busy
> mdadm/dev/sdd is not a container, and one is required.
> mdadm: cannot open device /dev/sdc: Device or resource busy
> mdadm/dev/sdc is not a container, and one is required.
> mdadm: cannot open device /dev/sdb: Device or resource busy
> mdadm/dev/sdb is not a container, and one is required.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm/dev/sda is not a container, and one is required.
> r000t@editsuite-linux:~$
>=20
>=20
> r000t@editsuite-linux:~$ sudo mdadm -E /dev/sda /dev/sdb /dev/sdc
> /dev/sdd /dev/sde
> [sudo] password for r000t:
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.04
>     Orig Family : 00000000
>          Family : 07da212a
>      Generation : 00000221
>            UUID : a26d8bae:238c5fe7:ca705d0b:06559902
>        Checksum : 92cd3ca7 correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 1
>=20
>   Disk00 Serial : GTA400P6G02A8A
>           State : active
>              Id : 00000000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> [VIDEODATA]:
>            UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
>      RAID Level : 5
>         Members : 5
>           Slots : [UUUUU]
>       This Slot : 0
>      Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
>    Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
>   Sector Offset : 3840
>     Num Stripes : 7630848
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : general migration
>       Map State : normal <-- normal
>      Checkpoint : 7238714 (0)
>     Dirty State : clean
>=20
>   Disk01 Serial : GTA400P6G03HKA
>           State : active
>              Id : 00010000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk02 Serial : 9QG2M7BR
>           State : active
>              Id : 00020000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk03 Serial : 9QG2NHD6
>           State : active
>              Id : 00030000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk04 Serial : 9QG2SD30
>           State : active
>              Id : 00040000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.04
>     Orig Family : 00000000
>          Family : 07da212a
>      Generation : 00000221
>            UUID : a26d8bae:238c5fe7:ca705d0b:06559902
>        Checksum : 92cd3ca7 correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 1
>=20
>   Disk01 Serial : GTA400P6G03HKA
>           State : active
>              Id : 00010000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> [VIDEODATA]:
>            UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
>      RAID Level : 5
>         Members : 5
>           Slots : [UUUUU]
>       This Slot : 1
>      Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
>    Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
>   Sector Offset : 3840
>     Num Stripes : 7630848
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : general migration
>       Map State : normal <-- normal
>      Checkpoint : 7238714 (0)
>     Dirty State : clean
>=20
>   Disk00 Serial : GTA400P6G02A8A
>           State : active
>              Id : 00000000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk02 Serial : 9QG2M7BR
>           State : active
>              Id : 00020000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk03 Serial : 9QG2NHD6
>           State : active
>              Id : 00030000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk04 Serial : 9QG2SD30
>           State : active
>              Id : 00040000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.04
>     Orig Family : 00000000
>          Family : 07da212a
>      Generation : 00000221
>            UUID : a26d8bae:238c5fe7:ca705d0b:06559902
>        Checksum : 92cd3ca7 correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 1
>=20
>   Disk02 Serial : 9QG2M7BR
>           State : active
>              Id : 00020000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> [VIDEODATA]:
>            UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
>      RAID Level : 5
>         Members : 5
>           Slots : [UUUUU]
>       This Slot : 2
>      Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
>    Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
>   Sector Offset : 3840
>     Num Stripes : 7630848
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : general migration
>       Map State : normal <-- normal
>      Checkpoint : 7238714 (0)
>     Dirty State : clean
>=20
>   Disk00 Serial : GTA400P6G02A8A
>           State : active
>              Id : 00000000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk01 Serial : GTA400P6G03HKA
>           State : active
>              Id : 00010000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk03 Serial : 9QG2NHD6
>           State : active
>              Id : 00030000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk04 Serial : 9QG2SD30
>           State : active
>              Id : 00040000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
> /dev/sdd:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.04
>     Orig Family : 00000000
>          Family : 07da212a
>      Generation : 00000221
>            UUID : a26d8bae:238c5fe7:ca705d0b:06559902
>        Checksum : 92cd3ca7 correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 1
>=20
>   Disk03 Serial : 9QG2NHD6
>           State : active
>              Id : 00030000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> [VIDEODATA]:
>            UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
>      RAID Level : 5
>         Members : 5
>           Slots : [UUUUU]
>       This Slot : 3
>      Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
>    Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
>   Sector Offset : 3840
>     Num Stripes : 7630848
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : general migration
>       Map State : normal <-- normal
>      Checkpoint : 7238714 (0)
>     Dirty State : clean
>=20
>   Disk00 Serial : GTA400P6G02A8A
>           State : active
>              Id : 00000000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk01 Serial : GTA400P6G03HKA
>           State : active
>              Id : 00010000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk02 Serial : 9QG2M7BR
>           State : active
>              Id : 00020000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk04 Serial : 9QG2SD30
>           State : active
>              Id : 00040000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
> /dev/sde:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.2.04
>     Orig Family : 00000000
>          Family : 07da212a
>      Generation : 00000221
>            UUID : a26d8bae:238c5fe7:ca705d0b:06559902
>        Checksum : 92cd3ca7 correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 1
>=20
>   Disk04 Serial : 9QG2SD30
>           State : active
>              Id : 00040000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> [VIDEODATA]:
>            UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
>      RAID Level : 5
>         Members : 5
>           Slots : [UUUUU]
>       This Slot : 4
>      Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
>    Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
>   Sector Offset : 3840
>     Num Stripes : 7630848
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : general migration
>       Map State : normal <-- normal
>      Checkpoint : 7238714 (0)
>     Dirty State : clean
>=20
>   Disk00 Serial : GTA400P6G02A8A
>           State : active
>              Id : 00000000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk01 Serial : GTA400P6G03HKA
>           State : active
>              Id : 00010000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk02 Serial : 9QG2M7BR
>           State : active
>              Id : 00020000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
>   Disk03 Serial : 9QG2NHD6
>           State : active
>              Id : 00030000
>     Usable Size : 976768654 (465.76 GiB 500.11 GB)
>=20
> Thanks in advance for any help you guys may be able to provide.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/NrvZgRXwxk_8oFj0FoYVg9/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrunmDnsnt1WYoG5AQLI0BAAoKmytLSRj0dAfyagvMVJEV/RiBfAwzUq
6KmeO+HPEL7001d7W4Lv3TpTdM7rOOlrhOeHTQI/wL3GqwDki2vo3CaGYClkxxCr
DUBadSWa7pB8+Hp648iymhvcN/ibndTTPS4GjzXUfJoyYiP7gg9hMcz8UwAgw6B3
D1uHywhQFm3wKYCcvwyvXW4AXOjVDYwrmUR4RZjOCFUbEN/gkYnps5jkKNHHcrhW
UJAihXYnIDvKOTI7MwnS7nGpa72G/L5Di5vjVjkNtanmCfJoogKoWqfdeamdsGLD
2Ubui3u8Ug/Em9q14a/6RC4+kgS+MPgIHw3zaM5GY00ypYe0l5j376Aj2UlJGobC
l0NWD6+9tGywdzdAke2zZ/bHgb8UnQZJ06Xc1F8K9gtoEeo1m2EXL+xrQXNRZCGb
jnvDshBkK5wOWUA8REJMrQEBLYrG5q4MD0hiUI0btkU7lTFSUWfe6TaBRMMCCdfa
81khF+qxJb5+tTmZXVMloSdKxq76NpJNI2S+9159TzzXfklzjHuYRAmCmQZ84NTv
mOy6t/RpKMMEBMHvIIzd9hInrNaoETAJul5cafCcWaCTEjBJ0IeyMDdGqIlTBE57
zGX5EmO6oKTjkHHGeREimDCEtYATuk8Y9Y8qFdfaUzNequHkEsVrbSHMp7e8aZgQ
9Uax1h65xJM=
=zMy5
-----END PGP SIGNATURE-----

--Sig_/NrvZgRXwxk_8oFj0FoYVg9/--
