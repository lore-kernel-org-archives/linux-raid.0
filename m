From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/5] Check return of stat() to avoid covscan complaining
Date: Wed, 25 Feb 2015 09:03:01 +1100
Message-ID: <20150225090301.5158921d@notabene.brown>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
	<20150225081243.1fe91420@notabene.brown>
	<wrfj61ar55yq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q/MDxBn5/1YTSlRx76izJEc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj61ar55yq.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/q/MDxBn5/1YTSlRx76izJEc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Feb 2015 16:56:29 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Tue, 24 Feb 2015 16:00:37 -0500 Jes.Sorensen@redhat.com wrote:
> >
> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >>=20
> >> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> >> ---
> >>  Assemble.c | 6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/Assemble.c b/Assemble.c
> >> index 131f871..b392214 100644
> >> --- a/Assemble.c
> >> +++ b/Assemble.c
> >> @@ -688,7 +688,11 @@ static int load_devices(struct devs *devices, cha=
r *devmap,
> >>  			close(dfd);
> >>  		}
> >> =20
> >> -		stat(devname, &stb);
> >> +		if (stat(devname, &stb)) {
> >> +			pr_err("Unsable to stat(%s) - skipping device.\n",
> >> +			       devname);
> >> +			continue;
> >> +		}
> >> =20
> >>  		if (c->verbose > 0)
> >>  			pr_err("%s is identified as a member of %s, slot %d%s.\n",
> >
> > I've applied the other 4.  I think I'd rather this one was fixed by cha=
nging
> >   stat(devname,
> > to
> >   fstat(dfd,
> > and keep dfd open a bit longer.
> >
> > Does this look OK to you?
>=20
> I got the warning from covscan because we ignored the return value from
> stat, so I think you still need to check the return value from fstat()
> as well.

I hope not.
You can only get errors from fstat if you do something stupid like passing
NULL as the stat pointer, or passing a non-open file descriptior.
So if covscan complains, then covscan is broken.

In contrast, stat can certainly given an error, such a ENOENT, which cannot
possibly be avoided by not being stupid.

NeilBrown

--Sig_/q/MDxBn5/1YTSlRx76izJEc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOz1FTnsnt1WYoG5AQLBZg/+NDYgV/UhjnPHtV1JudgfhUoagp98PDoU
kCHkqwos1ziyq2wZ+HjWlURe6BEmjaazMIAUxIPZC6zLQrkB4LDahOw6WXFNcc4j
ku+PMxgDF081G9DWv8TqUN3hyPEcRqxC3/5cowB300RiOx7ovdTaMdq5v5tUlwBa
ZWcqUtpTacWsM9OPXXwfEFjhsNZPcbiIcy/GwqsQOhPyiy/7kRkh+5Wuhu1iHAE8
qXYCsxPd/RDm5ud2gTYnLc3Cl7CFFj+1iCHF5Wqz0u2t0iohU59KNxx71KpEFusb
UeYnoePJzLjOyUMPrnboBQtyC3u8+cuZm4YC4eIPmLfdPJMisGMSgS4kG2FroZBK
JNKry2ESuRoNFyvwTQLZsS52rA1Kg59F3POEhay678HxYnXT1sdgG+EwhL6+v+Qr
5RpjEaG5LBEk4HJN5jl4V4g29x5BUQoAzV3cD4CCydhpDX+LycNin1aKNW0658s+
/ysT613rsYhef7o41ogXFhYxaHVBmFArqTeObztbzHvXczy2eRAcHTY4G7K0rhBL
y2rlJ8kJkw7ShgQh6OSCuSlFkikNE66hlLd062QKxxuVF38EPVVjYbDPraxpM8we
wxfawPmXQ8rcS0ErctIa3/Zk87C6p8cMzOxyouPhI5Nxn8z876IgtoVwx3iDECFK
jAbpA6pMCow=
=jTaF
-----END PGP SIGNATURE-----

--Sig_/q/MDxBn5/1YTSlRx76izJEc--
