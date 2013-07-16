From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery possible after partial reshape failure?
Date: Tue, 16 Jul 2013 11:35:03 +1000
Message-ID: <20130716113503.6b254f4f@notabene.brown>
References: <CANb3qHfPELcUdFeAOzRaZNE2d4ZAS=8ZHNc6he0qbcRAibpTNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jpP5LNC1o.34QWfxIDU._UH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANb3qHfPELcUdFeAOzRaZNE2d4ZAS=8ZHNc6he0qbcRAibpTNA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veedar Hokstadt <veedar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jpP5LNC1o.34QWfxIDU._UH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jul 2013 16:01:20 -0400 Veedar Hokstadt <veedar@gmail.com> wrote:

> Hello, Please consider the following RAID5 recovery attempt after a
> failed partial reshape.

What were the sequence of events that lead to failure?


> Copy-on-write devices were created to protect original drives.
> Any assistance on how to reassemble would be most welcome.

As you say, it looks like sdf1 is confused somehow.  But it is your only
hope, so let's hope it isn't confused too much.  sdc is definitely not usef=
ul.

sdf1 has a 'recovery offset' which I wouldn't expect.  It lines up exactly
with the reshape position which suggests that it is spare which is being
rebuilt during the reshape process.
Did sdf1 fail and get re-added some time since the reshape started?

My guess is your best bet is to use a binary editor on the metadata in sdf1=
 -
it is 4K from the start of the device.
Change the feature map (8 bytes from start of block) from '6' to '4', to say
that the recovery has finished.

Then look at the "dev_roles" array for 16bit numbers, starting 256 bytes in=
to
the metadata.  This should be the same on each device.  The role '0' should
not be present (make it 0xffff if it is there) and 1,2,3,4,5 should all be
present.
Then look at the  'dev_number' field in sdf1 - 160 bytes into the metadata.
This 4byte number should be the index in dev_roles where '3' appears.

If you make those changes, then try to assemble again.  Hopefully it will
work....

NeilBrown



