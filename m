From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Race condition in write_sb_page?
Date: Mon, 20 Apr 2009 10:03:02 +0200
Message-ID: <20090420080301.GA28593@darkside.22.kls.lan>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org> <18922.50050.860008.242658@notabene.brown> <20090419225556.GC14157@darkside.22.kls.lan> <18923.45938.499331.641264@notabene.brown> <slrngunfh2.90j.Mario.Holbe@darkside.dyn.samba-tng.org> <dad4be16a03ccd96d073ecb16b937183.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dad4be16a03ccd96d073ecb16b937183.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2009 at 11:57:54AM +1000, NeilBrown wrote:
> The comment lists a number of conditions that are all true when
> something is remove from (or added to) the list.  So we only need
> to be sure that one of these is true to be sure the thing wont be removed

Okay, I guess I just confused the component's descriptor index (desc_nr,
which changes when a resync finishes) and it's position in mddev->disks
(which doesn't change).


Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSewsNRS+e2HeSPbpAQKaugf/ewaMiRm0gYrkE0Tsa7Bsme/RU+sJP4wE
onqUqRmP2ocGHodrv02FImmhJaY1v+Oa0uFxadtZnolx1z0hHBEOnXIC0ZvUff9B
WaHPeyqUlOLQpwjBkl5Gg0X0wJEu4JGSg0M68g1+MxfpqxD5Lo/xdk0uWcGKkQZc
S1ykDIDcfKSFC+XX7xUgGgEpx5EoQm/Q7fHFE8zm7Y4XmyXNEwcqVke3f6L3o496
Fyxnjb1+hN2dBndCjsEdeovJkcOEuNFSYCRoer2BCwqhCvmNqeKTKYgxoHGv96+6
mHLg+AXfIre6PrcAWFXwi6z3O+h0arzUQhGH3chm/TcH/d1CZPie0g==
=VnEr
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
