From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10
 raptors])
Date: Thu, 3 Apr 2008 06:26:12 -0400 (EDT)
Message-ID: <alpine.DEB.1.00.0804030625020.14822@p34.internal.lan>
References: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com> <alpine.DEB.1.00.0804020812170.4198@p34.internal.lan> <20080402080206.6bd8ea65@hardcode42.net> <alpine.DEB.1.00.0804021344180.4140@p34.internal.lan> <alpine.DEB.1.00.0804021349130.4140@p34.internal.lan>
 <20080403100246.GA16459@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-834826048-1207218372=:14822"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080403100246.GA16459@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: "Conway S. Smith" <beolach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-834826048-1207218372=:14822
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 3 Apr 2008, Keld J=F8rn Simonsen wrote:

> On Wed, Apr 02, 2008 at 01:49:44PM -0400, Justin Piszcz wrote:
>>
>>
>> On Wed, 2 Apr 2008, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Wed, 2 Apr 2008, Conway S. Smith wrote:
>
> I have referenced both of your benchmaks in the wiki on performance. So
> now I just hope that your URLs will live forever. I also took down some
> of your recomendations there.
>
> I note that raid10,f2 has a much higher cpu load than raid10,n2 or
> raid10,o2. How come? it is 31-38 % for f2, where n2 and o2 is around 15 %
>
> Also I note that the sequential read rate for o2 is nowhere near that of
> n2, it is more like half of the n2 speed. I have seen claims from
> normally trustworthy sources that o2 would obtain striping speeds.
> IMHO theory would also say that o2 could not be striping.
>
> And the optimized version from Justin impedes performance for f2, by
> around 90 MB/s. How come?
This may be due to the optimizations I use (for RAID5) in general they=20
apply to RAID10 somewhat but in some cases it impedes performance greately=
=20
where the opposite is true of RAID5, if the optimizations are not in=20
place, its nearly twice as slow.

Justin.

---1463747160-834826048-1207218372=:14822--
