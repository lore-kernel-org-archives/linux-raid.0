From: NeilBrown <neilb@suse.de>
Subject: Re: Intel fakeraid working?
Date: Fri, 6 Apr 2012 09:25:40 +1000
Message-ID: <20120406092540.502c1948@notabene.brown>
References: <4F7CEDD0.9080904@ubuntu.com>
	<20120405111317.2a5227b1@notabene.brown>
	<4F7DE285.90503@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bnr6r214vsH52jXpnt4gunn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7DE285.90503@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/bnr6r214vsH52jXpnt4gunn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Apr 2012 14:20:53 -0400 Phillip Susi <psusi@ubuntu.com> wrote:

> On 4/4/2012 9:13 PM, NeilBrown wrote:
> > If the array was activated read-only, that suggests that 'mdmon' didn't=
 run.
> > mdmon is a daemon which monitors the array and updates the metadata as
> > needed.  until it is running it is not safe for the array to be writabl=
e.
> > However it should be started automatically by mdadm.
>=20
> That explains it... mdmon does not appear to have been added to the=20
> Ubuntu package.

oops...  :-(

>=20
> > How are you attempting to start the array?
>=20
> mdadm --activate --scan
>=20

I suspect you mean "mdadm --assemble --scan", but yes: that should work.

NeilBrown

--Sig_/bnr6r214vsH52jXpnt4gunn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT34p9Dnsnt1WYoG5AQI02xAAizDWiLuIm1t6oBOHh90h3YmUO0LF2mDv
eJgSNDyANbPVvccX0XUtq66UwHx+Jkof6tiW7JzzrGgDxbLJSXKtrWmnIOPMdoVQ
nwcSo+x6GgzVhBj9RhWFch5I3NCjOeDVDfnl3Ul3ERxzN472284pLu/IrAiN9E0A
wTMZMmv/1XT8T01Vct5g6lHzBEsk/QL/CaRanBmHkbyektSiZyoUu8KSgfYeW14w
Gf5iInRgXHduQsA436T+LgbTOh1o1WyFarESGYKRoADUwp3jYEKgEZJk1JRXkqiU
OwlE+neQL00FCCjxeA4rozR7CxO0B/qb790mzlsb1z3sNJTUuhS6Wpd5pHLKG8I9
vOHd1MLMCp/wWyusN509Yal5q3GNOuLvE/xKc/+wSeyRqLg38X6/UhsnI1HAewzJ
WSMPPPBy0NHLN8u38PyTRHlMv1QLp/N/qn6Cu+k+f9ESor9TnvQ10GbRbTNlXikM
PYZOuWyFpekzbiK6T5mqJNm6mIpMBlGqHMFxtYJXMHXJJeo+ZsCFkloXUBwvfg/9
sD3yOmL4gxl5iRnFFf9sawY+Ok0kyOPZc591uDQsCpd/2GuRdlSebP4sURNOiw5g
mDyTN2AR70cV6sm4SJYYMG9MtBfhwm6qzcSiBH66wvxyUiJaoAVV9er5aAAEHN/U
djv8oTGqsAE=
=71S+
-----END PGP SIGNATURE-----

--Sig_/bnr6r214vsH52jXpnt4gunn--
