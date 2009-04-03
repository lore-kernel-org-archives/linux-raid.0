From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Fri, 3 Apr 2009 22:06:49 +0100
Message-ID: <20090403210649.GA12384@cthulhu.home.robinhill.me.uk>
References: <439371.59188.qm@web51306.mail.re2.yahoo.com> <87myb1ieoq.fsf@frosties.localdomain> <1238597796.4604.6.camel@cichlid.com> <87tz58b65a.fsf@frosties.localdomain> <49D3B8FC.7050204@sauce.co.nz> <87d4btjwpf.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d4btjwpf.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 03, 2009 at 10:42:20PM +0200, Goswin von Brederlow wrote:

> Richard Scobie <richard@sauce.co.nz> writes:
>=20
> > Goswin von Brederlow wrote:
> >
> >>
> >> Now think about the same with 6 disk raid5. Suddenly you have partial
> >> stripes. And the alignment on stripe boundaries is gone too. So now
> >> you need to read 384k (I think) of data, compute or delta (whichever
> >> requires less reads) the parity and write back 384k in 4 out of 6
> >> cases and read 64k and write back 320k otherwise. So on average you
> >> read 277.33k and write 362.66k (=3D 640k combined). That is twice the
> >> previous bandwidth not to mention the delay for reading.
> >>
> >> So by adding a drive your throughput is suddenly halfed. Reading in
> >> degraded mode suffers a slowdown too. CPU goes up too.
> >>
> >>
> >> The performance of a raid is so much dependent on its access pattern
> >> that imho one can not talk about a general case. But note that the
> >> more drives you have the bigger a stripe becomes and you need larger
> >> sequential writes to avoid reads.
> >
> > I take your point, but don't filesystems like XFS and ext4 play nice
> > in this scenario by combining multiple sub-stripe writes into stripe
> > sized writes out to disk?
> >
> > Regards,
> >
> > Richard
>=20
> Some FS have a parameter to tune to the stripe size. If that actually
> helps or not I leave for you to test.
>=20
> But ask yourself: Have any a tool to retune after you've grown the raid?
>=20
Both XFS and ext2/3 (and presumably 4 as well) allow you to alter the
stripe size after growing the raid (ext2/3 via tune2fs and XFS via mount
options).  No idea about other filesystems though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknWemgACgkQShxCyD40xBLSPwCePhu4bsydPEu+W0sSEP8rutA0
tXcAoN98coNgwpzE3WJhTEV5ZFc9ly+K
=uSxC
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
