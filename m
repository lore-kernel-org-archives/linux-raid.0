From: Marc MERLIN <marc@merlins.org>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 20 Jun 2017 14:32:33 -0700
Message-ID: <20170620213233.GL14690@merlins.org>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org> <87r2yxdazc.fsf@notabene.neil.brown.name> <20170620182745.rbufznqe4tuxqttq@merlins.org> <20170620183154.GA5303@merlins.org> <87efue2x06.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87efue2x06.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21, 2017 at 07:02:33AM +1000, NeilBrown wrote:
> > The progress meter was wrong, it recovered in 3mn:
> > Jun 20 11:19:28 gargamel kernel: [  916.007017] md: recovery of RAID ar=
ray md8
> > Jun 20 11:22:41 gargamel kernel: [ 1108.395580] md: md8: recovery done.
>=20
> It is a progress bar - haven't you learned by now that they are *always*
> wrong :-)
>=20
> recovery always reports progress in sectors completed, and estimates
> time based on how many sectors were processes in the last 30 seconds,
> and how many are left.
>=20
> With a bitmap based recovery, most sectors are handled very quickly
> (instantly?), while some take milliseconds.  That makes the estimate
> imprecise.

Indeed.
Sorry that I jumped the gun, I think it looked like it was going to take
hours, and then it completed a few seconds after I had sent the Email.

Sorry for the noise, and obviously it's awesome that it worked so quickly
again
(been dealing with some unstable underlying SAS card that tends to kill
drives if the cable isn't plugged in perfectly after a good amount of
compressed air sent to the connector and the cable's plug)

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWUmUcH4xUKZ2O+kBAQJ54QP/VMYU4VeMhaZPB/9TuyKsU2VQNHPPo64u
gnCpF95yOYA3Oo+QsFURE24BnWq+EFOrlOTX7o65zAaYYbrCxCs5mEqJ/ifeIvZT
8ZyNiZvoWs0Mr4N1JH54nJrsL1gDl/lSl0uH/TExHtjwzDDDjNwBxZBToo/KwK3I
DDnsRTEo/3U=
=FEJy
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
