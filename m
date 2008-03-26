From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 18:49:36 +0100
Message-ID: <20080326174936.GA18621@rap.rap.dk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com> <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com> <bb145bd20803251556pa416a0cs8350058a4216f6f9@mail.gmail.com> <47EA79D1.1090607@tmr.com> <bb145bd20803261010mfe43d25tf381e4d4392f4ed8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803261010mfe43d25tf381e4d4392f4ed8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 26, 2008 at 06:10:17PM +0100, Christian Pernegger wrote:
> >  I think that you should treat 10,n2 and 10,f2 as separate
> >  configurations,
> 
> Certainly, but f2 write performance is supposed to be even worse than
> n2 even in theory. Maybe I'll try it anyway.

Nah, raid10,n2 and raid10,f2 has about equal writing performance,
both for sequential and random writes, and according to my test,
f2 is actually a little better than n2.

> >  The ability to transfer a single copy of the data and no parity
> >  information is an advantage of hardware controllers.
> 
> The 3ware 7506-8 *is* a hardware controller and it quite obviously
> does *not* have this ability, at least not for raid10. One can just as
> well use the 3ware as a plain 8port controller and md over that,
> doesn't make much of a difference. I find that interesting.

I do not believe the 3ware controller has raid10 in the MD sense.
The raid10 that 3ware may have is most likely a raid1+0.

Best regards
keld
