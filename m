From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Thu, 18 Oct 2012 09:56:01 +1100
Message-ID: <20121018095601.7aa3238b@notabene.brown>
References: <20120726080150.GA21457@kernel.org>
	<20120731155304.11c40f9b@notabene.brown>
	<CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
	<20120911105908.51681433@notabene.brown>
	<20120912052941.GA15827@kernel.org>
	<20120918145710.55394bd4@notabene.brown>
	<20120919055106.GA1305@kernel.org>
	<20120919171646.6bc35ba5@notabene.brown>
	<20120920015655.GB6798@kernel.org>
	<20121017051113.GA17821@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9snE43qtCMkX+J2GTcPiZAN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121017051113.GA17821@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9snE43qtCMkX+J2GTcPiZAN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Oct 2012 13:11:13 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Sep 20, 2012 at 09:56:55AM +0800, Shaohua Li wrote:
> > On Wed, Sep 19, 2012 at 05:16:46PM +1000, NeilBrown wrote:
> > > On Wed, 19 Sep 2012 13:51:06 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >=20
> > > > On Tue, Sep 18, 2012 at 02:57:10PM +1000, NeilBrown wrote:
> > > > > On Wed, 12 Sep 2012 13:29:41 +0800 Shaohua Li <shli@kernel.org> w=
rote:
> > > > >=20
> > > > > > On Tue, Sep 11, 2012 at 10:59:08AM +1000, NeilBrown wrote:
> > > > > > > On Tue, 31 Jul 2012 16:12:04 +0800 Shaohua Li <shli@kernel.or=
g> wrote:
> > > > > > >=20
> > > > > > > > 2012/7/31 NeilBrown <neilb@suse.de>:
> > > > > > > > > On Thu, 26 Jul 2012 16:01:50 +0800 Shaohua Li <shli@kerne=
l.org> wrote:
> > > > > > > > >
> > > > > > > > >> Write has some impacts to SSD:
> > > > > > > > >> 1. wear out flash. Frequent write can speed out the prog=
ress.
> > > > > > > > >> 2. increase the burden of garbage collection of SSD firm=
ware. If no space
> > > > > > > > >> left for write, SSD firmware garbage collection will try=
 to free some space.
