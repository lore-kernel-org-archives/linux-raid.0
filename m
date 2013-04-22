From: NeilBrown <neilb@suse.de>
Subject: Re: Question about resync in RAID5
Date: Mon, 22 Apr 2013 10:15:52 +1000
Message-ID: <20130422101552.4eed452c@notabene.brown>
References: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
	<4915289.2.1366127167165.JavaMail.root@zimbra>
	<20130416165522.GA14744@cthulhu.home.robinhill.me.uk>
	<CANsebLH0PcjV2nmcQ0TmEE_8XxF6pi53baSenV3qKwdRxioK+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gW=u7NOqOFZt+zXLd1l3jaJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANsebLH0PcjV2nmcQ0TmEE_8XxF6pi53baSenV3qKwdRxioK+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Dong <robin.k.dong@gmail.com>
Cc: robin@robinhill.me.uk, linux-raid@vger.kernel.org, Tao Ma <tm@tao.ma>
List-Id: linux-raid.ids

--Sig_/gW=u7NOqOFZt+zXLd1l3jaJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2013 12:29:07 +0800 Robin Dong <robin.k.dong@gmail.com> wrot=
e:

> 2013/4/17 Robin Hill <robin@robinhill.me.uk>
> >
> > On Tue Apr 16, 2013 at 05:46:07PM +0200, Roy Sigurd Karlsbakk wrote:
> >
> > > > > Is there any method to just resync WRITTEN data to new-added-disk=
 ?
> > > > > Or any developing plan to add this feature?
> > > >
> > > > No, because md is a block device it has no knowledge of what data h=
as
> > > > actually been written to the disk or where it is stored. This means=
 it
> > > > has to rebuild the entire disk.
> > > >
> > > > There are plans to improve this by keeping track of which stripes h=
ave
> > > > been written to, which should help (and will also mean no need for =
an
> > > > initial RAID sync). I don't know whether this has progressed beyond
> > > > the idea stage yet though.
> > >
> > > Interesting - do you have any docs about this? I haven't seen any talk
> > > on this list about it...
> > >
> > It's from Neil's 2011 MD/RAID roadmap:
> >     http://neil.brown.name/blog/20110216044002
> >
> > The basic idea was mentioned in a 2009 roadmap as well, but is a lot
> > more fleshed out in the above one.
>=20
>=20
> Hi, Neil
>=20
> Has anyone began to develope non-sync-bitmap feature? If not, I want to
> take a chance.
> Will the non-sync-bitmap be built on the write-intent-bitmap or I need to
> create a new bitmap in 'array state info' of v1.x metadata?
>=20

Hi Robin et al,

No, no implementation has been started.

You cannot use the same bits as the write intent bitmap as they mean
something different.  But you could possibly use the same storage space.
i.e. have an alternate style of bitmap where there are two bits per 'chunk'.
One bit maps "this was written recently, a resync might be needed after a
crash" and the other means "This has been written since array create, so the
chunk needs to be recovered to any spare".

I don't know if this is the best approach - I haven't really thought about =
it
much.

There are several parts to this:

 1/ decide how to store the new bitmap on disk, and implement that
 2/ decide how to store the new bitmap in memory and implement that.
    It might be the same...
 3/ Set a bit in the new bitmap on each write (if it isn't set), and
    trigger a resync of that chunk.
 4/ Update the recovery process for each level to honour this new bit
 5/ Allow "discard" operations to clear these bits.

If you do proceed with this,  feel free to post a more concrete design befo=
re
proceeding to code - or just post code if you prefer.

NeilBrown


--Sig_/gW=u7NOqOFZt+zXLd1l3jaJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXSBODnsnt1WYoG5AQIR+A/+JccdkDFDgmJMdQrd5FfHeoyyfWRMcKtA
ZE9/kHPRWnLSPbWLSFwTOxmzPoi9a0pQlz7XPEsumyv9z+9AJ1/b9QvixJjQ7aNo
f2aEcrmI7VXkeUGhTlpAKGh7wd46B1F12p6CFbaa6dhp0nAWt2nTW+QiOBFSyjLW
ZEhJA1h0dIxOO+asjuOC7fxmvwOMJsCEbqm6faV8Ys+GEmn9AU4TD7Syc1D4PQa9
MzjIg1EI2r5+sGFuMJ0BVIgwC8INwBeDhf/nYQtpXnxQIDMHnxcSgNnqQRYwhzMf
l+aAOfrRfETvbPFnktbSm4orZgzwHwy9CfELH44zw7N4Mdt43v8kU5pEkNEAzCoR
ni1vUkLKbIjKQWQJVzK6K1sbpVIcXn7tfr47alW3xFHUbMOogyqhN5ssl0n/kdFb
Fb3CZr7CWyjcoJiRHBjMtbSANPH/6RVTPrB3zI0D+71ueUHQC4yhz+SZ5pUvBDil
oUT5VXpnuepKAp11CpjMcLIECXvNLs/YGzzlbL+0tgWKnUijny5YJ825jgJPkVwS
5SafL/r6PnuFXa6weBpnQdNhG8FbqtL1qe/twiEeSfK/o/k2H53TtNF99Z0rQHMo
CXtzkuAZrVr1qsqJTnpIZs7s6YJvxMRNzU4cR21Yl/Yam7tMGXV4O5gi4H20j8f8
SCef+5rXOoo=
=M7G/
-----END PGP SIGNATURE-----

--Sig_/gW=u7NOqOFZt+zXLd1l3jaJ--
