From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 09:27:10 +0000
Message-ID: <20121211092710.GA28593@cthulhu.home.robinhill.me.uk>
References: <1355182639.50c6722fe15b2@mail.inbox.lv>
 <alpine.DEB.2.00.1212110912470.17599@uplift.swm.pp.se>
 <1355216495.50c6f66f123b1@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355216495.50c6f66f123b1@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 11, 2012 at 11:01:35AM +0200, Andris Berzins wrote:

> Quoting "Mikael Abrahamsson" <swmike@swm.pp.se>:
> > On Tue, 11 Dec 2012, Andris Berzins wrote:
> >=20
> >> I found on internet that this can be fixed if I re-create raid with th=
e same
> >> configuration, but with dead drive set as 'missing'.
> >=20
> > This is extremely dangerous. You would have been better off by first
> > trying --assemble --force.
> >=20
> >> However, I can not mount md1 and looks like it contains random data. T=
he
> >> order is correct. However, I noticed that new raid device size is
> >> different from old one.
> >=20
> > Your data offset is different, most likely you're not using the same md=
adm
> > version as was initially used to create the raid. Mdadm defaults have
> > changed over time regarding chink size, data offset and others.
>=20
> Thank you!
> I did not notice that.
> Looks that I will have to try downgrade kernel:
> http://serverfault.com/questions/427683/what-parameters-to-mdadm-to-re-cr=
eate-md-device-with-payload-starting-at-
> 0x2200
>=20
No, that's an entirely unrelated issue (though if you are running one of
the affected kernel versions you really ought to up/downgrade it).

>=20
> >=20
> > I don't know off the top of my head how to change the mdadm data offset
> > unfortunately.
> >=20
There's no way in the current mdadm releases to do so. Neil does have a
version in git which will allow specifying the data offsets on a
disk-by-disk basis (as it is possible to have multiple offsets within an
array). If all the disks in your array were using an offset of 2048
though, then you'll just need to downgrade mdadm to 3.2.3 (or slightly
earlier) - from what I can find it was changed to 262144 for 3.2.4 (it
was 272 pre version 3.0, so don't go any further back than that).

You will likely have lost some data though, as the new superblocks will
have overwritten part of the data, so make sure you run a fsck
afterwards (start with fsck -n though, to make sure the overall array
looks okay first).

Good luck (and please make sure you try just forcing an assemble next
time),
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDG/G0ACgkQShxCyD40xBLHTACfdXendvLebr/KSPhRbavpGIye
L/QAn17mPqnEfWB/H1HTmM586IGyg4lh
=VLnU
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
