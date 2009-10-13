From: Asdo <asdo@shiftmail.org>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 16:49:53 +0200
Message-ID: <4AD49391.9000308@shiftmail.org>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
 <4AD3F64F.6070908@sauce.co.nz> <4AD454A0.3050704@shiftmail.org>
 <alpine.DEB.1.10.0910131229400.5824@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.0910131229400.5824@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> There are plenty of articles around describing read/write latency for 
> the 3wares as one part of the problem. 
I saw them, but those articles I found refer to the older 3wares, the 
9500 like the one you have, and in fact it seems the 9500 has a very bad 
performance from what you describe
> Just to put into perspective, I get approx 5-10 megabyte/s write 
> performance on a 3ware 9500S hw-raid5 with ext3, whereas I get at 
> least 10x times that for read. The performance with dd directly to the 
> device is 100+ megabyte/s though, it's just thru the fs it is slow.
>
> The 3wares usually work better if you single disk them and use md, 
> then I get 30-50 megabyte/s write performance thru the fs anyway, 
> which is what I guess you do as well.
Well, much more than 30-50MB/sec that as I wrote, about 185MB/sec with 
xfs, and the overall write speed raises to about 330MB/sec if there are 
multiple simultaneous write requests from multiple processes.
I'd guess either the 3ware 9500 is very bad (likely) or you are not 
using xfs, or it's not aligned, or you haven't upped the 
stripe_cache_size...

But anyway...
Anybody here tried multiple controller cards and can make a suggestion 
on a controller that is fast for linux MD use? (having at least 16 ports 
if possible)

Thank you
