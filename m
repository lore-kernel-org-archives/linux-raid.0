From: NeilBrown <neilb@suse.de>
Subject: Re: reshape failure
Date: Thu, 12 May 2011 07:12:57 +1000
Message-ID: <20110512071257.79795756@notabene.brown>
References: <AANLkTikniCc3NNxgf9tW8Gb4qvUM-UfCJDazYC6Th1jZ@mail.gmail.com>
	<20110217073247.2dbc9299@notabene.brown>
	<AANLkTin__CDHu4qxAJe2NACXBFdE7EV1kuFOMoG7-P-h@mail.gmail.com>
	<20110217080634.510b017e@notabene.brown>
	<AANLkTi=gP5QGbq-JguHuA3T91_+U1XYLP1xiK9nSQ_LO@mail.gmail.com>
	<BANLkTimeeTY5MXoijD_uCdss6Ny+rB5dNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimeeTY5MXoijD_uCdss6Ny+rB5dNw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 May 2011 14:06:23 -0400 Tobias McNulty <tobias@caktusgroup.c=
om>
wrote:

> On Thu, Feb 17, 2011 at 4:39 PM, Tobias McNulty <tobias@caktusgroup.c=
om> wrote:
> >
> > On Wed, Feb 16, 2011 at 4:06 PM, NeilBrown <neilb@suse.de> wrote:
> > >
> > > On Wed, 16 Feb 2011 15:41:46 -0500 Tobias McNulty <tobias@caktusg=
roup.com>
> > > wrote:
> > > >
> > > > Now I see this in /etc/mdstat:
> > > >
> > > > md0 : active raid6 sdf[0] sdg[5](S) sdh[4] sdc[3] sdd[2] sde[1]
> > > > =A0 =A0 =A0 5860543488 blocks super 0.91 level 6, 64k chunk, al=
gorithm 2 [5/5] [UUUUU]
> > > > =A0 =A0 =A0 [=3D>...................] =A0reshape =3D =A09.9% (1=
93691648/1953514496)
> > > > finish=3D97156886.4min speed=3D0K/sec
> > > >
> > > > Is the 0K/sec something I need to worry about?
> > >
> > > Maybe. =A0If the stays at 0K/sec and the 9.9% stays at 9.9%, then=
 yes. =A0It is
> > > something to worry about.
> >
> > It seems like it was another buggy SATA HBA?? I moved everything ba=
ck
> > to the on-board SATA ports (1 of the 2 drives in the OS RAID1 devic=
e
> > and the 5 non-spare devices in the RAID6 -> RAID5 device) and it's
> > happily reshaping again (even without the=A0MDADM_GROW_ALLOW_OLD ma=
gic
> > this time):
> >
> > md0 : active raid6 sda[0] sde[4] sdd[3] sdc[2] sdb[1]
> > =A0=A0 =A0 =A05860543488 blocks super 0.91 level 6, 64k chunk, algo=
rithm 2 [5/5] [UUUUU]
> > =A0=A0 =A0 =A0[=3D=3D>..................] =A0reshape =3D 10.0% (196=
960192/1953514496)
> > finish=3D11376.9min speed=3D2572K/sec
> >
> > Is it really possible that I had two buggy SATA cards, from differe=
nt
> > manufacturers? =A0Perhaps the motherboard is at fault? =A0Or am I m=
issing
> > something very basic about connecting SATA drives to something othe=
r
> > than the on-board ports?
> >
> > Currently I'm using a SuperMicro X7SPA-HF [1] motherboard with a
> > AOC-SASLP-MV8 [2] HBA, and the machine is running Debian squeeze
> > (2.6.32-5-amd64).
> >
> > Tobias
> >
> > [1] http://www.supermicro.com/products/motherboard/ATOM/ICH9/X7SPA.=
cfm?typ=3DH&IPMI=3DY
> > [2] http://www.supermicro.com/products/accessories/addon/AOC-SASLP-=
MV8.cfm
>=20
> So, after figuring out the hardware issues, the reshape appears to
> have completed successfully (hurray!), but /proc/mdstat still says
> that the array is level 6.  Is there another command I have to run to
> put the finishing touches on the conversion?
>=20
> md0 : active raid6 sda[0] sde[4] sdd[3] sdc[2] sdb[1]
>       5860543488 blocks level 6, 64k chunk, algorithm 18 [5/5] [UUUUU=
]
>=20

Just
   mdadm --grow /dev/md0 --level=3D5

should complete instantly. (assuming I'm correct in thinking that you w=
ant
this to be a raid5 array - I don't really remember the details anymore =
:-)


NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
