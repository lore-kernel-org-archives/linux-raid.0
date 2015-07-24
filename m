From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Does sync_action repair raid6 zero mismatch_cnt?
Date: Fri, 24 Jul 2015 08:47:04 +0100
Message-ID: <20150724074704.GA24551@cthulhu.home.robinhill.me.uk>
References: <CAJ8DDcPoUayq2ucykkPVEYXyGpTVM-Cq3rzZ5mxitiP1tjH=DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ8DDcPoUayq2ucykkPVEYXyGpTVM-Cq3rzZ5mxitiP1tjH=DA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Bridges <john.bridges@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jul 23, 2015 at 06:07:34PM -0400, John Bridges wrote:

> I have had a problem with mismatch_cnt being huge (well over 500000) on a=
 raid6
>=20
> /dev/md2:
>         Version : 1.0
>   Creation Time : Mon Oct 15 20:55:58 2012
>      Raid Level : raid6
>      Array Size : 35163174912 (33534.22 GiB 36007.09 GB)
>   Used Dev Size : 2930264576 (2794.52 GiB 3000.59 GB)
>    Raid Devices : 14
>   Total Devices : 15
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Wed Jul 22 13:04:39 2015
>           State : active
>  Active Devices : 14
> Working Devices : 15
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : monster:2  (local to host monster)
>            UUID : c9f7456d:39b575fd:5d8e3791:54bffeae
>          Events : 459283
>=20
>     Number   Major   Minor   RaidDevice State
>       19      65      129        0      active sync   /dev/sdy1
>        1      65      145        1      active sync   /dev/sdz1
>       17      65       17        2      active sync   /dev/sdr1
>       12       8      193        3      active sync   /dev/sdm1
>        8      65        1        4      active sync   /dev/sdq1
>        5      65       65        5      active sync   /dev/sdu1
>        6      65       81        6      active sync   /dev/sdv1
>        7      65       97        7      active sync   /dev/sdw1
>       16       8      225        8      active sync   /dev/sdo1
>       18       8      209        9      active sync   /dev/sdn1
>       15       8      241       10      active sync   /dev/sdp1
>       14      65      113       11      active sync   /dev/sdx1
>       13      65      177       12      active sync   /dev/sdab1
>       20      65      161       13      active sync   /dev/sdaa1
>=20
>       21       8      177        -      spare   /dev/sdl1
>=20
>=20
> mdadm - v3.2.5 - 18th May 2012
>=20
>=20
> sync_action check did not fix it.
> I tried sync_action repair, still a huge number.
> Then I ran raid6check (built from latest mdadm source), took over a week =
to run.
> Found no errors, I was expecting a flaky drive since mismatch_cnt was so =
huge.
> raid6check does not update mismatch_cnt, so I did a sync_action check
> which finally zeroed the mismatch_cnt.
> I don't know if the newer raid6check fixed it or the repair?
>=20
> If mismatch_cnt is non zero on a raid6, do I need to do a repair and
> then a check? I thought repair would update mismatch_cnt.
>=20
>=20
> Does not inspire confidence.
>
Repair updates mismatch_cnt with the number of mismatches repaired, so
at the end this should equal the number reported by check. I would
always recommend re-running the check after a repair anyway.

That number of mismatches would suggest a major issue with your array
though. I would suggest checking SMART statistics and running full SMART
tests on all member disks.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlWx7XcACgkQShxCyD40xBL/GQCffr1pBoU70Faf6LZXA/5mpwZy
OHIAn2JMFzUwAYSGpVb6CEXiBaeSNRZ1
=Fhs1
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
