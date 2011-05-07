From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm raid1 read performance
Date: Fri, 6 May 2011 22:17:26 -0500
Message-ID: <F2.07.05159.1C9B4CD4@cdptpa-omtalb.mail.rr.com>
References: <20110506215339.GA24391@www2.open-std.org>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506215339.GA24391@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Keld_J=F8rn_Simonsen'?= <keld@keldix.com>
Cc: 'NeilBrown' <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Friday, May 06, 2011 4:54 PM
> To: Leslie Rhorer
> Cc: 'Keld J=F8rn Simonsen'; 'NeilBrown'; linux-raid@vger.kernel.org
> Subject: Re: mdadm raid1 read performance
>=20
> On Fri, May 06, 2011 at 04:20:39PM -0500, Leslie Rhorer wrote:
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > > owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simonsen
> > > Sent: Thursday, May 05, 2011 6:10 AM
> > > To: NeilBrown
> > > Cc: Liam Kurmos; Roberto Spadim; Brad Campbell; Drew; linux-
> > > raid@vger.kernel.org
> > > Subject: Re: mdadm raid1 read performance
> > >
> > > On Thu, May 05, 2011 at 09:45:38AM +1000, NeilBrown wrote:
> > > > On Thu, 5 May 2011 00:08:59 +0100 Liam Kurmos
> <quantum.leaf@gmail.com>
> > > wrote:
> > > >
> > > > > as a separate question, what should be the theoretical perfor=
mance
> of
> > > raid5?
> > > >
> > > > x(N-1)
> > > >
> > > > So a 4 drive RAID5 should read at 3 time the speed of a single
> drive.
> > >
> > > Actually, theoretically, it should be more than that for reading,=
 more
> > > like N minus
> > > some overhead. In a raid5 stripe of 4 disks, when reading you do =
not
> read
> > > the checksum block, and thus you should be able to have all 4 dri=
ves
> > > occupied with reading real data. Some benchmarks back this up,
> > > http://home.comcast.net/~jpiszcz/20080329-raid/
> > > http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-
> 26255_10.html
> > > The latter reports a 3.44 times performance for raid5 reads with =
4
> > > disks, significantly over the N-1 =3D 3.0 mark.
> > >
> > > For writing, you are correct with the N-1 formular.
> >
> > 	There have been a lot of threads here about array performance, but
> > one important factor rarely mentioned in these threads is network
> > performance.  Of course, network performance is really outside the =
scope
> of
> > this list, but I frequently see people talking about performance we=
ll in
> > excess of 120MBps.  That's great, but I have to wonder if their net=
work
> > actually can make use of such speeds.  Of course, if the applicatio=
n
> > actually obtaining the raw data is on the machine, then network
> performance
> > is much less of an issue.  A database search implemented directly o=
n the
> > server, for example, can use every bit of performance available to =
the
> local
> > machine.  Given that in my case the vast majority of data is squirt=
ed
> across
> > the LAN (e.g., these are mostly file servers), anything much in exc=
ess
> of
> > 120MBps is irrelevant.  I mean, yeah, it=92s a rather nice feeling =
that my
> > RAID arrays can deliver more than 450MBps if they are ever called u=
pon
> to do
> > so, but with a 1G LAN, that's not going to happen very often.  I ju=
st
> wonder
> > how many people who complain of poor performance can really benefit=
 all
> that
> > much from increased performance?
>=20
> 10 Gbit/s connections are getting commonplace these days, at least in=
 the
> environments that I operate in.

	They are certainly not unheard-of, but I'm not sure I would call
them, "commonplace".  They are definitely not in the majority.  I work =
for a
very large national telecommunications company, and most of the links w=
e
sell are still less than 10M.  I'm not sure we have sold any full 10G
network links, at all, although we have certainly sold a number of 2G -=
 4G
links.  Of course, WAN and SAN applications are always more expensive t=
han
LAN applications, so many companies have large intra-site links but
comparatively small inter-site links.  Our customer backbone, of course=
, is
much, much higher than 10G, but none of our internal LAN links at any o=
f our
locations is more than 1G.  Most are 100M.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