> > > > > > > > >> 3. slow down subsequent write. After write SSD to some e=
xtents (for example,
> > > > > > > > >> write the whole disk), subsequent write will slow down s=
ignificantly (because
> > > > > > > > >> almost every write invokes garbage collection in such ca=
se).
> > > > > > > > >>
> > > > > > > > >> We want to avoid unnecessary write as more as possible. =
raid sync generally
> > > > > > > > >> involves a lot of unnecessary write. For example, even t=
wo disks don't have
> > > > > > > > >> any data, we write the second disk for the whole disk si=
ze.
> > > > > > > > >>
> > > > > > > > >> To reduce write, we always compare raid disk data and on=
ly write mismatch part.
> > > > > > > > >> This means sync will have extra IO read and memory compa=
re. So this scheme is
> > > > > > > > >> very bad for hard disk raid and sometimes SSD raid too i=
f mismatch part is
> > > > > > > > >> majority. But sometimes this can be very helpful to redu=
ce write, in that case,
> > > > > > > > >> since sync is rare operation, the extra IO/CPU usage is =
worthy paying. People
> > > > > > > > >> who want to use the feature should understand the risk f=
irst. So this ability
> > > > > > > > >> is off by default, a sysfs entry can be used to enable i=
t.
> > > > > > > > >>
> > > > > > > > >> Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > > > > > > >> ---
> > > > > > > > >>  drivers/md/md.c    |   41 +++++++++++++++++++++++++++++=
++
> > > > > > > > >>  drivers/md/md.h    |    3 ++
> > > > > > > > >>  drivers/md/raid1.c |   70 +++++++++++++++++++++++++++++=
++++++++++++++++++++----
> > > > > > > > >>  3 files changed, 110 insertions(+), 4 deletions(-)
> > > > > > > > >>
> > > > > > > > >> Index: linux/drivers/md/md.h
> > > > > > > > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > >> --- linux.orig/drivers/md/md.h        2012-07-25 13:51:0=
0.353775521 +0800
> > > > > > > > >> +++ linux/drivers/md/md.h     2012-07-26 10:36:38.500740=
552 +0800
> > > > > > > > >> @@ -325,6 +325,9 @@ struct mddev {
> > > > > > > > >>  #define      MD_RECOVERY_FROZEN      9
> > > > > > > > >>
> > > > > > > > >>       unsigned long                   recovery;
> > > > > > > > >> +#define MD_RECOVERY_MODE_REPAIR              0
> > > > > > > > >> +#define MD_RECOVERY_MODE_DISCARD     1
> > > > > > > > >> +     unsigned long                   recovery_mode;
> > > > > > > > >
> > > > > > > > > You have not documented the meaning of these two flags at=
 all, and I don't
> > > > > > > > > feel up to guessing.
> > > > > > > > >
> > > > > > > > > The patch looks more complex that it should be.  The beha=
viour you are
> > > > > > > > > suggesting is exactly the behaviour you get when MD_RECOV=
ERY_REQUESTED is
> > > > > > > > > set, so at most I expect to see a few places where that f=
lag is tested
> > > > > > > > > changed to test something else as well.
> > > > > > > > >
> > > > > > > > > How would this be used?  It affects resync and resync hap=
pens as soon as the
> > > > > > > > > array is assembled.  So when and how would you set the fl=
ag which says
> > > > > > > > > "prefer reads to writes"?  It seems like it needs to be s=
et in the metadata.
> > > > > > > > >
> > > > > > > > > BTW RAID10 already does this - it reads and compares for =
a normal sync.  So
> > > > > > > > > maybe just tell people to use raid10 if they want this be=
haviour?
> > > > > > > >=20
> > > > > > > > It's true, the behavior likes MD_RECOVERY_REQUESTED, ie, re=
ad all disks,
> > > > > > > > only do write if two disk data not match. But I hope it wor=
ks as soon as the
> > > > > > > > array is assembled. Surely we can set in the metadata, but =
I didn't want to
> > > > > > > > enable it by default, since even with SSD, the read-compare=
-write isn't optimal
> > > > > > > > some times, because it involves extra IO read and memory co=
mpare.
> > > > > > > >=20
> > > > > > > > It appears MD_RECOVERY_REQUESTED assumes disks are insync.
> > > > > > > > It doesn't read disk !insync, so it doesn't work for assemb=
le.
> > > > > > > >=20
> > > > > > > > In my mind, user frozen the sync first (with sync_action se=
tting), and then
> > > > > > > > enable read-compare-write, and finally continue the sync. I=
 can't stop
> > > > > > > > a recovery and set MD_RECOVERY_REQUESTED, so I added a flag.
> > > > > > > > Anyway, please suggest what the preferred way for this.
> > > > > > >=20
> > > > > > > I guess I just don't find this functionality at all convincin=
g.  It isn't
> > > > > > > clear when anyone would use it, or how they would use it.  It=
 seems best not
> > > > > > > to provide it.
> > > > > >=20
> > > > > > The background is: For SSD, writting a hard formatted disk and =
fully filled
> > > > > > disk, the first case could be 300% faster than the second case =
depending on SSD
> > > > > > firmware and how fragmented the filled disk is. So this isn't a=
 trival
> > > > > > performance issue.
> > > > > >=20
> > > > > > The usage model is something like this: one disk is borken, add=
 a new disk to
> > > > > > the raid. Currently we copy the whole disk of the first disk to=
 the second. For
> > > > > > SSD, if the first disk and second disk have most data identical=
 or most content
> > > > > > of the first is 0, the copy is very bad. In this scenario, we c=
an avoid some
> > > > > > copy, which will make latter write to the disk faster. Thinking=
 about 300%
> > > > > > faster :).
> > > > > >=20
> > > > > > I don't think we can do this in underlayer. We don't want to do=
 it always.
> > > > > > Detecting 0 is very expensive.
> > > > > >=20
> > > > > > And this isn't intrusive to me. We only do the 'copy avoidness'=
 in sync, and
> > > > > > sync is rare event.
> > > > > >=20
> > > > > > I hope to convince you this is a useful functionality, then we =
can discuss the
> > > > > > implementation.
> > > > > >=20
> > > > >=20
> > > > > Let's start with "when would someone use it".
> > > > >=20
> > > > > You said that you don't want to make it the default.  If somethin=
g isn't a
> > > > > default it will not be used very often, and will only be used at =
all if it is
> > > > > reasonably easy to use.
> > > > > So how would someone use this?  What would make them choose to us=
e it, and
> > > > > what action would that take to make it happen?
> > > >=20
> > > > Ok, let me explain the usage model.
> > > >=20
> > > > For 'compare and avoid write if equal' case:
> > > > 1. update SSD firmware. This doesn't change the data, but we need t=
ake one disk
> > > > off from the raid one time.
> > > > 2. One disk has errors, but these errors don't ruin most of the dat=
a (for
> > > > example, a pcie error)
> > > > 3. driver/os crash.
> > > > In all these cases, two raid disks must be resync, and they have al=
most identical
> > > > data. write avoidness will be very helpful for these.
> > >=20
> > > This is all valid, but doesn't explain how it actually happens.
> >=20
> > Those are real use cases actually.
> > =20
> > > Maybe the rsync should initially do a comparison and write-if-differe=
nt.  If
> > > at any time after the first megabyte the fraction of blocks that requ=
ires a
> > > write exceeds (say) 10%, we switch to "read one, write the others".
> > > ??
> >=20
> > Not sure, but this will limit the usage. For example, in my case 1, the=
 first
