From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Tue, 11 Sep 2012 10:59:08 +1000
Message-ID: <20120911105908.51681433@notabene.brown>
References: <20120726080150.GA21457@kernel.org>
	<20120731155304.11c40f9b@notabene.brown>
	<CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dgt8vi4JL.l.eHpq3H0CBlG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dgt8vi4JL.l.eHpq3H0CBlG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 16:12:04 +0800 Shaohua Li <shli@kernel.org> wrote:

> 2012/7/31 NeilBrown <neilb@suse.de>:
> > On Thu, 26 Jul 2012 16:01:50 +0800 Shaohua Li <shli@kernel.org> wrote:
> >
> >> Write has some impacts to SSD:
> >> 1. wear out flash. Frequent write can speed out the progress.
> >> 2. increase the burden of garbage collection of SSD firmware. If no sp=
ace
> >> left for write, SSD firmware garbage collection will try to free some =
space.
> >> 3. slow down subsequent write. After write SSD to some extents (for ex=
ample,
> >> write the whole disk), subsequent write will slow down significantly (=
because
> >> almost every write invokes garbage collection in such case).
> >>
> >> We want to avoid unnecessary write as more as possible. raid sync gene=
rally
> >> involves a lot of unnecessary write. For example, even two disks don't=
 have
> >> any data, we write the second disk for the whole disk size.
> >>
> >> To reduce write, we always compare raid disk data and only write misma=
tch part.
> >> This means sync will have extra IO read and memory compare. So this sc=
heme is
> >> very bad for hard disk raid and sometimes SSD raid too if mismatch par=
t is
> >> majority. But sometimes this can be very helpful to reduce write, in t=
hat case,
> >> since sync is rare operation, the extra IO/CPU usage is worthy paying.=
 People
> >> who want to use the feature should understand the risk first. So this =
ability
> >> is off by default, a sysfs entry can be used to enable it.
> >>
> >> Signed-off-by: Shaohua Li <shli@fusionio.com>
> >> ---
> >>  drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++
> >>  drivers/md/md.h    |    3 ++
> >>  drivers/md/raid1.c |   70 +++++++++++++++++++++++++++++++++++++++++++=
++++++----
> >>  3 files changed, 110 insertions(+), 4 deletions(-)
> >>
> >> Index: linux/drivers/md/md.h
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> --- linux.orig/drivers/md/md.h        2012-07-25 13:51:00.353775521 +0=
800
> >> +++ linux/drivers/md/md.h     2012-07-26 10:36:38.500740552 +0800
> >> @@ -325,6 +325,9 @@ struct mddev {
> >>  #define      MD_RECOVERY_FROZEN      9
> >>
> >>       unsigned long                   recovery;
> >> +#define MD_RECOVERY_MODE_REPAIR              0
> >> +#define MD_RECOVERY_MODE_DISCARD     1
> >> +     unsigned long                   recovery_mode;
> >
> > You have not documented the meaning of these two flags at all, and I do=
n't
> > feel up to guessing.
> >
> > The patch looks more complex that it should be.  The behaviour you are
> > suggesting is exactly the behaviour you get when MD_RECOVERY_REQUESTED =
is
> > set, so at most I expect to see a few places where that flag is tested
> > changed to test something else as well.
> >
> > How would this be used?  It affects resync and resync happens as soon a=
s the
> > array is assembled.  So when and how would you set the flag which says
> > "prefer reads to writes"?  It seems like it needs to be set in the meta=
data.
> >
> > BTW RAID10 already does this - it reads and compares for a normal sync.=
  So
> > maybe just tell people to use raid10 if they want this behaviour?
>=20
> It's true, the behavior likes MD_RECOVERY_REQUESTED, ie, read all disks,
> only do write if two disk data not match. But I hope it works as soon as =
the
> array is assembled. Surely we can set in the metadata, but I didn't want =
to
> enable it by default, since even with SSD, the read-compare-write isn't o=
ptimal
> some times, because it involves extra IO read and memory compare.
>=20
> It appears MD_RECOVERY_REQUESTED assumes disks are insync.
> It doesn't read disk !insync, so it doesn't work for assemble.
>=20
> In my mind, user frozen the sync first (with sync_action setting), and th=
en
> enable read-compare-write, and finally continue the sync. I can't stop
> a recovery and set MD_RECOVERY_REQUESTED, so I added a flag.
> Anyway, please suggest what the preferred way for this.

I guess I just don't find this functionality at all convincing.  It isn't
clear when anyone would use it, or how they would use it.  It seems best not
to provide it.

>=20
> The second patch is for a special case. two disks data don't match, but
> disk1 data are all 0. I'd like to do trim for disk2, instead of write
> 0 to disk2,
> this can be helpful for SSD.

If this is a useful optimisation, then I expect it should be implemented
somewhat lower in the stack, so that every attempt to write a zero block
becomes a 'trim'.  Ideally the SSD itself should  handle this optimisation.

I really don't think it is appropriate for md to be detecting zeros and
writing them as 'trim'.

NeilBrown



>=20
> Good to know raid10 already does read-compare-write. From the comments,
> looks it only supports resync not recovery.
>=20
> Thanks,
> Shaohua


--Sig_/dgt8vi4JL.l.eHpq3H0CBlG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE6M3Dnsnt1WYoG5AQLyMg/8CxgCWmmIoGmpoAWBJcU8y3GGEfSTy+fa
OQk98KNH2Fxp3W8+8JDmsmy3fEGubBxDcASmJOVYdjIjsnEq4jQzLY3+swGir/Xy
30mhZRiNsmRDzNuQI/vxSetkYVjPAPJyFpqoG/Ic6fNWp4yV2STugOvSxBmPNRvX
Jg7NonmL7P3rrGPLSmtAFPl/R+lYd4BDdmsQ2+SgXyI3pBLtAE044TrGNxlrLNnX
jDN0hiwezAO9TLqdmYaIkfsNDraP2iPZqOwBgG7u4ApXRsutmAUHY1m1Q/t1hoeT
HmGJXeUgr5WNSl8AWSc2qgyFPSnSo2Frgbxj9i1gJ7oTGVznKQ9QxerOpgfP2yib
Ai6uaFcQYcG3Cq9CPEyGEvivAElqUZWeu/6Mj6XLERT/Ucoq+akB2oJrL/tR8APl
DCD/iouKow/adqgg2cz9KTIfGHo6pGJXk9z/JJ/7Zq5dDy4ZjK4jnW2wWPMGnlzh
MQ4CeDsMBAyZkj1bHeiYCF06d/E5XT33UlXNWBboGNOg5YrXoRuQ0ZDdJii407V2
1b6ewCZVcvcuu3sqITY79xKYYTPTpCa8WiRDetwtCJpCN5slAzz1uFzOYip7CVzK
QI50pAptrdcU/ar/V/uZmr8EXSFRh7E2uZuxMOPgMjLccZhjnFMGkfXeqA7sHnQq
K2ylgf44chc=
=IavJ
-----END PGP SIGNATURE-----

--Sig_/dgt8vi4JL.l.eHpq3H0CBlG--
