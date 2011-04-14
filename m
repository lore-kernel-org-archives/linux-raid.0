From: NeilBrown <neilb@suse.de>
Subject: Re: Any pros or cons of using full disk versus partitons?
Date: Thu, 14 Apr 2011 18:11:59 +1000
Message-ID: <20110414181159.48a2086e@notabene.brown>
References: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com>
	<20110413.132112.102552472.davem@davemloft.net>
	<io52j7$cg4$1@dough.gmane.org>
	<BANLkTi=vgVxVRomvpkX5uxSvN9Fe1cgvoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=vgVxVRomvpkX5uxSvN9Fe1cgvoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Apr 2011 11:57:47 +0400 CoolCold <coolthecold@gmail.com> wro=
te:

> On Thu, Apr 14, 2011 at 12:55 AM, David Brown <david.brown@hesbynett.=
no> wrote:
> > On 13/04/11 22:21, David Miller wrote:
> >>
> >> From: "Matthew Tice"<mjtice@gmail.com>
> >> Date: Wed, 13 Apr 2011 13:38:39 -0600
> >>
> >>> So of course it technically doesn't matter but are there certain
> >>> (non-apparent) repercussions for choosing one over the other? =A0=
It seems
> >>> to
> >>> save a couple steps by using the whole disk (not having to partit=
ion) -
> >>> but
> >>> is that it? =A0One thing I'm thinking about the pros of using par=
titions is
> >>> if
> >>> all your disks (or some) are different sizes - then you can set t=
he
> >>> partition sizes the same.
> >>
> >> First, you sent this to "linux-raid-owner" instead of just
> >> "linux-raid". =A0The former goes to me, not to the mailing list.
> >>
> >> I've corrected it in the CC:
> >>
> >> Second, to answer your question, for some disk label variants you
> >> risk over-writing the disk label if you use the whole device
> >> as part of your RAID volume. =A0This definitely will happen, for
> >> example, with Sun disk labels.
> >
> > Using whole disks in the raid will make it easier for replacing dis=
ks - you
> > don't have to worry about partitioning them. =A0You can just plug t=
hem in and
> > use them. =A0If you have some sort of monitoring scripts and hot pl=
ug disks,
> > you may be able to avoid any interaction at all on disk replacement=
=2E
> >
> > On the other hand, using partitions gives you lots more flexibility=
=2E You can
> > do things such as use a small partition on each disk to form a raid=
10 array
> > for swap, while using a bigger partition for data. =A0Or perhaps yo=
u want a
> > very small partition on each disk as a wide raid1 mirror, for your =
/boot
> > (not that you need so much safety for /boot, but that it's easier t=
o boot
> > from a raid1 with metadata format 0.90 than from other raid types).
> Just my 2 cents: I've faced problems when newer disk was smaller than
> old disk two or three times, so using partitions now with setting som=
e
> free space at the end - something near 80 or 100 megabytes.

You don't need partitions to do this.  Just use the --size option to md=
adm.

NeilBrown


>=20
> If your system is located on the same disks which holds useful data,
> it might be useful to split data into another mountpoint/block device
> and let system skip fs check on startup and produce booted server,
> which is helpful in case of system crash/powerloss and dirty
> fs/breaked raid. RAID assembly problems may be caused by crappy
> controller like lsi 1068e which was hanging the whole system and
> desync data writes on disks on SMART request or completely on it's
> own.
>=20
>=20
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
