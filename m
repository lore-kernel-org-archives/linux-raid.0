From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 14:33:36 +0200
Message-ID: <20110506123336.GC22617@www2.open-std.org>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110506155059.6f82cbeb@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 03:50:59PM +0600, Roman Mamedov wrote:
> On Fri, 6 May 2011 11:41:02 +0200
> Keld J=F8rn Simonsen <keld@keldix.com> wrote:
>   =20
> > > RAID1 is traditionally a mirror only setup (ok, some RAID=20
> > > implementations may do some load-balancing of some sort). So a RA=
ID1=20
> > > with 4 disks is one data set copied onto 4 disks. Bandwidth is ro=
ughly=20
> > > the same as a single disk (ignoring any load balancing).
> > > RAID10 is mirror and stripe. A RAID10 with 4 disks is similar to =
a 2=20
> > > disk RAID0 (double bandwidth with data split in half across both =
disks),=20
> > > but with each disk having a mirror (which brings the total up to =
4 drives).
> > >=20
> > > Additionally, a RAID1 disk (at least using MD) can be accessed ju=
st like=20
> > > a normal disk (good for recovery etc.) however a single disk out =
of a=20
> > > RAID10 array is next to useless.
> >=20
> > I think you are demonstrating some of my points about general knowl=
edge
> > quite nicely. Don't worry, you are not alone.
>=20
> So what is your proposal: people do not know they can do X, but commo=
nly do Y,
> so let's rename X to Y so that both things are called Y and they 'kno=
w how to
> do it'?
>=20
> RAID10 is an established term and means "stripe of mirrors", period.
> RAID1 means just a mirror. All the rest is just implementation detail=
s.
> Trying to redefine 2x2 to be 5 as some 'educational project' is defin=
itely
> misguided.

This is the common understanding: RAID10 means RAID1+0 - a RAID0 over
two RAID1's. As you write. But in Linux MD, raid10 is something else.
Something which is characterized as RAID1 in the SNIA RAID standards.
raid10,offset is directly an implementation of one of the SNIA RAID1
variants.

I am proposing that we call our raid10 layout types for RAID1 - in
accordance with SNIA standards, and in accordance with the common
understanding as demonstrated by you and others, even here on the
linux-raid kernel mailing list.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
