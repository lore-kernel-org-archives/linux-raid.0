From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Sat, 8 Aug 2009 13:36:44 +0200
Message-ID: <20090808113644.GA14028@rap.rap.dk>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop> <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop> <4A7B708F.4050406@uga.edu> <20090807095133.GB28746@rap.rap.dk> <4A7C5BD2.80508@uga.edu> <20090807173423.GA32127@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090807173423.GA32127@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Harold Pritchett <harold@uga.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46orgot to cc linux-raid...

keld

On Fri, Aug 07, 2009 at 07:34:23PM +0200, Keld J=F8rn Simonsen wrote:
> On Fri, Aug 07, 2009 at 12:52:34PM -0400, Harold Pritchett wrote:
> > Keld J=F8rn Simonsen wrote:
> >
> >> It is a good idea to have a how-to. But there are already a few ar=
ound.
> >> I wrote something like it for our wiki at
> >> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_=
disk
> >> but with some more advanced features, such as you do not crash if =
one
> >> disk fails, and you can reboot the system without a rescue disk, a=
nd you
> >> get faster mirrored raid, avoiding the slow raid 1. It does not do=
 LVM,
> >> however, and I think that how-to should be enhanced with LVM.
> >
> > I guess this would depend upon the linux.  Currently, I am working =
with
> > Centos 5.3 and the only raid personalities available in the kernel =
on
> > the DVD appear to be RAID0, RAID1, RAID5, and RAID6.  With two disk=
s
> > this limits us to RAID0 and RAID1.
>=20
> I am also running centos 5.3 and raid10 is supported, and I run most =
of
> my data on it.
>=20
> >>> I'm from the old school.  I believe in lots of partitions.  Creat=
e any
> >>> additional partitions you may need.  If you really want to, you c=
an
> >>> just create a single partition and put "/" in it.  You still will
> >>> need the "/boot" partition since you can't boot from an LVM parti=
tion.
> >>
> >> I think it is good to have a / , a /home, and possibly a /boot=20
> >> partition, but having more partitions is probably just shooting=20
> >> yourself in the
> >> foot, because you may create space problems. Those smaill partitio=
ns can
> >> easily hit some roof, like /var (when logs run full)  and /tmp (do=
ing temporary
> >> work like editing in big files), /opt and /usr/local (installing b=
ig new packages)
> >> and why should /usr and / be on different partition - that beats m=
e.
> >
> > As I said, I'm from the old school originally cutting my teeth on B=
SD unix in
> > the 1980's.  In those days, disks were always too small.  A couple =
of 20 MB
> > disks (that's MB, not GB) was a LOT of space back then.  By using m=
ultiple
> > partitions you could keep a run-away from crashing the whole system=
 when it
> > filled up /tmp or /var.
>=20
> I am also from that time, starting out with UNIX V6 on RL05 with 2.5 =
MB on a PDP-11/45.
> And we had a *big* 40 MB disk in the corner. Later we ran VAX'en and =
BSD
> 4.2 - still I think it is better to keep the system things in one
> partition. Anyway why not describe both, and tell of pros and cons.
>=20
> > But once again, this personal preferences.  All you really need is =
/boot, / and
> > some swap space.
>=20
> I agree with that.
>=20
> >>> You can now continue to install linux normally.  I usually do it =
twice.
> >>> the first time is to get an idea of how big each partition should=
 be
> >>> and the second time is to get it right.
> >>
> >> That is cumbersome, and probably caused by your use of many partit=
ions.
> >> It will turn some novices off.
> >
> > Make the default a single partition and put the multiple partition =
version in an
> > appendix...  In today's world of TeraByte disk drives for under $10=
0.00 It may
> > be the best idea to just put it all in a single file system.
>=20
> as sad you could decribe both. For pedagogical reasons, and because i=
t
> does not matter very much, you could probebly benefit from describing
> the simpler version.
>=20
> >> why can't you boot from the working drive?
> >> The system should be configured to do this.
> >>
> >>> 4.  Boot from the linux rescue CD/DVD and start the system, no ne=
twork.
> >>
> >> better avoid the rescue cd by making the system bootable from both=
 drives.'
> >
> > can do...  I just didn't think of this...
> >
> >>> 14. Wait for the mirror to sync.  It may take several hours
> >>
> >> you can begin using the system immediately, while the raids are sy=
ncing.
> >
> > Good point.  I knew that and just didn't say it.
> >
> >> it would be nice if you could reference our wiki, wherever you put=
 up
> >> your howto.
> >
> > I would be glad to...  In fact, if we get something useful, you mig=
ht want
> > to put a copy on the wiki...
>=20
> to me it is very overlapping with what is already up there.
> For now I cannot see the benefit of two howtos with the same aim.
> Better consolidate it.
>=20
> best regards
> keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
