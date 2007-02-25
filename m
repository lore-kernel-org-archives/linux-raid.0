From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Sun, 25 Feb 2007 17:14:00 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251643250.21918@coffee.psychology.mcmaster.ca>
References: <45D89FF5.3020303@sauce.co.nz> <200702252057.22963.a1426z@gawab.com>
 <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca>
 <200702260007.10205.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200702260007.10205.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>  	and none of those can be assumed to be independent.  those are the
>>  	"real reasons", but most can't be measured directly outside a lab
>>  	and the number of combinatorial interactions is huge.
>
> It seems to me that the biggest problem are the 7.2k+ rpm platters
> themselves, especially with those heads flying closely on top of them.  So,
> we can probably forget the rest of the ~1k non-moving parts, as they have
> proven to be pretty reliable, most of the time.

donno.  non-moving parts probably have much higher reliability, but 
so many of them makes them a concern.  if a discrete resistor has 
a 1e9 hour MTBF, 1k of them are 1e6 and that's starting to approach
the claimed MTBF of a disk.  any lower (or more components) and it
takes over as a dominant failure mode...

the Google paper doesn't really try to diagnose, but it does indicate
that metrics related to media/head problems tend to promptly lead to failure.
(scan errors, reallocations, etc.)  I guess that's circumstantial support
for your theory that crashes of media/heads are the primary failure mode.

>>  	- factorial analysis of the data.  temperature is a good
>>  	example, because both low and high temperature affect AFR,
>>  	and in ways that interact with age and/or utilization.  this
>>  	is a common issue in medical studies, which are strikingly
>>  	similar in design (outcome is subject or disk dies...)  there
>>  	is a well-established body of practice for factorial analysis.
>
> Agreed.  We definitely need more sensors.

just to be clear, I'm not saying we need more sensors, just that the 
existing metrics (including temp and utilization) need to be considered
jointly, not independently.  more metrics would be better as well,
assuming they're direct readouts, not idiot-lights...

>>  	and performance under the normal workload would also help.
>
> Are you saying, you are content with pre-mature disk failure, as long as
> there is a smart warning sign?

I'm saying that disk failures are inevitable.  ways to reduce the chance
of data loss are what we have to focus on.  the Google paper shows that 
disks like to be at around 35C - not too cool or hot (though this is probably
conflated with utilization.)  the paper also shows that warning signs can 
indicate a majority of failures (though it doesn't present the factorial 
analysis necessary to tell which ones, how well, avoid false-positives, etc.)

> I think the sensors should trigger some kind of shutdown mechanism as a
> protective measure, when some threshold is reached.  Just like the
> protective measure you see for CPUs to prevent meltdown.

but they already do.  persistent bad reads or writes to a block will trigger
its reallocation to spares, etc.  for CPUs, the main threat is heat, and it's 
easy to throttle to cool down.  for disks, the main threat is probably wear, 
which seems quite different - more catastrophic and less mitigatable
once it starts.

I'd love to hear from an actual drive engineer on the failure modes 
they worry about...

regards, mark hahn.
