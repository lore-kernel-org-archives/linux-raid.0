From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to grow raid10 (error -22)
Date: Wed, 25 Apr 2012 20:56:56 +1000
Message-ID: <20120425205656.546af088@notabene.brown>
References: <4F97B003.1060201@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SJVMe+WWX6bL.NcnqhGCUKf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F97B003.1060201@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SJVMe+WWX6bL.NcnqhGCUKf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 10:04:19 +0200 Peter Rabbitson <rabbit+list@rabbit.us>
wrote:

> I am facing a problem which I believe is new (I distinctly remember
> doing the same on 2.6.somethingold couple years ago). When I try to
> grow an array where all memembers have been replaced with large ones
> I get an inexplicable.
>=20
>    kernel: md: couldn't update array info. -22
>=20
> Nothing else. I am using kernel 3.2.0 and mdadm 3.2.3, both from
> debian:
> http://packages.debian.org/sid/linux-image-3.2.0-2-amd64 (3.2.15-1)
> http://packages.debian.org/sid/mdadm (3.2.3-2)
>=20
> Here is my full test setup replicating the problem (was replicated
> on a different machine). Let me know if I can assist further in
> figuring this out:
>=20
> root@Thesaurus:~/raidfail# for n in $(seq 4) ; do dd if=3D/dev/zero of=3D=
member_$n.img bs=3D1M count=3D256 ; done
>=20
> root@Thesaurus:~/raidfail# for n in $(seq 4) ; do losetup /dev/loop$n mem=
ber_$n.img ; done
>=20
> root@Thesaurus:~/raidfail# losetup -a
> /dev/loop1: [fd01]:1081442 (/root/raidfail/member_1.img)
> /dev/loop2: [fd01]:1081481 (/root/raidfail/member_2.img)
> /dev/loop3: [fd01]:1081483 (/root/raidfail/member_3.img)
> /dev/loop4: [fd01]:1081515 (/root/raidfail/member_4.img)
>=20
> root@Thesaurus:~/raidfail# mdadm -C /dev/md1010 -l 10 -p f3 -n 4 -c 256 -=
e 1.2 -z 128M /dev/loop[1234]
> mdadm: largest drive (/dev/loop1) exceeds size (131072K) by more than 1%
> Continue creating array? y
> mdadm: array /dev/md1010 started.
>=20
> root@Thesaurus:~/raidfail# mdadm -w /dev/md1010
>=20
> root@Thesaurus:~/raidfail# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
> md1010 : active raid10 loop4[3] loop3[2] loop2[1] loop1[0]
>        174080 blocks super 1.2 256K chunks 3 far-copies [4/4] [UUUU]
                                             ^^^^^^^^^^^^

You cannot resize a 'far' RAID10.
In fact in 3.2 you cannot resize *any* RAID10.  That is only available in
3.4-rc, and even then only for 'near' and 'offset' layouts.



>=20
> (Note - no bitmaps, no anything)
>=20
> root@Thesaurus:~/raidfail# mdadm --grow --size=3Dmax /dev/md1010
> mdadm: Cannot set device size for /dev/md1010: Invalid argument

So here, "Invalid argument" means you asked it to do something that it cann=
ot
do - your request was invalid.

NeilBrown