> > disk can be written slightly when the second disk is doing firmware upg=
rade.
> > The write can be in the first 1M for sure.
> > =20
> > > > For 'compare and trim if source disk data is 0' case:
> > > > If filesystem support trim, this can be enabled always (or at least=
 we can
> > > > enable it if used capacity of the disk is less than 80% for example=
).
> > >=20
> > > One of my concerns about this is that I would expect smart flash driv=
es to
> > > actually do this zero-detection internally.  Maybe they don't now, bu=
t surely
> > > they will soon.  By the time we get this feature into production ther=
e seems
> > > a reasonably chance that it won't be needed - at least on new hardwar=
e.
> >=20
> > Doesn't make sense to me. zero-detection is very expensive. blindly doi=
ng it
> > for every request is insane. While my proposal is just doing it for syn=
c, which
> > is a rare scenario.
> > =20
> > > And on old hardware I believe that 'discard' isn't particularly fast =
(as it
> > > cannot be queued ... or something).  So I would only want to send a d=
iscard
> > > request if it was very large, though I'm not sure how large is large =
enough.
> >=20
> > Yep, discard speed varies between SSDs. Some are very slow, much slower=
 than
> > write, some SATA SSD discard speed is even slower than harddisk write. =
While
> > our card is very fast, faster than write.
> > =20
> > > > User enables these features and then add disk to downgrade raid. ra=
id resync
> > > > then avoids write or does trim.
> > >=20
> > > This is the bit that concerns me the most - expecting the user to ena=
ble this
> > > sort of feature.  In many cases they won't making the code pointless.=
  If an
> > > optimisation is needed, we should use it automatically.  Maybe we can=
 for the
> > > first first case.  Not sure yet about the second one.
> >=20
> > I understood your concerns. Giving this feature can harm/benefit, depen=
ding on
> > different SSDs and workload/usage model, an interface to enable is pref=
erred.
>=20
> Neil,
> any further comments on this? This is a usable feature, I hope we can hav=
e some
> agreements.

You still haven't answered my main question, which possibly means I haven't
asked it very clearly.

You are saying that this new behaviour should not be the default and I think
I agree.
So the question is:  how it is selected?

You cannot expect the user to explicitly enable it any time a resync or
recovery starts that should use this new feature.  You must have some
automatic, or semi-automatic, way for the feature to be activated, otherwise
it will never be used.

I'm not asking "when should the feature be used" - you've answered that
question a few time and it really isn't an issue.
The question it "What it the exact process by which the feature is turned on
for any particular resync or recovery?"

NeilBrown


--Sig_/9snE43qtCMkX+J2GTcPiZAN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUH83gTnsnt1WYoG5AQJaXQ/+JwBcInpGxvI0sp1zBPSLrlrjF+fS+w/C
UvFMst2hW7x+EOKxfX0gN9rO1EHIk3QaqYawXVDKOdXWQnaDWCCE+/mYeQDheJKS
xtYcliMmmFpz/AsGT3MQ/drc8yyT/hd4VRgO61NaA1vbYqN5jDAzsY/VQ6mvOpV3
2tcR3wfPPorIKvFJpK6CYPgOFtMSeTNzzAeB34iqBdU02DHqb6szCszR7dhwZTP4
PzJcLN1/rrPKzGpue+RuUAdfuu4uQT4dmCKcbM5tl7XWK19S2kv2KqnNbQbWou9+
VQIILwYUzbQ/QONZsG7iNYzVh91pCZa5PoJIIIMj6s3b7vzEagiqjDXgVJa3FuHE
YBP96pBv2TDOpfpk8YohBej1cnzRiJhwoEByfhPOZWS1SVyXFxjUun2p4onyPqq0
fkrzwciZ6UFrb9ggUmz5/o+qG+y4UkJ2VCyYlq4sY/e9ReVPVjf9tOjZDrPJGfoo
mxLk6yQ7ej8R4ylkpOSkjryKMKY6ivDw7++9NF8gCzd6bRTZiJy9wxvwcN4psD5S
lmqzfiDytgi1kKQ/U4dFdDU/OsBlFU+GoYAWqFora2LJo1/ILzAgjF28HNtNY8UG
OstQxbQN7oxFN/9zdd8RjGGVjb1+Vcx15tPySmGzB/ZpNUOlqvI5I88DLMC4fdTu
rLFLSm2jiwg=
=d4lc
-----END PGP SIGNATURE-----

--Sig_/9snE43qtCMkX+J2GTcPiZAN--
