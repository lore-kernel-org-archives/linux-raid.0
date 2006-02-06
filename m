From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs running
Date: Sun, 05 Feb 2006 21:25:33 -0800
Message-ID: <43E6DDCD.7090007@ucolick.org>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com> <43E68D62.4080704@cogweb.net> <20060206035759.GB25631@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2CF2FA43F919252F379B26CE"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060206035759.GB25631@sam.triumf.ca>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2CF2FA43F919252F379B26CE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Konstantin Olchanski wrote:
>>Does anyone have an actual formula?
> 
> 
> I doubt it, because it requires measuring lifetimes, which takes
> years, by which time the data are useless because the disks you used
> are obsolete.

I found this article on drive reliability from Seagate:

http://www.digit-life.com/articles/storagereliability/

They do indeed model the temperature derating as an exponential, such
that 25C is the reference temp and at 30C the MTBF is reduced to 78%.
Running the drive at 40C gives you half the lifetime.

Can't find anything about spinup/down though, but they do talk about how
MTBF depends on power-on hours per year, which should be a correlated
quantity. They assume the MTBF goes *up* the fewer POH/yr the drive has,
there's never any reduction due to excessive spinup/down, or at least
the reduction is never dominant. They also talk about the effect of duty
cycle.

cheers,

/Patrik

--------------enig2CF2FA43F919252F379B26CE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD5t3ST+KvsdUW5p8RArzXAKCpB9c++tyAmf7TjVDnuXcTjjVHOgCfdln3
LXCvFPLw6XuEC3/L22h+kA0=
=foNT
-----END PGP SIGNATURE-----

--------------enig2CF2FA43F919252F379B26CE--
