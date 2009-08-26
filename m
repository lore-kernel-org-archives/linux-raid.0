From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 15:50:22 +0100
Message-ID: <20090826145022.GB9995@cthulhu.home.robinhill.me.uk>
References: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com> <353971.56181.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <353971.56181.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Aug 26, 2009 at 07:19:51AM -0700, Jon Hardcastle wrote:

> Can a bitmap be easily removed? I might give it ago if it can.
>=20
Yes - you can add/remove a bitmap at any time (on a non-degraded array).

> I am never sure how thorough these checks are. Are they read/write, or
> just read? for example. I make of point of doing read/write badblocks
> checks with e2fck -cc when I do run them (not the automatic ones tho -
> dunno how) but that only checks that partition, which is on LVM, which
> is on RAID so WHO KNOWS what underlying drives are being checked.
>=20
My understanding is that the md "check" action does a read-only check,
verifying the checksum is valid for the data.  The "repair" action
will rewrite the checksum if it's not valid.  Neither of these will
write to the data blocks, or any valid checksum blocks.

Running e2fsck -cc should do a read/write check.  This will only check
the filesystem data blocks though (and only on ext2/ext3 filesystems of
course), so will miss the LVM metadata and RAID checksums and metadata.

> I have before now, dismantled the array and run read/write badblocks
> directly on the constituent drives so at least smart is aware of them
> and although i aim to do this once every six months, I think I have
> actually done it only 1nce in the 2 year life of the array.
>=20
If you mean running badblocks in read/write mode, that'll be a
destructive test then.  In this case, you're trading the risk of a
failure on one disk for the risk of a failure on one of the others
during rebuild.

You could also run background SMART tests (though this has caused drives
to be kicked out of the array on some occasions for me) - these look to
be mostly read-only tests again (though I'm not 100% sure on that).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqVS64ACgkQShxCyD40xBLtmwCeINWoEgJQepo66VFYBGh6zX1z
vfsAn3Gm3N2uvup+huPr0b0jd/D0KvV4
=P/jl
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
