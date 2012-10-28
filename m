From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 02:16:43 +0600
Message-ID: <20121029021643.1c9e3195@natsu>
References: <11510711257.20121028131527@oudeis.org>
	<DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com>
	<20121029015910.018efb17@natsu>
	<F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TfXRUlFAlP8v2IA2T9VEvie"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TfXRUlFAlP8v2IA2T9VEvie
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Oct 2012 14:10:00 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> >> not for RAID 5
> >=20
> >> RAID 5 implies 24x7=20
> >=20
> >> they're also not a 24x7 drive
> >=20
> > Wrong on pretty much all points. Or perhaps you are just way too easily
> > misguided by marketing b/s.
>=20
> I read their own published specs. Doesn't matter whether that piece is us=
ed predominantly by marketing or not, it is a defacto contract that cannot =
substantially depart from the legalized warranty verbiage.

I could not find any specs from WD where it would say that this particular
drive should be powered on for no more than X hours a day, and not 24x7.
Really, just downloaded the PDF and rechecked.

The closest thing I could find is [1], which after cutting out all the
"we really really want to sell you this enterprise drive for 1.5x as much"
boils down to describing the problem that dumb "hardware RAID" controllers
have with drives without TLER, an issue irrelevant to mdadm users. So,
anything else?

[1]
http://wdc.custhelp.com/app/answers/detail/a_id/1397/~/difference-between-d=
esktop-edition-(wd-blue,-wd-green-and-wd-black)-and-raid

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/TfXRUlFAlP8v2IA2T9VEvie
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCNkqsACgkQTLKSvz+PZwjgCQCgjbU1EQTSlbmCERm61AeBXBth
aWAAn3eJYVsNFky1j7Ws2oiwQTna6I/z
=NSRo
-----END PGP SIGNATURE-----

--Sig_/TfXRUlFAlP8v2IA2T9VEvie--
