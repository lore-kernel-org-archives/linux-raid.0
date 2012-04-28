From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 12:55:06 +1000
Message-ID: <20120428125506.6a2388eb@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<4F9B14FA.1090001@weboperative.com>
	<20120428080522.637bc564@notabene.brown>
	<4F9B2BE1.5080207@weboperative.com>
	<4F9B3B48.8020900@weboperative.com>
	<4F9B57E9.2060409@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5PV4V5yAzZis0BaOLwkaZp6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B57E9.2060409@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5PV4V5yAzZis0BaOLwkaZp6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 22:37:29 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:

> On 04/27/2012 08:35 PM, likewhoa wrote:
> > I am not sure how to proceed now with the output that shows possible
> > pairs as it won't allow me to setup all 8 devices on the array but only
> > 4. Should I run the array creation with -x4 and set the available spare
> > devicesor or just create the array as I can remember which was one pair
> > from each controller. i.e /dev/sda3 /dev/sde3 ...?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ok I was able to recreate the array with correct order which I took from
> my /dev/md0's --details output and was able to decrypt the luks mapping
> but XFS didn't open and xfs_repair is currently doing the matrix. I will
> keep this posted with updates.

I hope the order really is correct.... I wouldn't expect xfs to find proble=
ms
if it was...

>=20
> Thanks again Neil.
> WRT 3.3.3 should I just go back to 3.3.2 which seemed to run fine and
> wait until there is a release of 3.3.3 that has fix?

3.3.4 has the fix and was just released.
3.3.1, 3.3.2 and 3.3.3 all have the bug.  It only triggers on shutdown and
even then only occasionally.
So I recommend 3.3.4.

NeilBrown

--Sig_/5PV4V5yAzZis0BaOLwkaZp6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5tcCjnsnt1WYoG5AQKZcRAAiIcI+7mnkQNRxJ7sCjgn5oc6bIB1HJXG
kqBmXe5cDeXhMuVOkY5e6xd9tXOdVYMcOoVH+y8q2w/7oW+lhqM2zsyPJaa5z+Hu
GRGZeFwxzHdLsvllpciOjt5o5aaGgZjJP0h9x93xRBqKQU0EWS2csF4uelXxo4PM
6h3I3zFpXdjHqCAfdCjFmpA0guSD3jgGE2WLeSW/q2qKf8ga9yZsVm29XCkMCKeD
UaEXiobBCdKuGy6FrFl5Y65FXt/iBJPMQHZvwJO9UgjeOnuEr8wEUAFitE48hdVT
DxO0Qhtk6ONaMx5z7Uypsb0MJrh9W97ANI3Kc++UZOd9TxLTf83n3A7TEq0S1XVO
9XHqcKgeChXYw/6mJogX1fKqSvIruXPuvePFgBU0Re4TnjAPeaxmwIScZqXceXZu
YwbpK2sIXDdzWXBOvOaRpwvftSgWvUxM0WtEyalP4+HPwh09FJD/TrGPp5ErChX6
V4Jaxd/knhfHax2Cs8M5Jlrddi0uF3SJuAt9iDpaYES5uZE2rIcVKnqc0qNnFfmy
WEOv9SbVckYF4FVJCbbzO4oJMzfbbD9A9m9E2diygTQBfPljL5TvIEeni1iKkY2i
uRmSfVAE3HgoQeCKP6TClLNe9pm9fEVNNUEnhi+sILr7mnT3IvJNOsmNhyz+Ga8X
daYX9tnwzEU=
=Ij3k
-----END PGP SIGNATURE-----

--Sig_/5PV4V5yAzZis0BaOLwkaZp6--