>=20
> ...Operating environment is from a systemrescuecd...
> % mdadm -V
> mdadm - v3.1.4 - 31st August 2010
> % /usr/local/sbin/mdadm -V    <<<<<< compiled latest by hand
> mdadm - v3.2.6 - 25th October 2012
> % uname -a
> Linux dallas 3.2.33-std311-amd64 #2 SMP Wed Oct 31 07:31:30 UTC 2012
> x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linux
>=20
> ...Drive /dev/mapper/cow_sdc1 appears damaged and goes offline
> sporadically, so I'm trying to reassemble with out sdc1...
> ...In any case sdc1 is out of sync with the other drives and it's
> reshape pos'n is at zero...
> ...Also /usb/foo is an empty file...
>=20
> % export MDADM_GROW_ALLOW_OLD=3D1
> % /usr/local/sbin/mdadm  -vv --assemble --force
> --backup-file=3D/usb/foo /dev/md2  /dev/mapper/cow_sdd1
> /dev/mapper/cow_sde1 /dev/mapper/cow_sdf1 /dev/mapper/cow_sdg1
> /dev/mapper/cow_sdh1
> mdadm: looking for devices for /dev/md2
> mdadm: /dev/mapper/cow_sdd1 is identified as a member of /dev/md2, slot 1.
> mdadm: /dev/mapper/cow_sde1 is identified as a member of /dev/md2, slot 2.
> mdadm: /dev/mapper/cow_sdf1 is identified as a member of /dev/md2, slot -=
1.
> mdadm: /dev/mapper/cow_sdg1 is identified as a member of /dev/md2, slot 4.
> mdadm: /dev/mapper/cow_sdh1 is identified as a member of /dev/md2, slot 5.
> mdadm:/dev/md2 has an active reshape - checking if critical section
> needs to be restored
> mdadm: Cannot read from /usb/foo
> mdadm: accepting backup with timestamp 1372908503 for array with
> timestamp 1373237070
> mdadm: backup-metadata found on device-5 but is not needed
> mdadm: No backup metadata on device-6
> mdadm: no uptodate device for slot 0 of /dev/md2
> mdadm: added /dev/mapper/cow_sde1 to /dev/md2 as 2
> mdadm: no uptodate device for slot 3 of /dev/md2
> mdadm: added /dev/mapper/cow_sdg1 to /dev/md2 as 4
> mdadm: added /dev/mapper/cow_sdh1 to /dev/md2 as 5
> mdadm: added /dev/mapper/cow_sdf1 to /dev/md2 as -1 (possibly out of date)
> mdadm: added /dev/mapper/cow_sdd1 to /dev/md2 as 1
> mdadm: /dev/md2 assembled from 4 drives - not enough to start the array.
>=20
> ...Noticed a difference to mdstat after --run, not sure if it is signific=
ant...
> % cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md2 : inactive dm-1[5](S) dm-5[4](S) dm-9[7](S) dm-7[6](S) dm-3[3](S)
>   <<<<<<<<<<<< note five (S)'s
>       14650675369 blocks super 1.2
> unused devices: <none>
> % /usr/local/sbin/mdadm -vv --run /dev/md2
> mdadm: failed to run array /dev/md2: Input/output error
> % cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md2 : inactive dm-1[5] dm-5[4](F) dm-9[7] dm-7[6] dm-3[3]
>     <<<<<<<<<<<< note difference
>       11720539894 blocks super 1.2
> unused devices: <none>
>=20
> ....Info from mdadm --examine...
> mdadm -E /dev/mapper/cow_sdc1 /dev/mapper/cow_sdd1
> /dev/mapper/cow_sde1 /dev/mapper/cow_sdf1 /dev/mapper/cow_sdg1
> /dev/mapper/cow_sdh1
>=20
> /dev/mapper/cow_sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5862022855 (2795.23 GiB 3001.36 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 9eacfd8d:92eb403b:4408be7f:601e36b5
>   Reshape pos'n : 0
> <<<<<< reshape at zero
>   Delta Devices : 1 (5->6)
>     Update Time : Thu Jul  4 03:27:43 2013                    <<<<<< out =
of sync
>        Checksum : 14fae7a3 - correct
>          Events : 125183
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/mapper/cow_sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5860270951 (2794.40 GiB 3000.46 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 81087206:02b470b1:6c06cb8b:63c79b21
>   Reshape pos'n : 12080240640 (11520.62 GiB 12370.17 GB)
>   Delta Devices : 1 (5->6)
>     Update Time : Sun Jul  7 22:44:30 2013
>        Checksum : 1c10ab66 - correct
>          Events : 125181
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : Active device 1
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/mapper/cow_sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : a7d341d2:392c9c31:0e28e8e2:865b56a9
>   Reshape pos'n : 12080240640 (11520.62 GiB 12370.17 GB)
>   Delta Devices : 1 (5->6)
>     Update Time : Sun Jul  7 22:44:30 2013
>        Checksum : 46e39caf - correct
>          Events : 125181
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : Active device 2
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/mapper/cow_sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x6
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5860270951 (2794.40 GiB 3000.46 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 4832096256 sectors
>           State : active
>     Device UUID : 332d8290:ec203a26:df299919:9f779aa7
>   Reshape pos'n : 12080240640 (11520.62 GiB 12370.17 GB)
>   Delta Devices : 1 (5->6)
>     Update Time : Sun Jul  7 22:45:42 2013
>        Checksum : 4eaf00f5 - correct
>          Events : 125183
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : spare
>    Array State : ...... ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/mapper/cow_sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5860270951 (2794.40 GiB 3000.46 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : ca37a376:12fa661f:844f2740:cab22de8
>   Reshape pos'n : 12080240640 (11520.62 GiB 12370.17 GB)
>   Delta Devices : 1 (5->6)
>     Update Time : Sun Jul  7 22:44:30 2013
>        Checksum : 7526553f - correct
>          Events : 125181
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : Active device 4
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/mapper/cow_sdh1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : a0071bbe:16fe9e3b:76ce40a8:754d0200
>            Name : tron:0
>   Creation Time : Sat Dec 22 23:26:19 2012
>      Raid Level : raid5
>    Raid Devices : 6
>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>      Array Size : 29301340160 (13971.97 GiB 15002.29 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : e02598c3:708630c9:e666b0cf:4189fbb0
>   Reshape pos'n : 12080240640 (11520.62 GiB 12370.17 GB)
>   Delta Devices : 1 (5->6)
>     Update Time : Sun Jul  7 22:44:30 2013
>        Checksum : c43bb5b6 - correct
>          Events : 125181
>          Layout : left-symmetric
>      Chunk Size : 512K
>    Device Role : Active device 5
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> ...Thank you for your help.  Veedar...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/jpP5LNC1o.34QWfxIDU._UH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeSjRznsnt1WYoG5AQL1TxAAmp7huR3dk/+XrVqbDItFuDNnhzXPiHWQ
jxEkLigRyoR8iNADBMVr8YU/VmRz6oS0dYkq0F5YUDeyT9qSBVCGkmR03RhHss3e
TMjxy5UqgsL9jWR58eEkagDBscVwQQFGMdscYE6FmsVvksX0jCEeMCLZHIfMmHn5
GwPZONBIv6kaipMqCpa1B+4L5PfYULUsEJZ5L25glj9mbNtWu4eYXkwpx5Z0YkWq
rE0Pf+BmUgdgyaq1r6ByXB785FLklcFNH5sU0qjGe3DGARh5bkv7LnUjtrgbn6Jv
iyHO2+XPMlNPlqp7Z6PG2TYPbqQIMFJBRHAUTOqjFvETDtDlaaAAEGqk9mEJA2gd
TJVhICosew9NCSw2p2U4WQ4heL4I/QktLr0NtD+TGH6h4YLNT4M06+JfI6r4btzi
MoXl8GdapfUZ6UAX8XpXvEF+8tcstSxQuBUPDn8h8er6yDfeUcfcq0nQVfJS8K7Z
Caf7zA1T0w+/uzSV+kZhDwbhXlwBchD0PbPhMTElaqz4YACyFxFOTJJZMWEnkGrY
dP8/6k5mzTzzZH0yWm+0sOYSNfS/H7fEJSWqma75RPga7CBQFXaDAcWlmv/7QwVg
aVF4qdDXbQl+FMgRGT5TxHX2w9n78Fp5Ia6fHJVXneJIv30658gvC7ZS4hAgcANb
G6iXTfBjpPw=
=XGu7
-----END PGP SIGNATURE-----

--Sig_/jpP5LNC1o.34QWfxIDU._UH--
