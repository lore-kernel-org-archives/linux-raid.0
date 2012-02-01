From: NeilBrown <neilb@suse.de>
Subject: Re: rebuild raid6 after two failures
Date: Wed, 1 Feb 2012 16:31:57 +1100
Message-ID: <20120201163157.1605ec8c@notabene.brown>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
	<kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FYwmFqQo1Ppn059U.tb3kXL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FYwmFqQo1Ppn059U.tb3kXL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jan 2012 20:42:28 -0800 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

> On 2012-01-31, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> >
> > I recently had a RAID6 lose two drives in quick succession, with one
> > spare already in place.  The rebuild started fine with the spare, but
> > now that I've replaced the failed disks, should I expect the current
> > rebuild to finish, then rebuild on another spare?
>=20
> [snip]
>=20
> Well, for better or worse, this is now a moot question--I had another
> drive kicked out of the array, I believe prematurely by the controller.
> I was able to --assemble --force the array, and it is now rebuilding
> two spares instead of one.  AFAIR there was no activity on the
> filesystem at the time, so I am optimistic that the filesystem should be
> fine after an fsck.  Thanks to the advice from last time which suggested
> --assemble --force instead of --assume-clean in this situation.
>=20
> Could it have been the older version of mdadm that didn't tell the
> kernel to start rebuilding the added spare?  I have made 3.2.3 my
> default mdadm, which I hope alleviates some of the issues I've had with
> rebuilds not starting.  (As an aside, I've also bitten the bullet and
> decided to swap out all the WD-EARS drives for real RAID drives; ideally
> I'd replace the controller, but I don't want to invest the time needed
> to replace and test all the components properly.)

If a spare is being rebuild when another spare is added, it keeps with the
first rebuild rather than restarting from the beginning.

This means that you get some redundancy sooner, which is probably a good
thing.

NeilBrown

--Sig_/FYwmFqQo1Ppn059U.tb3kXL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyjOTTnsnt1WYoG5AQLTQRAAiXKBexsvoODFo7Hc3Qpp8ghvIADbOWex
FZWgk3tDWrJ8b09Bwf1bVnkCa09f5DNnGzgXeaoi12aQmZvujeG1j3+FVGl07w6/
Hpe2z52Qjmvjqo6SpX/s9aO6cgRh5OYSKa8WCZL9PDBNnk2W1OptLPFpcFGkXMTt
FmsyZRRqYfFe8TjifYM5ZKMYBT+atw7b8z0ZsXLiEuZDv/F8ctehOF04CoOVfGvL
l/9ic3tCv1NYP6dj2CGVwY2x69uHrROUpIXQvW+UFYmuM9ABlXO7v2u7opl0pzEk
BotU+ynKpDjBVik6CgYemGGUwigb5fczUyzmvKJb6ev3A+tlk5VH6R6qlQ70SlkW
YOI75hrQohGaSM6ZPjSbgfsYdgfpa/aePQ/mQ6UXO3B5qCdqv10U1FXYUP1yghnq
WVOX6bW/18C0ngV9h+HMcURVToETVIf/ByjjcX6GebKb3/tNPaBvaAGgR6KxbnfX
ZqF3Q+PPPA0mJ468M9dHSuWddR6QTZj+FQo66dDn46iS0hTfNvvjwATJrXl4gmuJ
00waaXZcYsJv/CrZyAhz2MSkg1631JtXWaFvEGUIczqyKyG/JJXTJVF7zCuZTf9J
CeYH1Vk6mrCnbg9o6ZqC9TY8+g4eVO7NE84kZ7Fdxgjj895hOhMiGcqdXFt0OU+u
O+aKzp1ZqCw=
=1iLt
-----END PGP SIGNATURE-----

--Sig_/FYwmFqQo1Ppn059U.tb3kXL--
