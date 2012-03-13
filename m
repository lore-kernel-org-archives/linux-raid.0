From: NeilBrown <neilb@suse.de>
Subject: Re: debugging md2_resync hang at raise_barrier
Date: Tue, 13 Mar 2012 11:16:33 +1100
Message-ID: <20120313111633.538c2cd2@notabene.brown>
References: <20120229184413.13db7143@bettercgi.com>
	<20120301123418.1254f763@notabene.brown>
	<20120312134603.703352b8@bettercgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AlP8ztSy_UjXmMlQLIxplaO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120312134603.703352b8@bettercgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ray Morris <support@bettercgi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AlP8ztSy_UjXmMlQLIxplaO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Mar 2012 13:46:03 -0500 Ray Morris <support@bettercgi.com> wrote:

> > On Wed, 29 Feb 2012 18:44:13 -0600 Ray Morris <support@bettercgi.com>
> > wrote:
> >=20
> > > I am attempting to debug a hang in raid1 and possibly one raid5.
>=20
>=20
> On Thu, 1 Mar 2012 12:34:18 +1100
> NeilBrown <neilb@suse.de> wrote:
>=20
> > I might know what is happening.
> >=20
> > It is kind-a complicated and involved the magic code in
> > block/blk-core.c:generic_make_request which turns recursive calls
> > into tail recursion.
> ...
> > This patch might fix it.  Maybe.  If it compiles.
>=20
> That appears to have solved it. Thanks so much. The delay in my
> response is because I wanted to give it some time to recur, as it
> didn't always manifest right away. Is there anything I should do
> regarding this path in future versions? Is this patch already in or
> planned to be in future versions, or should users possibly keep the
> patch on hand in case it's still needed later? Is there any testing
> or anything that I need to do to get included in future versions?
>=20
>=20

Thanks a lot.

I will probably submit this fix to Linus shortly after 3.3 is out, with a
request for it to be included in other -stable releases.

You seem to be using kernels from Redhat.  If you want them to include the
patch you should probably raise it as an issue with them.

Thanks,
NeilBrown

--Sig_/AlP8ztSy_UjXmMlQLIxplaO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT16R4Tnsnt1WYoG5AQJLvg//aEh0YoAPqgCsblhT913rnmZZaOaKE9ox
EuWTWq1TxDFiqicVdK7fGSFZcN/2kixUmp1SgrkmkbHyYfbEAmKr/KVcAsTT5DNw
AuborE4Qq/4jardOAQ5R/O6jUuAep54hzrabCaRMWYoPjQCwYbeR63yzq4BDr+65
wl0G+Z1Q/kVpbzQpnxCKAa8I4LSfFAjWUGNx4Xn7ICI7A35LVLw+i6mAeXj5yHih
GyPjbMazdNcYkzhZkTYIVUcd405GC/DMC8K59nRhAFlw2UrqJinSR8hLHwNZ2Ja+
AOe/tyPJpPjnVZmFJxem0Fjrm57p0+5qUbl2nZ2cfVzObJ0ecQHIUR9nxNZetYlX
DD6xnKAHYQxHoN2O1XTSXaY61KrYiJBNqNENVIyqZsXU9keRs1HeejZrKUtOJc36
JqJ6onTnh1T/33mUjzV3SkJqRZk2hph+eGOUYyycdzPvXUsU2auAEkf6ZtjTZZto
MADLOIY3tUL5i66F9wD28hexT72ej/0TDhHxwTREkXMj7Fs7I1/aNhYf84T0qMZj
Ou/kqcErKCPfWWLNHOMqmFQkljJjxbbVqjlozEzLFYdHltRyKaKBD8S44/Yr2f6/
/H/tnj/9Hkgxq5jZn8+d1JOp2DHDBYrVh4OCGe/zp4q2ItKFjd91bI/zuLdp1ecz
y0wHfakpOqc=
=oOpE
-----END PGP SIGNATURE-----

--Sig_/AlP8ztSy_UjXmMlQLIxplaO--
