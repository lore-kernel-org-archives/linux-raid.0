From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: 3ware RAID (was Re: RAID resync stalled at 99.7% ?)
Date: Sat, 03 Sep 2005 01:29:07 +1000
Message-ID: <43186FC3.30601@nighthawkrad.net>
References: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net> <87vf1jsqjj.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vf1jsqjj.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Pittman wrote:
> Christopher Smith <csmith@nighthawkrad.net> writes:
> 
> [...]
> 
> 
>>The components are 12x400GB drives attached to a 3ware 9500s-12
>>controller.  They are configured as "single disks" on the controller,
>>ie: no hardware RAID is involved.
> 
> 
> A quick question for you, because I have a client looking at 3ware RAID
> hardware at the moment:
> 
> Why are you running this as software RAID, rather than using the
> hardware on the 3ware card?

Because after doing some preliminary benchmarks, I've found Linux's 
software RAID to be significantly faster than 3ware's hardware RAID (at 
the sacrifice of higher CPU usage, but since the machine has a fairly 
fast CPU and doesn't do anything else, that's a sacrifice I'm happy to 
make).

I have some iozone and bonnie++ results, but they're at work and I'm at 
home - I'll post them tomorrow.

CS
