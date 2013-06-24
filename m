From: NeilBrown <neilb@suse.de>
Subject: Re: Preparing for mdadm-3.3
Date: Tue, 25 Jun 2013 09:42:11 +1000
Message-ID: <20130625094211.20134bed@notabene.brown>
References: <20130624171818.71a9688a@notabene.brown>
	<wrfjli5zfq1c.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MIr4eLQFTefRfm2WGLYeNDV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjli5zfq1c.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/MIr4eLQFTefRfm2WGLYeNDV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Jun 2013 18:10:23 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > Hi all,
> >  it has been way too long since an mdadm release.  So I'm hoping to pul=
l one
> >  together over the next few weeks.  It will be mdadm-3.3
> >  My goal is to have it out by 25th July (i.e. one month).
>=20
> Hi Neil,
>=20
> I don't see any mention of hot replace support in your log. Did this get
> canned or did I just lose track of everything? Admittedly my marbles
> have gotten lost regularly the last couple of months.
>=20

Hi Jes,
 yes, hot replace support is something I should have mentioned but didn't

   mdadm /dev/md0 --replace /dev/foo

 will try to replace /dev/foo with a spare.

   mdadm /dev/md0 --replace /dev/foo --with /dev/bar

 will try to replace it with the spare "/dev/bar".

 Testing of that would be good too.
 I'll be sure to mention that in the 3.3 announcement.  Thanks.

NeilBrown


--Sig_/MIr4eLQFTefRfm2WGLYeNDV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcjZUznsnt1WYoG5AQJM8A//RjzCxKXi5t8drGXtG72xjFJnAxb6+nUa
6Sh/dDADKKiINAZ1rSWRDdkj7g2jKlaulnrJbsVpTgOTJPHU++rshulU1vFCx7XI
5tCt2qvftaNqqR1YMJVm2/+ExmupxRXo/kHONGz9mhOOyYkRYP/bRzqh5vVvoKAG
t/SC1P4kV6C+jn6rqg+FA9KBPRyFKI8TzIB2RxXP9UrD+XrieMVDC0KqgWhEA47L
ndgCjzjWI/cVIw35VPkOj6NGIajwnKGHZBK04cKfpEH5FIdie9VYeHqmfcGSdSV1
N2LnZBgWgu/Q/GWhtUWWsuhxMEVsmKBigaK+di/QZQuv3q8uJ9NKrDHDLbLCn1Im
R8Wkf1DbdDIyAnXkflzJtC/fu5lk0EJL5UjKMYy1QF7Z1wncoAiDXvk5vSE9mvqN
LHqnQ9yv0sIeXjJi0AURsOEyKnuzQ1kPjXqOSBi8ztn1d4S4Hg3z5MdJx4rgSpiv
kYbINI8890/O5a64RRJL9R4rSDhF2rjwIzS0sFa/qOOtHsJCiVHYKdhPeUGDxCeD
M8YN08GAKhCE5gdU5ztDXeQBHpt8k35Wp9J8Pl/mBJPnXG+Nt4hafZ1B1e8+NQDD
Rr3U87ToC/UCHiGZnexCBcejNstRmE7yrVG5WXTcQSuNICkvTZbZgBE8Hpv+COyw
5yADO55jqik=
=KkiS
-----END PGP SIGNATURE-----

--Sig_/MIr4eLQFTefRfm2WGLYeNDV--
