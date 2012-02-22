From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Thu, 23 Feb 2012 09:04:12 +1100
Message-ID: <20120223090412.2b14fb7f@notabene.brown>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yxuHRlEf.z+3uBMi/H_Y6gk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yxuHRlEf.z+3uBMi/H_Y6gk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Feb 2012 17:59:59 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> I have seen this come up on the list a couple of times, and also had
> bugs filed over it, since this used to 'work'. Making the printed
> error message a little more explicit should hopefully make it clearer
> why this is being rejected.
>=20
> Thoughts?

While I'm always happy to make the error messages more helpful, I don't thi=
nk
this one does :-(

The reason for the change was that people seemed to often use "--add" when
what they really wanted was "--re-add".
--add will try --re-add first, but it if that doesn't succeed it would do t=
he
plain add and destroy the metadata.

So I introduced the requirement that if you want to destroy metadata, you
need to do it explicitly (and I know that won't stop people, but hopefully =
it
will slow them down).

Also, this is not at all specific to raid1 - it applies equally to
raid4/5/6/10.

NeilBrown

--Sig_/yxuHRlEf.z+3uBMi/H_Y6gk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0VmXDnsnt1WYoG5AQJh1hAAoaA7Bsfk8o9zlyFr1l8BJ5E25UeXlpbK
OXeMaViUEIqpuDEYhaV3lkL4inIETPqm4u2e2OvZ5rkVjJCH9Mpx0LP3xQGq9W6P
KmpjuOmAM8fjDOKui7Ar4II4tJxdrWZULzQfXajj+3s7Jc881cZIVtKN3/eGjZDF
LPqRlJCw739LD3/gLbz0EK87c+YBgqruKyq1LccmUIf5oOXkRNiGIkkJ0xWTZwa9
pJRHBWw6e3pAtm893GxTrInrCjnEHzgNDTgHyEz9F6RmX5vrksbbUn+7OEvI8mD4
CRgQrKPrVR8UjWAJHzggwe9LiGDlUaLVXoZnR1Wn2QijGM9h6krp2qlMtec61A7g
/00+czecESEZ5eIhw19zYK2ricJiiuFpVRlA7B5bcLibBlQQ07mp5O5XdHTJlx3l
PxDYRKytMlaQ6lCO8Mr8pp9jYH9Pq5hllhbkLJOjeJIQAP/tvSaRe9SeS6v0RYLC
yyV1e2kGGp7PFCxZQUJmZeqYjx+z22J2SYL4oUNrHvWM9vveJ02MZ6Fvnix5Tr6F
0thlMobj5gGGJv3LXS/Zihjdmn7JamKnMhWrbw6Rbrs5of4EzV1ZuDfDUpFwyDYM
/v/N5XmF/7TTjIU74Vnl82RWPZy1GKCjXsfi6pQwm/zRZaFOdj494W7/8bX4cuYI
TVvOFka63MI=
=BeM4
-----END PGP SIGNATURE-----

--Sig_/yxuHRlEf.z+3uBMi/H_Y6gk--