>=20
>=20
> root@Thesaurus:~/raidfail# tail /var/log/kern.log
> Apr 25 09:52:36 localhost kernel: md: using maximum available idle IO ban=
dwidth (but not more than 30000 KB/sec) for resync.
> Apr 25 09:52:36 localhost kernel: md: using 128k window, over a total of =
174080k.
> Apr 25 09:52:42 localhost kernel: md: md1010: resync done.
> Apr 25 09:52:43 localhost kernel: RAID10 conf printout:
> Apr 25 09:52:43 localhost kernel: --- wd:4 rd:4
> Apr 25 09:52:43 localhost kernel: disk 0, wo:0, o:1, dev:loop1
> Apr 25 09:52:43 localhost kernel: disk 1, wo:0, o:1, dev:loop2
> Apr 25 09:52:43 localhost kernel: disk 2, wo:0, o:1, dev:loop3
> Apr 25 09:52:43 localhost kernel: disk 3, wo:0, o:1, dev:loop4
> Apr 25 09:53:39 localhost kernel: md: couldn't update array info. -22
>=20
>=20
> root@Thesaurus:~/raidfail# mdadm -D /dev/md1010
> /dev/md1010:
>          Version : 1.2
>    Creation Time : Wed Apr 25 09:52:24 2012
>       Raid Level : raid10
>       Array Size : 174080 (170.03 MiB 178.26 MB)
>    Used Dev Size : 130560 (127.52 MiB 133.69 MB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>=20
>      Update Time : Wed Apr 25 09:52:43 2012
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : far=3D3
>       Chunk Size : 256K
>=20
>             Name : Thesaurus:1010  (local to host Thesaurus)
>             UUID : 19aeca84:142ee179:b344a19d:08a730fc
>           Events : 17
>=20
>      Number   Major   Minor   RaidDevice State
>         0       7        1        0      active sync   /dev/loop1
>         1       7        2        1      active sync   /dev/loop2
>         2       7        3        2      active sync   /dev/loop3
>         3       7        4        3      active sync   /dev/loop4
>=20
> root@Thesaurus:~/raidfail# mdadm -E /dev/loop1
> /dev/loop1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 19aeca84:142ee179:b344a19d:08a730fc
>             Name : Thesaurus:1010  (local to host Thesaurus)
>    Creation Time : Wed Apr 25 09:52:24 2012
>       Raid Level : raid10
>     Raid Devices : 4
>=20
>   Avail Dev Size : 522240 (255.04 MiB 267.39 MB)
>       Array Size : 261120 (127.52 MiB 133.69 MB)
>    Used Dev Size : 261120 (127.52 MiB 133.69 MB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : d7734a6c:5df0c7cc:b5f7dc04:6595a5eb
>=20
>      Update Time : Wed Apr 25 09:53:05 2012
>         Checksum : 22c8ad18 - correct
>           Events : 17
>=20
>           Layout : far=3D3
>       Chunk Size : 256K
>=20
>     Device Role : Active device 0
>     Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/SJVMe+WWX6bL.NcnqhGCUKf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fYeDnsnt1WYoG5AQJP1hAAwrHyhG2FIwbx+jvlNExLHKh9qsLI+xsc
/GCzuHHzgCV4y96nfXhFG4Iu46L1vq+bW/lReyGhY2nyMYDsPRtLtsqojvzSGuxX
gFEBaHldOSmdyd3DMfWv5tYwN6eAA2cGWZ6gdoOKIFvMBWt3fkcnUaSgMlkIu4Wr
OtLdyVSWF1iTr7Rn26mS2pM6PLsVI+bsjoAi2CR9S22UFeLAwTQquNAoR4N+2pig
VBkUsJUwb6xT2NdSwxAxdSDYBfRf2xsOOTqXEwhVMwh7Zv6FgpRDOnJ4YsLYBZGE
P6BXZ//O9mHOxkXeF38ZICM6PLBq/MFRi33vuxpNizOmVhhXnpSVAYkv6NgPD+vZ
UoV4cPtbyELSvGfe6r94YPc/7i5r3lJ38lYQckGAzBGcRHOwgIW4Jo8KEe/B5f9B
9NxhGAlfbqKZSjDICw3exROVhdmpMtOUFpuDcdKb0tvfB92nfvUr56UF/0nlaYWo
Kj3iuovZVJXMjqzl/JTFkgXDaidpxZB2VrqFY0PwcBOCxRHaPZ05NoPgXoV3CSKZ
vnk3EWl9q83ubskS2DblhrNazQ1IchAMi08AyV6e8yju9QIexKBp4YXjcB97I5CD
JB3FBW326XQ8FdC31+3/HYWW8WOmnBylszPRVuzl1lfulRVUemiN9om8+Q8atT8l
xBi4yBOTJuk=
=1Aj+
-----END PGP SIGNATURE-----

--Sig_/SJVMe+WWX6bL.NcnqhGCUKf--
