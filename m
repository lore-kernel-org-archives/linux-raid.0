From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10
 raptors])
Date: Wed, 25 Jun 2008 15:31:38 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806251530470.832@p34.internal.lan>
References: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com> <alpine.DEB.1.00.0804020812170.4198@p34.internal.lan> <20080402080206.6bd8ea65@hardcode42.net> <alpine.DEB.1.00.0804021344180.4140@p34.internal.lan> <alpine.DEB.1.00.0804021349130.4140@p34.internal.lan>
 <20080403100246.GA16459@rap.rap.dk> <20080625184838.GB21707@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CDBC715@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1055198602-1214422298=:832"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97CDBC715@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, "Conway S. Smith" <beolach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1055198602-1214422298=:832
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 25 Jun 2008, David Lethe wrote:

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kern=
el.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Wednesday, June 25, 2008 1:49 PM
> To: Justin Piszcz
> Cc: Conway S. Smith; linux-raid@vger.kernel.org
> Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10 ra=
ptors])
>
>
> These chunk sizes are profoundly meaningless if you plan on using them to=
 estimate performance in the real world.   The relationship between IO rate=
, IO throughput, and CPU overhead will be dramatically different with defau=
lt md settings.  Also consider that your kernel was recompiled with little =
or no cpu-specific optimization, so you are wasting cpu cycles .. and don't=
 get me started on multicore vs. single core for such benchmarks.
>
>
> - David
>
>

1. In RAID5, these chunk sizes offered the best performance with bonnie++.
2. The CPU type in the config is optimized for the CPU in the host.
3. The host also runs IRQ balance.

Justin.


---1463747160-1055198602-1214422298=:832--
