From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Fri, 30 Sep 2011 09:07:20 +1000
Message-ID: <20110930090720.57534d81@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E82203A.60507@yazzy.org>
	<20110928091335.1df35f8e@notabene.brown>
	<4E828B92.40502@hardwarefreak.com>
	<4E82C862.8000705@yazzy.org>
	<4E834758.2090508@hardwarefreak.com>
	<20110929094910.2c44ff8a@notabene.brown>
	<CAA9_cmfYPoZVZhm9f+5W5bbTA+1Utb5K=FnZv_=ni8x0=R=Wbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sC9nTMV+fobL+_jN61QbJN8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfYPoZVZhm9f+5W5bbTA+1Utb5K=FnZv_=ni8x0=R=Wbg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: stan@hardwarefreak.com, lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sC9nTMV+fobL+_jN61QbJN8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 11:28:36 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Wed, Sep 28, 2011 at 4:49 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 28 Sep 2011 11:12:08 -0500 Stan Hoeppner <stan@hardwarefreak.co=
m>
> > wrote:
> >
> >> On 9/28/2011 2:10 AM, Marcin M. Jessa wrote:
> >> > On 9/28/11 4:50 AM, Stan Hoeppner wrote:
> >> >
> >> >> Reading the thread, and the many like it over the past months/years=
, may
> >> >> yield a clue as to why you wish to move on to something other than =
Linux
> >> >> RAID...
> >> >
> >> > :) I will give it another chance.
> >> > In case of failure FreeBSD and ZFS would be another option.
> >>
> >> I was responding to Neil's exhaustion with mdadm. =A0I was speculating
> >> that help threads such as yours may be a contributing factor,
> >> requesting/requiring Neil to become Superman many times per month to t=
ry
> >> to save some OP's bacon.
> >>
> >
> > No, I don't really think they are a factor - though thanks for thinking
> > about it.
> >
> > Obviously not all "help threads" end with a good result but quite a few=
 do
> > and one has to take the rough with the smooth.
> > And each help thread is a potential learning experience. =A0If I see pa=
tterns
> > of failure recurring it will guide and motivate me to improve md or mda=
dm to
> > make that failure mode less likely.
> >
> > I think it is simply that it isn't new any more. =A0I first started
> > contributing to md early in 2000, and 11 years is a long time. =A0Not a=
s long
> > as Mr Torvalds has works on Linux of course, but Linux is a lot bigger =
than
> > md so there is more room to be interested.
> > There have been many highlights over that time, but the ones that stick=
 in my
> > memory is when others have contributed in significant ways. =A0I really=
 value
> > that, whether it is code, or review or documentation, or making a wiki =
or
> > answering mailing lists questions before I do, or even putting extra ti=
me in
> > to reproduce a bug so we can drill down to the cause.
> >
> > I figure that appearing competent capable and in control isn't going to
> > attract new blood - new blood wants wide open frontiers with lots of
> > opportunity (I started in md when it was essentially unmaintained - I k=
now
> > the attraction). =A0So I just want to say that there is certainly room =
and
> > opportunity over here.
> >
> > I'm not about to drop md, but I would love an apprentice or two (or 3 o=
r 4)
> > and would aim to provide the same mix of independence and oversight as =
Linus
> > does.
> >
>=20
> What if as a starting point we could get a Patchwork queue hosted
> somewhere so you could at least start formally delegating incoming
> patches for an apprentice to disposition?

I don't know much about Patchwork ... what sort of value does it add?

But I don't think much of the idea of delegation.  I don't see a thriving
developer community full of people who want work delegated to them.   Rather
I see a thriving developer community of people who see problems and want to
fix them and dive in and do stuff.
An apprentice who needs to have stuff delegated to them will always be an
apprentice.  A master starts by doing the things their master doesn't want =
to
do, then moves to the things the master didn't think to do and finally
blossoms by doing the things their master didn't know how to do.

>=20
> The hardest part about maintenance is taste, and md has been thriving
> on good-taste pragmatic decisions for a while now.

Taste is learnt by practise.  Having someone correct - or at least
highlight - your mistakes is important, but making the mistakes in the first
place is vital.


I think the starting point is simply to do.  Read the code, ask a question,
suggest a design, send a patch, pick a task of the road-map (or make one up
your self) and start work on it.

NeilBrown

--Sig_/sC9nTMV+fobL+_jN61QbJN8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOhPooG5fc6gV+Wb0RAhEFAKDS2IRY7q4pq3zORDsmndPrhOLqYgCeMOJR
kAmWIXo8zQdf0a5Fllk2I0w=
=FGvI
-----END PGP SIGNATURE-----

--Sig_/sC9nTMV+fobL+_jN61QbJN8--
