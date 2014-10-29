From: NeilBrown <neilb@suse.de>
Subject: Re: question about MD raid rebuild performance degradation even
 with speed_limit_min/speed_limit_max set.
Date: Wed, 29 Oct 2014 13:57:49 +1100
Message-ID: <20141029135749.241f9e50@notabene.brown>
References: <5445332B.9060009@cse.yorku.ca>
	<5445361E.3010503@cse.yorku.ca>
	<5445799A.8020205@cse.yorku.ca>
	<20141029093822.79242658@notabene.brown>
	<5450521F.8060309@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VbZ11YTqciNosa6Naw8pJln"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5450521F.8060309@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Keltz <jas@cse.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VbZ11YTqciNosa6Naw8pJln
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2014 22:34:07 -0400 Jason Keltz <jas@cse.yorku.ca> wrote:

> On 28/10/2014 6:38 PM, NeilBrown wrote:
> > On Mon, 20 Oct 2014 17:07:38 -0400 Jason Keltz<jas@cse.yorku.ca>  wrote:
> >
> >> On 10/20/2014 12:19 PM, Jason Keltz wrote:
> >>> Hi.
> >>>
> >>> I'm creating a 22 x 2 TB SATA disk MD RAID10 on a new RHEL6 system.
> >>> I've experimented with setting "speed_limit_min" and "speed_limit_max"
> >>> kernel variables so that I get the best balance of performance during
> >>> a RAID rebuild of one of the RAID1 pairs. If, for example, I set
> >>> speed_limit_min AND speed_limit_max to 80000 then fail a disk when
> >>> there is no other disk activity, then I do get a rebuild rate of
> >>> around 80 MB/s. However, if I then start up a write intensive
> >>> operation on the MD array (eg. a dd, or a mkfs on an LVM logical
> >>> volume that is created on that MD), then, my write operation seems to
> >>> get "full power", and my rebuild drops to around 25 MB/s. This means
> >>> that the rebuild of my RAID10 disk is going to take a huge amount of
> >>> time (>12 hours!!!). When I set speed_limit_min and speed_limit_max to
> >>> the same value, am I not guaranteeing the rebuild speed? Is this a bug
> >>> that I should be reporting to Red Hat, or a "feature"?
> >>>
> >>> Thanks in advance for any help that you can provide...
> >>>
> >>> Jason.
> >> I would like to add that I downloaded the latest version of Ubuntu, and
> >> am running it on the same server with the same MD.
> >> When I set speed_limit_min and speed_limit_max to 80000, I was able to
> >> start two large dds on the md array, and the rebuild stuck at around 71
> >> MB/s, which is close enough.  This leads me to believe that the problem
> >> above is probably a RHEL6 issue.  However, after I stopped the two dd
> >> operations,  and raised both speed_limit_min and speed_limit_max to
> >> 120000, the rebuild stayed between 71-73 Mb/s for more than 10 minutes
> >> .. now it seems to be at 100 MB/s... but doesn't seem to get any higher
> >> (even though I had 120 MB/s and above on the RHEL system without any
> >> load)... Hmm.
> >>
> > md certainly cannot "guarantee" any speed - it can only deliver what the
> > underlying devices deliver.
> > I know the kernels logs say something about a "guarantee".  That was ad=
ded
> > before my time and I haven't had occasion to remove it.
> >
> > md will normally just try to recover as fast as it can unless that exce=
eds
> > one of the limits - then it will back-off.
> > What speed it actually achieved depends on other load and the behaviour=
 of
> > the IO scheduler.
> >
> > "RHEL6" and "Ubuntu" don't mean a lot to me.  Specific kernel version m=
ight,
> > though in the case of Redhat I know that backport lots of stuff so even=
 the
> > kernel version isn't very helpful.  I'm must prefer having report again=
st
> > mainline kernels.
> >
> > Rotating drives do get lower transfer speeds at higher addresses.  That=
 might
