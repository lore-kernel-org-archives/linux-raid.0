From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2 0/6] raid6: support read-modify-write
Date: Thu, 21 Aug 2014 14:58:08 +1000
Message-ID: <20140821145808.1ca8c5ee@notabene.brown>
References: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/jPla0fSUI2NA6aHJOPBMR6G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jPla0fSUI2NA6aHJOPBMR6G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2014 16:36:20 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> v2: reordering and merging of patches as Neil requested. More
> verification & benchmark numbers
>=20
> Once again thanks to an older patch from Kumar Sundararajan and=20
> Dan Williams that helped me to understand RAID6 logic inside md=20
> better. Everything is based on ideas & discussions that started
> with http://marc.info/?l=3Dlinux-raid&m=3D136624783417452&w=3D1
>=20
> Another try to implement RMW support for RAID6. This time improve
> syndrome calculation too. A few things to note:
>=20
> 1) Patches are based on official 3.16 kernel git.
>=20
> 2) The required optimized syndrome functions were implemented if
> possible. Generic & SSE2 are the ones that I could write & test
> on my machine. If you want to test/benchmark this patch ensure
> that you force select one of the two. Programmers with appropriate
> hardware in their hands are encouraged to send the missing=20
> algorithms.
>=20
> 3) raid6 test program was enhanced to verify algorithm correctness.=20
> Additionaly this release was checked with a self written single=20
> threaded test tool I called wprd (write predictable random data).
> Checked features include raid expansion, rebuild of failed drives,=20
> different RAID6 geometries, ... /dev/md0 and the underlying block
> devices contents were checked with sha256sum against an expected=20
> result of the unpatched module. Knock on wood so far no failures.
>=20
> 4) In between I was able to grab 10 older disk drives of different=20
> sizes and speeds and built a test rig. Simple RAID math should
> give 3read+3write I/Os for RMW and 7read+3write I/Os for RCW and
> thus a 66% improvement for write I/Os with a size smaller or
> equal to a single chunk. As you can see reality does not care=20
> about math but the effect is visible. Remember that larger arrays
> will show more speedups.
>=20
> 300 seconds random write with 8 threads
> 3,2TB (10*400GB) RAID6 64K chunk without spare=20
> group_thread_cnt=3D4
>=20
> bsize   rmw_level=3D1   rmw_level=3D0   rmw_level=3D1   rmw_level=3D0
>         skip_copy=3D1   skip_copy=3D1   skip_copy=3D0   skip_copy=3D0
>    4K      115 KB/s      141 KB/s      165 KB/s      140 KB/s
>    8K      225 KB/s      275 KB/s      324 KB/s      274 KB/s
>   16K      434 KB/s      536 KB/s      640 KB/s      534 KB/s
>   32K      751 KB/s    1,051 KB/s    1,234 KB/s    1,045 KB/s
>   64K    1,339 KB/s    1,958 KB/s    2,282 KB/s    1,962 KB/s
>  128K    2,673 KB/s    3,862 KB/s    4,113 KB/s    3,898 KB/s
>  256K    7,685 KB/s    7,539 KB/s    7,557 KB/s    7,638 KB/s
>  512K   19,556 KB/s   19,558 KB/s   19,652 KB/s   19,688 Kb/s
>=20
> Thanks Neil for your support.
>=20
> Markus
>=20

Thanks.  This looks a lot nicer.  If you resend them with the formatting a
s-o-b changes I mentioned I'll put them in my try and try to do some testing
and look at bits more closely.
Two things:
1/ I would be good to have performance numbers in the patch description for
   the patch that makes it all work.  Put yours there now, we can add other
   later..

2/ When you do a partial syndrome you specify a start and end.
   Is that really what is always wanted, or what is easiest?
   I imaging that you might want to "add" or "subtract" an arbitrary subset
   of blocks.  I imaging that the "blocks" array of pointers that is
   passing could have NULLs for the blocks to ignore and would include
   all others in the computation.
   Is there a good reason for not doing that.

Apart from the the code looks quite nice and clean .... though I don't seem
to be concentrating at my best today so I reserve the right to revise that
assessment at a later date :-)

Thanks,
NeilBrown

--Sig_/jPla0fSUI2NA6aHJOPBMR6G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/V8YDnsnt1WYoG5AQIfoA/9FpfPQMoHBt2p3yoIundZaNhhLgsDdl3N
I1A/tvKN/EIAHPnVzf9tVBPsXkgIpKAR/JYgst3AtKdvhZ0e7f2MRgV+u10dDeP8
02xNaj+WIcVBgvyLLNo0ECNcWhum8a5Ye+T8JlMkKDyBr16K/NK4D1bIVEsHXKyZ
9M6WCeAFKToQVPT0iEalbcgAC+mxkCjipk7F/znp/mNApkLR343uJR3gNVYTj1GK
JFKyhVApms6OCo1157BpNUVl3LulegV6AX8dJ/TBxa3WMDyCn/530tzKyGTw7qXr
wBqS+BTgiuwjgGMAeSbVwI9dMIvB/dbA9KikdFiojDFWwjb+93h7wyQCQRa8Dlat
u1xoc24OcfNE7XbddznaorBXS6dpGXRCT4D1pJpUjjMKHQeG9fjVhjxOipHx9fO5
WsEMs09DsHoFQqMcYYovRHx397TMkvKiqBiW87BkOn58IkcXLkfffupteHZAk8Mx
r2IqLELYZGnN2wvrtkkduikRagNOm5zicvu4RTRwaBtOlmHDVc8rTzKsspne+Ci4
6eFhCn07DwRY+V1UZKeZHsJzKpf1Y9VSjvjvBnmX54qcareaNtenu4mOT4Y6M8LX
edhVBkS2eFPXgS30tnprmWfpMADkLM0oG0UQi/dj9yUZUIef/XARElKM0FE3zzBu
FdKGCs5VI9g=
=1AQ5
-----END PGP SIGNATURE-----

--Sig_/jPla0fSUI2NA6aHJOPBMR6G--
