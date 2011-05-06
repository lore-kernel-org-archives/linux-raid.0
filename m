From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: mdadm raid1 read performance
Date: Fri, 6 May 2011 23:53:39 +0200
Message-ID: <20110506215339.GA24391@www2.open-std.org>
References: <20110505111006.GB11441@www2.open-std.org> <89.70.16951.22664CD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <89.70.16951.22664CD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Keld =?iso-8859-1?Q?J=F8rn?= Simonsen' <keld@keldix.com>, 'NeilBrown' <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 04:20:39PM -0500, Leslie Rhorer wrote:
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simonsen
> > Sent: Thursday, May 05, 2011 6:10 AM
> > To: NeilBrown
> > Cc: Liam Kurmos; Roberto Spadim; Brad Campbell; Drew; linux-
> > raid@vger.kernel.org
> > Subject: Re: mdadm raid1 read performance
> >=20
> > On Thu, May 05, 2011 at 09:45:38AM +1000, NeilBrown wrote:
> > > On Thu, 5 May 2011 00:08:59 +0100 Liam Kurmos <quantum.leaf@gmail=
=2Ecom>
> > wrote:
> > >
> > > > as a separate question, what should be the theoretical performa=
nce of
> > raid5?
> > >
> > > x(N-1)
> > >
> > > So a 4 drive RAID5 should read at 3 time the speed of a single dr=
ive.
> >=20
> > Actually, theoretically, it should be more than that for reading, m=
ore
> > like N minus
> > some overhead. In a raid5 stripe of 4 disks, when reading you do no=
t read
> > the checksum block, and thus you should be able to have all 4 drive=
s
> > occupied with reading real data. Some benchmarks back this up,
> > http://home.comcast.net/~jpiszcz/20080329-raid/
> > http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-26255_1=
0.html
> > The latter reports a 3.44 times performance for raid5 reads with 4
> > disks, significantly over the N-1 =3D 3.0 mark.
> >=20
> > For writing, you are correct with the N-1 formular.
>=20
> 	There have been a lot of threads here about array performance, but
> one important factor rarely mentioned in these threads is network
> performance.  Of course, network performance is really outside the sc=
ope of
> this list, but I frequently see people talking about performance well=
 in
> excess of 120MBps.  That's great, but I have to wonder if their netwo=
rk
> actually can make use of such speeds.  Of course, if the application
> actually obtaining the raw data is on the machine, then network perfo=
rmance
> is much less of an issue.  A database search implemented directly on =
the
> server, for example, can use every bit of performance available to th=
e local
> machine.  Given that in my case the vast majority of data is squirted=
 across
> the LAN (e.g., these are mostly file servers), anything much in exces=
s of
> 120MBps is irrelevant.  I mean, yeah, it=92s a rather nice feeling th=
at my
> RAID arrays can deliver more than 450MBps if they are ever called upo=
n to do
> so, but with a 1G LAN, that's not going to happen very often.  I just=
 wonder
> how many people who complain of poor performance can really benefit a=
ll that
> much from increased performance?

10 Gbit/s connections are getting commonplace these days, at least in t=
he
environments that I operate in.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
