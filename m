From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10 raptors])
Date: Wed, 25 Jun 2008 20:48:38 +0200
Message-ID: <20080625184838.GB21707@rap.rap.dk>
References: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com> <alpine.DEB.1.00.0804020812170.4198@p34.internal.lan> <20080402080206.6bd8ea65@hardcode42.net> <alpine.DEB.1.00.0804021344180.4140@p34.internal.lan> <alpine.DEB.1.00.0804021349130.4140@p34.internal.lan> <20080403100246.GA16459@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080403100246.GA16459@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Conway S. Smith" <beolach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 03, 2008 at 12:02:46PM +0200, Keld J=F8rn Simonsen wrote:
> On Wed, Apr 02, 2008 at 01:49:44PM -0400, Justin Piszcz wrote:
> >=20
> >=20
> > On Wed, 2 Apr 2008, Justin Piszcz wrote:
> >=20
> > >
> > >
> > >On Wed, 2 Apr 2008, Conway S. Smith wrote:
>=20
> I have referenced both of your benchmaks in the wiki on performance. =
So
> now I just hope that your URLs will live forever. I also took down so=
me
> of your recomendations there.=20
>=20
> I note that raid10,f2 has a much higher cpu load than raid10,n2 or
> raid10,o2. How come? it is 31-38 % for f2, where n2 and o2 is around =
15 %.

I found a reason for this, it seems that CPU usage and IO speed are ver=
y
related, so because the raid10,f2 has about double the IO performance
for sequential reading, it also has about double the cpu use.

Justin's benchmark is on http://home.comcast.net/~jpiszcz/20080329-raid=
/

Another of Justin's benchmarks also reveals the relation between
IO rate and CPU use:
http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html

Why does IO use that much CPU? Is it mostly moving around the data from
the kernel to the user space? Does it matter here whether one is runnin=
g
a 32 bit or a 64 bit system?

It seems like the RAM bus can be a bottleneck. I read that DDR-400
can have a peak performance of 1600 MB/s. If this is halved on 32 bit O=
S
then this is 800 MB/s. And you need to both read and write when you mov=
e
things around. So that is 400 MB/s... And you need to still be able to=20
read in from the disk controller at 330 MB/s. For 64 bit systems this i=
s
a max around 400 MB/s - given that there is a flow from the disk
controller to system disk buffers, then from kernel buffers to user
buffers and then from user buffers to some processing. Or am I wrong
here?

Best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
