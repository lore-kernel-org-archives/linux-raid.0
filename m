From: NeilBrown <neilb@suse.de>
Subject: Re: Intel fakeraid working?
Date: Fri, 6 Apr 2012 09:24:28 +1000
Message-ID: <20120406092428.1090e10b@notabene.brown>
References: <4F7CEDD0.9080904@ubuntu.com>
	<20120405111317.2a5227b1@notabene.brown>
	<4F7DE314.9040306@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SaHsYSLESmFY6dYcUrV/Qs0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7DE314.9040306@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SaHsYSLESmFY6dYcUrV/Qs0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Apr 2012 14:23:16 -0400 Phillip Susi <psusi@ubuntu.com> wrote:

> On 4/4/2012 9:13 PM, NeilBrown wrote:
> >
> > That bug is fixed by
> >
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcomm=
itdiff;h=3Dc744a65c1e2d59acc54333ce80a5b0702a98010b
> >
> > and is not specific to Intel IMSM RAID.
>=20
> That commit appears to have to do with shutdown, but this did not happen=
=20
> during shutdown.  I suppose it happened as a result of the array being=20
> stuck in read only mode due to the missing mdmon.
>=20

Yes, you are right - I read too hastily.

Something wrote to the md device despite it being marked 'read-only'.
Some filesystems do that to replay their journal.  totally inexcusable
behaviour, but what can we do....

I'm surprised that would happen during installation though.
But certainly the array is marked read-only, and certainly something is
writing to it, and that is the real bug.

NeilBrown

--Sig_/SaHsYSLESmFY6dYcUrV/Qs0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT34prDnsnt1WYoG5AQI4/A//TqAEZq4F42yUzu/PkERtO2omC6iqIIdt
/OHMyyQdFGNC8qXTpYP4UvpO2DxXHN1Zi29mmZNvPfgIUAkQcTZN6YEPHsxVXUbu
n8oBU7VXtOejPlpX3DMOVRC6tcG93EgB/3tYUFQmxDoPeAKKK43pjHaAxtezaVpY
2/+7EVyGO+Moa5iqyTRPgm2YfKrnT9uWY0H+G6Q6rox1XCSvj7p3EWQknw/bO8xv
ej5kK3vsUcpD6qZXrkb26G+bXUR7raDzP9hLxe3lZ+JIUZ/SEdye8xLzAyXMKTq8
z5flvrPUhrUdsehMT+332sIUikMSxbqObJbLYyxnM37ARPxA+36vTn0Wh6y+qRBp
OYWHyj5rvAjBh7e+AkPtT54llKggSXHYqKaTp3a6LSIisHxzmBHNLg9/DVUjpnvV
+O+tZVPRcZYvr9Lsf1/9ZPw6Mphq2D4tXmterHXWYjuh93m4AQCAWzwTtViBSwQZ
yyZ+0099b8rqgr3yfkYaX/UFn+qBX2V0htxpLDW1FQaTf1Bj55iErlkZGYyPfMEB
VnoCpgNRyZKAihKrZeccrvNl/JI3gfDpl9JtyjRtYsHi8Y3UuATCVc8mYieXXvus
DFYroSQaw86A0ocFzcuLbJCABPZolqmAgfRU9BiSF9mR/628qFHMGw5IVIfk5uh+
Ji5nUe9L9Bg=
=nrHc
-----END PGP SIGNATURE-----

--Sig_/SaHsYSLESmFY6dYcUrV/Qs0--
