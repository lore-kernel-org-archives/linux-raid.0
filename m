From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Online resize
Date: Wed, 12 Mar 2008 09:31:25 +0000
Message-ID: <20080312093125.GA12548@cthulhu.home.robinhill.me.uk>
References: <200803111119.56015.wayne@flashmedia.co.za> <20080311111219.GA2086@cthulhu.home.robinhill.me.uk> <200803111444.17502.wayne@flashmedia.co.za> <20080311145832.GC2086@cthulhu.home.robinhill.me.uk> <47D78EA8.7050604@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47D78EA8.7050604@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Mar 12, 2008 at 11:04:56AM +0300, Michael Tokarev wrote:

> Robin Hill wrote:
>> What version metadata are you using?  I'm not sure how 1.0 will handle
>> partition resizes but any other should certainly be okay.  Have you
>> tried running mdadm -E on each of the component partitions?  I assume
>> the new partitions are starting from the same position as the old ones?
>
> Robin, you're completely wrong here.
>
> Only metadata at the START of the partition will work here.  Which is
> either 1.1 or 1.2, but NOT 1.0 or 0.90, - which is at the END of the
> partition.  When the end of the partition goes away, the superblock
> becomes "orphan" somewhere inside the partition, and can't be found
> anymore.
>
That's why I said I wasn't sure about 1.0 metadata.  I've grown 0.90
arrays in exactly this way (though I may not actually have rebooted) so
I assumed they'd work okay (and the manual doesn't specify where the
metadata is for these).

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH16LtShxCyD40xBIRAipLAJ4/zTbdJlZ7Aibs8GkAAZQ2tc3Y9gCeMsdJ
wMpru9AslZsXasFhZGA+LWY=
=SLom
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
