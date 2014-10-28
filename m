From: NeilBrown <neilb@suse.de>
Subject: Re: question about MD raid rebuild performance degradation even
 with speed_limit_min/speed_limit_max set.
Date: Wed, 29 Oct 2014 09:38:22 +1100
Message-ID: <20141029093822.79242658@notabene.brown>
References: <5445332B.9060009@cse.yorku.ca>
	<5445361E.3010503@cse.yorku.ca>
	<5445799A.8020205@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/URB1e+yT_Dr0fS/jrhyiNrJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5445799A.8020205@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Keltz <jas@cse.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/URB1e+yT_Dr0fS/jrhyiNrJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Oct 2014 17:07:38 -0400 Jason Keltz <jas@cse.yorku.ca> wrote:

> On 10/20/2014 12:19 PM, Jason Keltz wrote:
> > Hi.
> >
> > I'm creating a 22 x 2 TB SATA disk MD RAID10 on a new RHEL6 system.=20
> > I've experimented with setting "speed_limit_min" and "speed_limit_max"=
=20
> > kernel variables so that I get the best balance of performance during=20
> > a RAID rebuild of one of the RAID1 pairs. If, for example, I set=20
> > speed_limit_min AND speed_limit_max to 80000 then fail a disk when=20
> > there is no other disk activity, then I do get a rebuild rate of=20
> > around 80 MB/s. However, if I then start up a write intensive=20
> > operation on the MD array (eg. a dd, or a mkfs on an LVM logical=20
> > volume that is created on that MD), then, my write operation seems to=20
> > get "full power", and my rebuild drops to around 25 MB/s. This means=20
> > that the rebuild of my RAID10 disk is going to take a huge amount of=20
> > time (>12 hours!!!). When I set speed_limit_min and speed_limit_max to=
=20
> > the same value, am I not guaranteeing the rebuild speed? Is this a bug=
=20
> > that I should be reporting to Red Hat, or a "feature"?
> >
> > Thanks in advance for any help that you can provide...
> >
> > Jason.
>=20
> I would like to add that I downloaded the latest version of Ubuntu, and=20
> am running it on the same server with the same MD.
> When I set speed_limit_min and speed_limit_max to 80000, I was able to=20
> start two large dds on the md array, and the rebuild stuck at around 71=20
> MB/s, which is close enough.  This leads me to believe that the problem=20
> above is probably a RHEL6 issue.  However, after I stopped the two dd=20
> operations,  and raised both speed_limit_min and speed_limit_max to=20
> 120000, the rebuild stayed between 71-73 Mb/s for more than 10 minutes=20
> .. now it seems to be at 100 MB/s... but doesn't seem to get any higher=20
> (even though I had 120 MB/s and above on the RHEL system without any=20
> load)... Hmm.
>

md certainly cannot "guarantee" any speed - it can only deliver what the
underlying devices deliver.
I know the kernels logs say something about a "guarantee".  That was added
before my time and I haven't had occasion to remove it.

md will normally just try to recover as fast as it can unless that exceeds
one of the limits - then it will back-off.
What speed it actually achieved depends on other load and the behaviour of
the IO scheduler.

"RHEL6" and "Ubuntu" don't mean a lot to me.  Specific kernel version might,
though in the case of Redhat I know that backport lots of stuff so even the
kernel version isn't very helpful.  I'm must prefer having report against
mainline kernels.

Rotating drives do get lower transfer speeds at higher addresses.  That mig=
ht
explain the 120 / 100 difference.

NeilBrown

--Sig_/URB1e+yT_Dr0fS/jrhyiNrJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAa3jnsnt1WYoG5AQLFPRAAk7qYqk/YFQ0Ub9laX116w1ygD6CXsSIx
AK6+St0G4DUU9DQi4wkogbyvIENO7VibNB+nX6r5RFn3l7UFkqywzvtCbuODGLcM
zuy2Ov0dsQFTRtpMgPyFsq5PitYngWJCZhrue5MKv1m1+Sg7GUVAM7+4AX+3sGFY
Y7BPS+y9h7W6hIFUp1nntbzYDePNMnIx+93ycU3DXF4O/Tipr85rxpvx4DSaTEWf
6Rndd6q6uerXGGv2XjbC/3WzeQuq6L1xmKUBHabeNtzM7pg9xr6p8GDTPLvbpkZP
q4AN5bEObS2gvhsSmJ4YZHxySCtBzndjC4hIme2G7y3ON0NIt6RuVRSbUVL6gBkg
nDdgL6zuPwiPFq3vggQSZNbR5lZn7xq8+yf/ksr1KwN/HqrwxPnXPuIl0nE/2+5v
wGTLL+6/6B580+ujvjl4uAlYznca6tWTyQysuU4ra9QR+4GVZkuDCNNVxINnIvbv
O6VzIjaRwQDIUlBaASgYKyt1I1phguO3TfMSQa25W57QzgSXjSsTVO+R4VonZCwv
kBTEKbjHcX0T0DyQbhkyNhD1E2dHh40dohc+Bmtxwh+4A5uwwmnORkZzMYab9Cgv
O6G9Li9pvU/vMsmCcpYmS7mzqd/OUDUwfbdZ3/79g7YEVE80ROtFrbjmu69Qeyld
yBiLj0ItbXc=
=vLge
-----END PGP SIGNATURE-----

--Sig_/URB1e+yT_Dr0fS/jrhyiNrJ--
