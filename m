From: NeilBrown <neilb@suse.de>
Subject: Re: Possible leak during reshaping layout
Date: Mon, 21 Jul 2014 17:26:51 +1000
Message-ID: <20140721172651.1fcacfe7@notabene.brown>
References: <20140720052700.GB1838@batman-mbp.internally.la.gs>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kzL4Y7pOCUX=mIAuXJaKJa7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140720052700.GB1838@batman-mbp.internally.la.gs>
Sender: linux-raid-owner@vger.kernel.org
To: Kenny Root <kenny@the-b.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kzL4Y7pOCUX=mIAuXJaKJa7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2014 22:27:00 -0700 Kenny Root <kenny@the-b.org> wrote:

> I may have stumbled into a kernel memory leak during reshaping of a RAID =
10
> from offset to near layout:
>=20
> I have a RAID 10 array which was previously in offset layout. I decided to
> reshape to a near layout. Eventually the machine had become very sluggish,
> the load average shot up, and the reshape slowed down to nearly nothing.
>=20
>     md127 : active raid10 sdh1[2] sdk1[3] sdf1[0] sdg1[1]
>           7813771264 blocks super 1.2 512K chunks 2 near-copies [4/4] [UU=
UU]
>           [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  reshape =3D 49.5% (3=
872227840/7813771264) finish=3D63624.5min speed=3D1032K/sec
>=20
> A look at slabtop appears to show that there is an allocation that is
> larger than the physical RAM (16GB):
>=20
>      Active / Total Objects (% used)    : 61551490 / 61918456 (99.4%)
>      Active / Total Slabs (% used)      : 2209811 / 2209811 (100.0%)
>      Active / Total Caches (% used)     : 76 / 99 (76.8%)
>      Active / Total Size (% used)       : 15241504.92K / 15319798.41K (99=
.5%)
>      Minimum / Average / Maximum Object : 0.01K / 0.25K / 15.69K
>=20
>       OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>     60511744 60511219  29%    0.25K 2183366       32  17466928K kmalloc-2=
56
>     193408  82391  42%    0.06K   3022       64     12088K kmalloc-64
>     154880 129949  83%    0.03K   1210      128      4840K kmalloc-32
>     154624 152783  98%    0.01K    302      512      1208K kmalloc-8
>     144160 143412  99%    0.02K    848      170      3392K fsnotify_event=
_holder
>     125103  34053  27%    0.08K   2453       51      9812K selinux_inode_=
security
>=20

This very suspicious.
As you might imagine, it is not possible for a slab to use more memory than
is physically available.
It claims there are 60511219 active objects out of a total of 60511744.
I calculate that as 99.9999132%, but it suggests 29%.

If there were 32 OBJ/SLAB, then the slabs must be 8K.  This is possible, but
they are 4K on my machine, and all the other slabs you listed are too.

I've tried a similar reshape on 3.16-rc3 and there is no similar leak.

The only patch since 3.13 that could possibly be relevant is

commit cc13b1d1500656a20e41960668f3392dda9fa6e2
Author: NeilBrown <neilb@suse.de>
Date:   Mon May 5 13:34:37 2014 +1000

    md/raid10: call wait_barrier() for each request submitted.

That might fix a leak.  However the leak it might fix was introduced in
3.14-rc1:
    commit 20d0189b1012a37d2533a87fb451f7852f2418d1
        block: Introduce new bio_split()

So unless Fedora backported one of those but not the other I don't see how
this can be caused by RAID10.

What does /proc/slabinfo contain?  Maybe "slabtop" is presenting it poorly.

NeilBrown


> Output of mdadm -D:
>=20
> /dev/md127:
>         Version : 1.2
>   Creation Time : Wed Dec 20 19:41:25 2013
>      Raid Level : raid10
>      Array Size : 7813771264 (7451.79 GiB 8001.30 GB)
>   Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sat Jul 19 22:20:55 2014
>           State : active, reshaping
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : offset=3D2
>      Chunk Size : 512K
>=20
>  Reshape Status : 49% complete
>      New Layout : near=3D2, far=3D1
>=20
>            Name : local:home  (local to host local)
>            UUID : 3102a888:f08888a8:da88e888:c6288888
>          Events : 70841
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       81        0      active sync   /dev/sdf1
>        1       8       97        1      active sync   /dev/sdg1
>        2       8      113        2      active sync   /dev/sdh1
>        3       8      161        3      active sync   /dev/sdk1
>=20
> uname -r output:
> 3.13.6-200.fc20.x86_64
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/kzL4Y7pOCUX=mIAuXJaKJa7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8zAuznsnt1WYoG5AQINDw//UjhPmVg96tC6ORFpH0hrLJ18CEf8GjRt
XffFudq7HgmC5EjfxEE3D8VfKF1PxFOjnZZqXzt9CWmFLlUMkOKfXcngZGuEK6jw
hCX2cJ0KQtu55X12p88k+h02sydEfSVvhp9KBm9E/FaBZrcKCdEC3ipGmy4F80L3
xqWPsCUddh8uyUGJKNm0Xc9KaovL1pcBgh/r3+uf2Va6TigURmVi3pqF64GtdNsd
ykWHji+bRU7ygkzDfeVKkA3X0+1VhK9J/GAoBK9KozcgbAZ9CNyRwAXdI5EAenbv
F71bxSNEg6nVkS1+x0ADvpPaxgAVLkL9rygMqmkVr2HbcAStXcfrSO8jMD+0iSIb
eFG6Jz5mydVt2GO+TEfOgedoeIG7X9sNF+FhMiYzztAMlWALez6qwE31SQZOydhw
90LeHS/vAxRhia1+tIoIlXKxLyER/sjv97WFN1nBmNIa8M30JlG/Ru0BKpuF+tV9
MY0lg8DsPbNLO0jV+vlo8n2zHTzOdjWmQ30rMQb0sKmcCXadSvFu02CYeUZKZA71
UH8XFJKbpQbH1dwCtf9EMctQXidia/HFtpY69+n2EK7F40wAEwI42moC8ARvn/lF
9bW6d6QWpdVo4x0KCbfpezsm2oyLmMQejaSXznj8NOB/h35R3/R7VAKz1lLnSpcJ
NZGWflOvaZI=
=e7LQ
-----END PGP SIGNATURE-----

--Sig_/kzL4Y7pOCUX=mIAuXJaKJa7--
