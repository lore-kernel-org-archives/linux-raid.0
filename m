From: Andre Noll <maan@systemlinux.org>
Subject: Re: Minor mdadm fixes
Date: Tue, 12 Jan 2010 04:10:27 +0100
Message-ID: <20100112031027.GL7517@skl-net.de>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:49, Mr. James W. Laferriere wrote:
> 	Hello Doug ,
>=20
> On Mon, 11 Jan 2010, Doug Ledford wrote:
> >These are a number of minor fixes we carry in our mdadm at the moment. =
=20
> >Would
> >prefer not to carry them ourselves ;-)
> >
> >Neil, any clue when you think might release mdadm-3.1.2?
> 	Would you please annotate the git diffs you sent out ?
> 	For one I am very confused about the change of
>=20
> -       sprintf(path, "/var/run/mdadm/%s.pid", devname);
> +       sprintf(path, "/dev/.mdadm/%s.pid", devname);
>=20
> 	why ?  For one .
>=20
> 	None of the other patches has a annotation either .  While if one is=20
> 	a kernel coding guru they are probably very readable .  I am not but wou=
ld=20
> like to know what the intention is for the change(s) .

The annotation is the subject line :)

Before switching root it is sometimes desirable to mount --bind (or
--move) the current /dev into the new root as the programs started
=66rom the new root will need the device nodes. For example the init
scripts that run from the intramfs move /dev after it has been mounted
as a ramfs and populated.

I believe (Doug, please correct me if the following is wrong) the
advantage of storing mdmon's pid files in /dev is that in /dev they
remain visible after the switch to the new root. That's the "handoff
after pivotroot" in the subject.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLS+gjWto1QDEAkw8RAs1xAJ0ZPupDu7Eccw4FYdLbWIuhxaI5/gCcCs7t
dbOnFjCl1JSaS/JNDJ0H7y8=
=XzjR
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
