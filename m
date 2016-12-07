From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 07/12] md: mddev_find_container helper function
Date: Wed, 07 Dec 2016 12:23:53 +1100
Message-ID: <877f7c4jme.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-8-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-8-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> This allows finding the parent container of a subarray for external
> metadata arrays.

This doesn't belong in the kernel.
If it did, there would be a detailed description here of why it is
needed.
But there isn't one.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHZKkACgkQOeye3VZi
gbmwaw/+ITw5I+1ueYjtNRTNqLGdAiXOo3cKbUP4BCRet9Th4F9+KmMmf8sxkaYB
2/OG33+wekRx4AH5IdQxV7kRm00VUzgJIYdc1HEq+zcBR3tR50TraT2doUKCsPdu
svnHL3/I81sA2OKhe145W+ytb8ynH84yj+/JsWf9CmBjT8pLo4MAoKqK1iIO1Z68
XDCfD2fLmOMzQ7YlQqKoJjttR6aPlfTWcKFUQure6N0FVorPEqN8zojdr7nvRARq
zxhfk8HcHRtwwC5gkfatc6eFzJRrbV7vZCMXkJv0JFTFB8tdDyAbvYUpOamJuaCx
efTySRJ0COJ5I8Rx2hwQnbxl2BXACycVjdAaNWpb3itltHwt6L4D8OiXDM3AcBEM
CCqegObOBmU9MRd/ibHj0TMUoUMYZVYbVACALEddaWA7a5k/7f1yO0i1UtZKei2f
ZdCIXkLyOO06fhUaaxbOj/fCn+8+AEYGea7v+HTHr3bX76+unVKFBjTyMgMTs2wi
n5Bo/1fLpdOZS799aNTsA272yxSDQB1rU6EbXuplC6Kt14KMOilH9cnfzz91LTgf
b5bCAt30SbKfuOifGeX+0c3pSSEG2SZubJjyz4M648McyeMvQBomvNJOEvF95He7
z4n4mKDZ/qw8tuXVMuzImb9AlhXgxj19DEbC3UdCkBRQP1s7wFg=
=LgPs
-----END PGP SIGNATURE-----
--=-=-=--
