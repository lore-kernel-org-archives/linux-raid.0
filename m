From: Chris Zimmerman <czimmer@mclaneco.com>
Subject: Re: Perhaps this has been answered before...
Date: 22 Aug 2002 09:47:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1030027640.31114.83.camel@zimmerman>
References: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi>
	<3D63D0BD.50005@hum.auc.dk>  <20020821235326.GE5617@unthought.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-It07cvd4atHefAkSli2e"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020821235326.GE5617@unthought.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-It07cvd4atHefAkSli2e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Based on this, I have upgraded the system to 2.4.19.  Since this is a
cluster, I will run this kernel on the secondary (and it seems to be
working fine so far), then I will push this to the primary after about
30-60 days of stable operation.  Thanks to all for the suggestions and
help.=20

Chris Zimmerman=20

On Wed, 2002-08-21 at 18:53, Jakob Oestergaard wrote:
    On Wed, Aug 21, 2002 at 07:41:17PM +0200, Mads Peter Bach wrote:
    ...
    > >I however do not see why this should freeze your machine.
    >=20
    >=20
    > Me neither. Swap on RAID-1 works fine for me (though on 2.4).
   =20
    RAID in 2.2 is seriously broken unless the RAID patches are applied.
   =20
    With the patches, there are problems with stability in the case where
    you actually swap on the RAID device.
   =20
    With a recent 2.4 kernel, the swap stability problem should be gone. At
    least swapping on RAID-1 works for me as well, on several systems here.
   =20
    So just don't swap on RAID if you're on 2.2  :)   On 2.4 it should work=
.
   =20
    --=20
    ................................................................
    :   jakob@unthought.net   : And I see the elder races,         :
    :.........................: putrid forms of man                :
    :   Jakob =D8stergaard      : See him rise and claim the earth,  :
    :        OZ9ABN           : his downfall is at hand.           :
    :.........................:............{Konkhra}...............:
    -
    To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
    the body of a message to majordomo@vger.kernel.org
    More majordomo info at  http://vger.kernel.org/majordomo-info.html
   =20
   =20
   =20

--=-It07cvd4atHefAkSli2e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9ZPl49u4GRRZAJ2YRAgVqAJ9gwxSqUOi5JCGOzjx16ByfMMrM8QCgr+Si
0wUrw8wI3UytyAvRFghpcps=
=LZJ+
-----END PGP SIGNATURE-----

--=-It07cvd4atHefAkSli2e--
