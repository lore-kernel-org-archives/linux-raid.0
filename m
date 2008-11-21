From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: fix multipath oops
Date: Fri, 21 Nov 2008 11:29:10 +0100
Message-ID: <20081121102910.GM17300@skl-net.de>
References: <20081117103203.GL17300@skl-net.de> <18724.35806.320253.868473@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="egxrhndXibJAPJ54"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18724.35806.320253.868473@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--egxrhndXibJAPJ54
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:57, Neil Brown wrote:
> 2/ You have introduced a subtle semantic change.  If ->sys_action is
>    NULL, we no longer clear MD_RECOVERY_RECOVER.  I suspect this isn't
>    actually an error in practice, but I think it is still the wrong
>    way around to do the tests.
>    I have
> 			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
> 					       &mddev->recovery))
> 				if (mddev->sysfs_action)
> 					sysfs_notify_dirent(mddev->sysfs_action);

Yes, I agree that's more reasonable.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--egxrhndXibJAPJ54
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJJo12Wto1QDEAkw8RAnAsAJ9fFrQIxi9RnvNQx6TJf4z2mo5X1QCggb7S
KGLSpkAW3gIBF5xyVWN11wM=
=w6QS
-----END PGP SIGNATURE-----

--egxrhndXibJAPJ54--
