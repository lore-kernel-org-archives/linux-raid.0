From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm 3.1.1  fails to hot remove device - No such device or
 address
Date: Fri, 26 Feb 2010 14:42:20 +0000
Message-ID: <20100226144220.GA24333@cthulhu.home.robinhill.me.uk>
References: <D27CA15508148C428A25104ADEFAAC8105728535@CORPUSMX50C.corp.emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D27CA15508148C428A25104ADEFAAC8105728535@CORPUSMX50C.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 26, 2010 at 08:37:51AM -0500, Foster_Brian@emc.com wrote:

> Hi Neil,
>=20
> We run mdadm in a NAS framework and recently updated to 3.1.1 after
> using older revs for quite some time. We recently observed an issue
> where we've been unable to hot remove a failed device from an array,
> where that member device has been physically removed from the system.
> 'mdadm /dev/md# -r /dev/sdg#' returns a "No such device or address
> error."
>=20
> It turns out this occurs due to the dev_open() call added in the code
> referenced below. The hot remove works as expected if we revert this
> change with the patch shown below. Was the dev_open() added for some
> functional reason I'm not aware of (i.e., are we now breaking some other
> error path by doing this)? For future reference, is there a better way
> to handle the situation where the member device is physically gone? Note
> that we currently have a static set of devnodes; no udev or anything
> like that. Thanks.
>=20
Does "-r failed" or "-r detached" not work?  That should be the easiest
way to remove failed/detached drives from the array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuH3csACgkQShxCyD40xBKBNgCeNiYxlvPUIS2uyPtjD33y4hGl
erEAoKmsjj3Z4C6eu9VqWWh0lzjLO4MB
=vUnK
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
