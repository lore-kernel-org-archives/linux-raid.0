From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: will mdadm work with a raid created using raidtools
Date: Thu, 16 Feb 2006 18:14:13 +0100
Message-ID: <20060216171413.GG8762@intoxicatedmind.net>
References: <43F37BFB.4030908@gmail.com> <17395.45134.227188.527148@cse.unsw.edu.au> <dt24uh$fv8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L+ofChggJdETEG3Y"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dt24uh$fv8$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2006 at 09:15:27AM -0600, Andrew Nelson wrote:
> Feb 14 21:58:36 localhost kernel: hde: dma_timer_expiry: dma status =3D=
=3D 0x21
> Feb 14 21:58:46 localhost kernel: hde: DMA timeout error
> Feb 14 21:58:46 localhost kernel: hde: dma timeout error: status=3D0x51 {=
 DriveRea
> dy SeekComplete Error }
> Feb 14 21:58:46 localhost kernel: hde: dma timeout error: error=3D0x40 { =
Uncorrect
> ableError }, LBAsect=3D1594001, high=3D0, low=3D1594001, sector=3D1593535
> Feb 14 21:58:46 localhost kernel: end_request: I/O error, dev hde, sector=
 159353
> 5
>=20
> Does anyone have any idea what I'm doing wrong?

It's probably not your fault - blame /dev/hde! This sounds like a bad
error on the disk - you should really get a new one, and try to copy
/dev/hde to the new disk (with dd_rescue for example). This _might_ save
the data.

Then you can try to create the array with the new disk and hope that
it will work.


Greetings,
Frank

--L+ofChggJdETEG3Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD9LLlcs96QQvy/noRAhSbAJsF1Ju6SZoRV5bPV4zJi9uIKP/EiQCeP3s9
y5MZQslPv5LuxuKvB+VOzSY=
=K/41
-----END PGP SIGNATURE-----

--L+ofChggJdETEG3Y--
