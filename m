From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Spurious HD convictions
Date: Wed, 16 Dec 2009 09:13:31 +0000
Message-ID: <20091216091331.GA15689@cthulhu.home.robinhill.me.uk>
References: <70ed7c3e0912141206p65005aeegf663183c946dec7b@mail.gmail.com>
 <FD.42.04641.7F2782B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FD.42.04641.7F2782B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 15, 2009 at 11:41:03PM -0600, Leslie Rhorer wrote:

> 	It seems to have done so, yes.  I've looked around the web trying to
> find some additional info, but I've come up empty handed.  Perhaps someone
> here can answer at least one of my questions?  I know that putting a value
> of 32 into /sys/block/<driveID>/device/queue_depth fully enables NCQ, and
> putting a value of 1 there disables NCQ.  What do all the numbers in betw=
een
> do?
>=20
I believe the value sets the allowed queue length.  A value of 1 thus
effectively disables queueing.  Most ATA drives have a maximum queue
depth of 32 so this is usually set for fully enabling it (though I
believe it's recommended only to use 31 - this seems to be the default).
If you set it to 32 and the drive has a shorter maximum queue, the
kernel will use the drive's maximum instead.

Setting any value is permitted, there's just generally little point in
doing so.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksopLoACgkQShxCyD40xBLlGQCglin5flE0lbmMQRNslM1/Wiy5
1t4AniRMODPkHzY9bHH0Hbk5x30DFyjs
=3zgp
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
