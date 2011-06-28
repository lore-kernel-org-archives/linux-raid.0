From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Software RAID and TRIM
Date: Tue, 28 Jun 2011 18:17:35 +0200
Message-ID: <20110628161735.GA15599@vault>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tom,
On Tue, Jun 28, 2011 at 04:31:35PM +0100, Tom De Mulder wrote:
> Hi,
> [...]
> Is this something that's in the works?

Iirc, dm-raid supports passthru of DSM/TRIM commands for its provided RAID0
and RAID1 levels. Maybe that's already enough for your purposes?

I don't know if there's any development going on on the md side of things in
in that regard. Others on this list will surely be able to answer that
question, however.

Have a nice day!
--=20
with best regards:=20
- Johannes Truschnigg ( johannes@truschnigg.info )

www:  http://johannes.truschnigg.info/=20
phone: +43 650 2 133337=20
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4J/p4ACgkQnnUApj8OcoJy0ACgkWRuAysq3rHCVoD9UwY1rT0/
tUwAoJ74fzFryQUAqlCYNDVBdlZQUWpD
=YZ3W
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