> > explain the 120 / 100 difference.
> Hi Neil,
> Thanks very much for your response.
> I must say that I'm a little puzzled though. I'm coming from using a=20
> 3Ware hardware RAID controller where I could configure how much of the=20
> disk bandwidth is to be used for a rebuild versus I/O.   From what I=20
> understand, you're saying that MD can only use the disk bandwidth=20
> available to it.  It seems that it doesn't take any priority in the I/O=20
> chain.  It will only attempt to use no less than min bandwidth, and no=20
> more than max bandwidth for the rebuild, but if you're on a busy system,=
=20
> and other system I/O needs that disk bandwidth, then there's nothing it=20
> can do about it.  I guess I just don't understand why.  Why can't md be=20
> given a priority in the kernel to allow the admin to decide how much=20
> bandwidth goes to system I/O versus rebuild I/O.  Even in a busy system,=
=20
> I still want to allocate at least some minimum bandwidth to MD.  In=20
> fact, in the event of a disk failure, I want to have a whole lot of the=20
> disk bandwidth dedicated to MD.  It's something about short term pain=20
> for long term gain? I'd rather not have the users suffer at all, but if=20
> they do have to suffer, I'd rather them suffer for a few hours, knowing=20
> that after that, the RAID system is in a perfectly good state with no=20
> bad disks as opposed to letting a bad disk resync take days because the=20
> system is really busy... days during which another failure might occur!
>=20
> Jason.

It isn't so much "that MD can only use..." but rather "that MD does only
use ...".

This is how the code has "always" worked and no-one has ever bothered to
change it, or to ask for it to be changed (that I recall).

There are difficulties in guaranteeing a minimum when the array uses
partitions from devices on which other partitions are used for other things.
In that case I don't think it is practical to make guarantees, but that
needn't stop us making guarantees when we can I guess.

If the configured bandwidth exceeded the physically available bandwidth I
don't think we would want to exclude non-resync IO completely, so the
guaranty would have to be:
   N MB/sec or M% of available, whichever is less

We could even implement the different approach in a back-compatible way.
Introduce a new setting "max_sync_percent".  By default that is unset and t=
he
current algorithm applies.
If it is set to something below 100, non-resync IO is throttled to
an appropriate fraction of the actual resync throughput whenever that is
below sync_speed_min.

Or something like that.

Some care would be needed in comparing throughput and sync throughput is
measured per-device, while non-resync throughput might be measured per-arra=
y.
Maybe the throttling would happen per-device??

All we need now is for someone to firm up the design and then write the cod=
e.

NeilBrown

--Sig_/VbZ11YTqciNosa6Naw8pJln
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFBXrTnsnt1WYoG5AQIOzhAAsVF9SmGjBX6TBj4vKJrUaE/F/hRNF8k6
iuUbSsrZjHR5mA3W6XV4DIcBSXBs/LXQmK+w8XBySoAE6FNAZaEVKR0oyXb0yi0e
lN4spu+FuZuHfTkbbXdxyFehmDg8xaUcWm0Tcsxda8Bdy3sqJ9EEU7NdyEZxq96B
Vja2YvPtZlAZymRDa9DausyNuegPjLV5wmO96V7QhUr3k9zsRVh5Rgt/qSnGjE2K
84JrQG0hoAhfGYWe8YoFDGCkAtBMcvktZMPP/yAYk6ZBDao66kJG0zJM9HPO3iqb
RjFnh5nlvEuM2OOqnpkIT0MYkadKLiLedEEUEcYW2PyO5obe4ItUtYtQBeYkGS3x
xcSx+GVAODmugEACVUsf5lG7p/i/1/pyb6TcvpD0RuPqQddrs/TZi5OFcVFJuOjl
g73nCIWXMxWqk35r/8KwhMABEtDTbDvdmPVSfgKprsbHtt99P2IgdbQNOc4AiXGA
pfqA28veCSkWYRBredgAbMDZPnIWMAVMptYe4Hb4lOBnTSGxz4IaA8Eh7QkLNIMy
QJB9eCwCQ/ZhQLHJ4tPGfif2OsrvPA4hPbEdUymxQ6Q7d55zSKAZzHYFpIoyd79h
tHmkuuwHGlSdyTYTHi5Z7a3XqAMQkiPFnd8FhjbLPl7SC1JebruNgx65rNob71H0
nal2q5LIxWc=
=elam
-----END PGP SIGNATURE-----

--Sig_/VbZ11YTqciNosa6Naw8pJln--
