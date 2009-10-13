From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 12:34:27 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0910131229400.5824@uplift.swm.pp.se>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com> <4AD3F64F.6070908@sauce.co.nz> <4AD454A0.3050704@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD454A0.3050704@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 13 Oct 2009, Asdo wrote:

> I have heard mixed opinions about 3wares. What are the fastest 
> controllers around for MD-raid use?

The 3wares are not the fastest around, I don't even get the performance 
you're describing. I use them because I can get them cheap on the used 
market and because they're stable.

There are plenty of articles around describing read/write latency for the 
3wares as one part of the problem. Just to put into perspective, I get 
approx 5-10 megabyte/s write performance on a 3ware 9500S hw-raid5 with 
ext3, whereas I get at least 10x times that for read. The performance with 
dd directly to the device is 100+ megabyte/s though, it's just thru the fs 
it is slow.

The 3wares usually work better if you single disk them and use md, then I 
get 30-50 megabyte/s write performance thru the fs anyway, which is what I 
guess you do as well.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
