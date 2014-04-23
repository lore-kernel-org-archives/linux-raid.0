From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Wed, 23 Apr 2014 17:07:55 +1000
Message-ID: <20140423170755.1aa92ba6@notabene.brown>
References: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wkqVOVvdAKN0A47xSqNG44u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manibalan P <pmanibalan@amiindia.co.in>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/wkqVOVvdAKN0A47xSqNG44u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Apr 2014 17:41:12 +0530 "Manibalan P" <pmanibalan@amiindia.co.in>
wrote:

> Hi Neil,
>=20
> Also, I found the data corruption issue on RHEL 6.5.
>=20
> For your kind attention, I up-ported the md code [raid5.c + raid5.h]
> from FC11 kernel to CentOS 6.4, and there is no mis-compare with the
> up-ported code.

This narrows it down to between 2.6.29 and 2.6.32 - is that correct?

So it is probably the change to RAID6 to support async parity calculations.

Looking at the code always makes my head spin.

Dan : have you any ideas?

It seems that writing to a double-degraded RAID6 while it is recovering to
a space can trigger data corruption.

2.6.29 works
2.6.32 doesn't
3.8.0 still doesn't.

I suspect async parity calculations.

NeilBrown

--Sig_/wkqVOVvdAKN0A47xSqNG44u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1dmyznsnt1WYoG5AQL3rQ//QfLQaIkufM7zLf+kLZh7BTUxlSJ6+Ua1
/WNnpaaumjocpc+wx91fzq7obnbAsKHW1+WjjSOV+9r0DywC18vXbbl/dsIUhLRQ
4VmBeZig7CtsUwwPvxRR6ZBzg4y6UhM3iy9zhgb8LPK5A6AeH6HE85s6FEnXmGA1
GSPJTH9RljifOt4s9x1hKJ5hM7yYe3fyLUqPPPY/btiDtl2Ad5Wo2+qm4m3FzRJ6
cEApgAHaJbRw/q4OgzgPtlCFfUCWRLhShzVZBfMAGhYtNLQFCjiNJcePKoV+DgeK
JSP9xy1DNEbV7Umrc76iKzOKGLnl5ccR+7Y10DLxhUGUSZoPocNoBzZHVX08QUfl
PyW3plSxN146wWokMOZsD54YgiGpR8J9hBgzKCRhp3zaWEB5CBchbhk+BNdGqLw9
WvUYR/PokeYa9v8lqRq5JMiyvSTXP6m7B5nHTwfK4y3L5r9uYTyK9AW2WwugLDAb
+kGDsj4BrKjv02vvK0TmfOv4GEoBLJJQmJjuXiA364zL2tp4Qp46CT5HiPlN+Yk9
FiP2Quv4W1YhdOYpxjl3ziZgp8VzKqtAzDkWPqF1DWCYheRrXxoQKouEulWv48Px
UZyXBwjjE77RcSiln1r9ZcU5vM0KW9R59t0TQzViAz/4npBCv5E5NPmbd4O8uMtJ
ZXrV23RRoHk=
=zmcg
-----END PGP SIGNATURE-----

--Sig_/wkqVOVvdAKN0A47xSqNG44u--
