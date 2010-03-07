From: Keld Simonsen <keld@keldix.com>
Subject: Re: What RAID type and why?
Date: Sun, 7 Mar 2010 01:38:09 +0100
Message-ID: <20100307003809.GA8068@light.rap.dk>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com> <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com> <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There is s newbie setup howto at
http://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_disk

This is for 2 disks, but you can add more disks for added redundency an=
d
speed.

best regards
keld

On Sat, Mar 06, 2010 at 03:05:46PM -0800, Mark Knecht wrote:
> On Sat, Mar 6, 2010 at 2:33 PM, Greg Freemyer <greg.freemyer@gmail.co=
m> wrote:
> > On Sat, Mar 6, 2010 at 5:02 PM, Mark Knecht <markknecht@gmail.com> =
wrote:
> >> First post. I've never used RAID but am thinking about it and look=
ing
> >> for newbie-level info. Thanks in advance.
> >>
> >> I'm thinking about building a machine for long term number crunchi=
ng
> >> of stock market data. Highest end processor I can get, 16GB and at
> >> least reasonably fast drives. I've not done RAID before and don't =
know
> >> how to choose one RAID type over another for this sort of workload=
=2E
> >> All I know is I want the machine to run 24/7 computing 100% of the
> >> time and be reliable at least in the sense of not losing data if 1
> >> drive or possibly 2 go down.
> >>
> >> If a drive does go down I'm not overly worried about down time. I'=
ll
> >> stock a couple of spares when I build the machine and power the bo=
x
> >> back up within an hour or two.
> >>
> >> What RAID type do I choose and why?
> >>
> >> Do I need a 5 physical drive RAID array to meet these requirements=
?
> >> Assume 1TB+ drives all around.
> >>
> >> How critical is it going forward with Linux RAID solutions to be a=
ble
> >> to get exactly the same drives in the future? 1TB today is 4TB a y=
ear
> >> from now, etc.
> >>
> >> With an 8 core processor (high-end Intel Core i7 probably) do I ne=
ed
> >> to worry much about CPU usage doing RAID? I suspect not and I don'=
t
> >> really want to get into hardware RAID controllers unless criticall=
y
> >> necessary which I suspect it isn't.
> >>
> >> Anyway, if there's a document around somewhere that helps a newbie
> >> like me I'd sure appreciate finding out about it.
> >>
> >> Thanks,
> >> Mark
> >
> > I'm not sure about a newbie doc, but here's some basics:
> >
> > You haven't said what kind of i/o rates you expect, nor how much
> > storage you need.
>=20
> Good points. I guess I was assuming I'd want 1TB storage and I'd buy
> 3/5/6 1TB drives to get it. Honestly I probably don't need anything
> close to that. My weekly backups of stock data run about 1GB to 1TB
> should hold me for quite awhile I think.
>=20
> As for i/o rates I think it's pretty low. Real-time or historic stock
> data arrives here over the net so that's not fast. Crunching numbers
> *typically* amounts to loading a single data set from disk into memor=
y
> and then operating from there so I suspect that even in backtesting
> it's pretty low but I'll see if I can get some data. None the less I'=
m
> not sure there's much overlap between when the disk is heavily used
> and when it gets CPU limited. Again, I'll have to give that some
> thought.
>=20
> >
> > At a minimum I would build a 3-disk raid 6. =A0raid 6 does a lot of=
 i/o
> > which may be a problem.
> >
> > Raid-5 is out of favor for me due to issues people are seeing with
> > discrete bad sectors with the remaining drives after you have a dri=
ve
> > failure. =A0raid-6 tolerates those much better. =A0Even raid 10 is =
not as
> > robust as raid 6 and with the current generation drives robustness =
in
> > the raid solution is more important than ever.
> >
> > But raid 6 uses 2 parity drives, so you'll only get 1TB of useable
> > space from a 3-disk raid 6 made from 1TB drives.
>=20
> I've been looking at this page so far for the most basic info:
>=20
> http://en.wikipedia.org/wiki/RAID#Organization
>=20
> They show RAID 6 with 5 drives so I'll need to learn how to do this
> with fewer drives. I think you're point about more than 1 drive havin=
g
> problems around the same time is good input.
>=20
> While money is always important buying 1 or 2 more drives (say $200)
> isn't the biggest issue here. It's a new machine with a $500 processo=
r
> so if more drives make a big difference in terms of reliability then =
I
> don't want to cut too many corners.
>=20
> >
> > mdraid just requires replacement disks be bigger than the old disk
> > you're replacing.
> >
> > You might consider layering LVM on top of mdraid to help you manage
> > the array as it grows.
>=20
> Two subject I haven't even thought of!
>=20
> Thanks for the info! Lots to study!
>=20
> Cheers,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
