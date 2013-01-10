From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM-RAID: Fix RAID10's check for sufficient redundancy
Date: Thu, 10 Jan 2013 17:03:40 +1100
Message-ID: <20130110170340.6f4d0508@notabene.brown>
References: <1357783259.9103.5.camel@f16>
	<1357783352.9103.7.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ElUOAGsTYVPaennYKzmI.vW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357783352.9103.7.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/ElUOAGsTYVPaennYKzmI.vW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Jan 2013 20:02:32 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

>=20
> On Wed, 2013-01-09 at 20:00 -0600, Jonathan Brassow wrote:
> > DM RAID:  Fix RAID10's check for sufficient redundancy
> >=20
> > Before attempting to activate a RAID array, it is checked for sufficient
> > redundancy.  That is, we make sure that there are not too many failed
> > devices - or devices specified for rebuild - to undermine our ability to
> > activate the array.  The current code performs this check twice - once =
to
> > ensure there were not too many devices specified for rebuild by the user
> > ('validate_rebuild_devices') and again after possibly experiencing a fa=
ilure
> > to read the superblock ('analyse_superblocks').  Neither of these check=
s are
> > sufficient.  The first check is done properly but with insufficient
> > information about the possible failure state of the devices to make a g=
ood
> > determination if the array can be activated.  The second check is simply
> > done wrong in the case of RAID10 because it doesn't account for the
> > independence of the stripes (i.e. mirror sets).  The solution is to use=
 the
> > properly written check ('validate_rebuild_devices'), but perform the ch=
eck
> > after the superblocks have been read and we know which devices have fai=
led.
> > This gives us one check instead of two and performs it in a location wh=
ere
> > it can be done right.
> >=20
> > Only RAID10 was affected and it was affected in the following ways:
> > - the code did not properly catch the condition where a user specified
> >   a device for rebuild that already had a failed device in the same mir=
ror
> >   set.  (This condition would, however, be caught at a deeper level in =
MD.)
> > - the code triggers a false positive and denies activation when devices=
 in
> >   independent mirror sets have failed - counting the failures as though=
 they
> >   were all in the same set.
> >=20
> > The most likely place this error was introduced (or this patch should h=
ave
> > been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.
> >=20
> > Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Neil,
>=20
> This patch should apply cleanly on top of recent changes, but will not
> apply cleanly on an older kernel (like 3.7) due to version # changes and
> introduction of the new 'far' and 'offset' RAID10 algorithms.  If you
> think this fix should be pushed back into 3.7 rather than just applying
> on the latest code, I will make a patch for 3.7 - although I'm not
> certain how I'd handle the version number conflict.

Thanks Jon, I've applied that patch.

I can't say if it should be back-ported.  What is the worst-case scenario if
something goes wrong?  Do the current user-space code contain appropriate
tests itself too?

I don't see how version numbers will be a concern - they are just comments =
in
a 'Documentation' file aren't they?   If necessary, add extra text to expla=
in
any possible confusion.

NeilBrown

--Sig_/ElUOAGsTYVPaennYKzmI.vW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUO5ZvDnsnt1WYoG5AQJY9w//buqWPWYpTrOQM2w15H2Ou8fG6bgnq80Q
A2W4rIx1hEMklMa0ESQqLtu/kdj/TssH/5Vu5SddCbrJMwt02dHJPI8ISWeByM3p
5crMSW2cMhXBAl0mOeYwQpBIFdT8nd52BHeQ0YucYTNbCG0e6abNeZQMha22zaLK
caVA8q+UIsVBZ/q/8LOz8ODu6uEPBJgXN/GGhlTK5RLPuWmSznGe4ypHOx3brn2H
9JjgsKZlVGTK7oPueazqpaoXpWvKUFNXXMPkmbbHsr8PH7czCeySSp9v4wBCz6WH
Oruz2g1uoi6kK9s1mdLhuIZea5SRISQlG0Lqdrc/52M4qhs6dEPqy4cv508mZ6eP
W8ajvnrGEUz9DM4Dn0+89KtsW8RtgthPjFqP5pcujF/J3jHsQOutsqg+jk1sFKog
Urwn3b+4ssSravgTMeoebHbdyuS/L0kPG7rI2f0eK7Ggfdmw3QC4UGbh8NE+Ubyc
jUEJTCHF4+mehNXuDjjM4TVD7+bQRsk2Y8y++xm00YiWB/IaMcbmJB7w03dLU0Yz
wSPhfBJCmHlBqp4PA62s5dNghnNTM8544Mz9t0OPXFqUsIj9zMHxQXQtcm2PzRQp
fnut9B6JsKCjxVyg/5ZsyHu4NVHuZuP2aILyx+2InQHX0IDYJvfU2usNf8NAz9uu
rDJ+dsq9FiY=
=VVtd
-----END PGP SIGNATURE-----

--Sig_/ElUOAGsTYVPaennYKzmI.vW--
