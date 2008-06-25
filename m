From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10 raptors])
Date: Wed, 25 Jun 2008 21:44:18 +0200
Message-ID: <20080625194418.GC23500@rap.rap.dk>
References: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com> <alpine.DEB.1.00.0804020812170.4198@p34.internal.lan> <20080402080206.6bd8ea65@hardcode42.net> <alpine.DEB.1.00.0804021344180.4140@p34.internal.lan> <alpine.DEB.1.00.0804021349130.4140@p34.internal.lan> <20080403100246.GA16459@rap.rap.dk> <20080625184838.GB21707@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CDBC715@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97CDBC715@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, "Conway S. Smith" <beolach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 25, 2008 at 02:09:32PM -0500, David Lethe wrote:
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Wednesday, June 25, 2008 1:49 PM
> To: Justin Piszcz
> Cc: Conway S. Smith; linux-raid@vger.kernel.org
> Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/1=
0 raptors])
>=20
> > On Thu, Apr 03, 2008 at 12:02:46PM +0200, Keld J=F8rn Simonsen wrot=
e:
> > > On Wed, Apr 02, 2008 at 01:49:44PM -0400, Justin Piszcz wrote:
> > > >=20
> > > >=20
> > > > On Wed, 2 Apr 2008, Justin Piszcz wrote:
> > > >=20
> > > > >
> > > > >
> > > > >On Wed, 2 Apr 2008, Conway S. Smith wrote:
> > >=20
> > > I have referenced both of your benchmaks in the wiki on performan=
ce. So
> > > now I just hope that your URLs will live forever. I also took dow=
n some
> > > of your recomendations there.=20
> > >=20
> > > I note that raid10,f2 has a much higher cpu load than raid10,n2 o=
r
> > > raid10,o2. How come? it is 31-38 % for f2, where n2 and o2 is aro=
und 15 %.
> >
> > I found a reason for this, it seems that CPU usage and IO speed are=
 very
> > related, so because the raid10,f2 has about double the IO performan=
ce
> > for sequential reading, it also has about double the cpu use.
> >
> > Justin's benchmark is on http://home.comcast.net/~jpiszcz/20080329-=
raid/
> >
> > Another of Justin's benchmarks also reveals the relation between
> > IO rate and CPU use:
> > http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> >
> > Why does IO use that much CPU? Is it mostly moving around the data =
from
> > the kernel to the user space? Does it matter here whether one is ru=
nning
> > a 32 bit or a 64 bit system?
>=20
> > It seems like the RAM bus can be a bottleneck. I read that DDR-400
> > can have a peak performance of 1600 MB/s. If this is halved on 32 b=
it OS
> > then this is 800 MB/s. And you need to both read and write when you=
 move
> > things around. So that is 400 MB/s... And you need to still be able=
 to=20
> > read in from the disk controller at 330 MB/s. For 64 bit systems th=
is is
> > a max around 400 MB/s - given that there is a flow from the disk
> > controller to system disk buffers, then from kernel buffers to user
> > buffers and then from user buffers to some processing. Or am I wron=
g
> > here?
> >
> > Best regards
> > Keld
>=20
> These chunk sizes are profoundly meaningless if you plan on using the=
m to estimate performance in the real world.   The relationship between=
 IO rate, IO throughput, and CPU overhead will be dramatically differen=
t with default md settings.  Also consider that your kernel was recompi=
led with little or no cpu-specific optimization, so you are wasting cpu=
 cycles .. and don't get me started on multicore vs. single core for su=
ch benchmarks.

I think something is wrong with the chunk sizes. 16 G and 7 G are most
likely erroneous. Justin?

David, if you have some benchmarks then please feel free to report them=
=2E

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
