From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 22 Jan 2013 01:40:39 +1100
Message-ID: <20130121144039.GA4103@rabbit.us>
References: <20130115125507.GA12184@rabbit.us>
 <50F614F7.20104@hardwarefreak.com>
 <20130116025857.GA31112@rabbit.us>
 <50F70DB7.6020104@hardwarefreak.com>
 <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com>
 <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
 <50F9D32F.7090606@hardwarefreak.com>
 <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
 <20732.17741.587765.199649@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20732.17741.587765.199649@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for the thorough reply. While I agree with *most* of what
you say I have a comment and a followup question below.

On Sun, Jan 20, 2013 at 07:28:13PM +0000, Peter Grandi wrote:
> [ ... the original question on 2+2 RAID delivering 2x linear
> transfers of 1x linear transfers ... ]
> 
> The original question was based on the (euphemism) very peculiar
> belief that skipping over P/Q blocks has negligible cost.

I was indeed very surprised to find out that the skipping is *not* free. 
I am planning to do some research on whether it is possible to use 
specific chunksizes so that when laid out on top of the physical media 
the "skip penalty" is minimized. This will probably take me a while, but 
I will come back to this thread with the results eventually.

> Getting back to RAID, I feel (euphemism) dismayed when I read
> (euphemism) superficialities like:
> 
>   "raid6 can lose any random 2 drives, while raid10 can't."
> 
> because they are based on the (euphemism) disregard of the very
> many differences between the two, and that what matters is the
> level of reliability and performance achievable with the same
> budget. Because ultimately it is reliability/performance per
> budget that matters, not (euphemism) uninformed issues of mere
> geometry.

I am not sure what you are saying... I see raid as a way for me to keep 
a higher layer "online", while some of the physical drives fall on the 
floor. In the case of 4 drives (very typical for mom&pop+consultant 
shops with near-sufficient expertise but far-insufficient funds) a raid6 
is the more obvious choice as it provides the array size of 2xdrives, 
with reasonable redundancy (*ANY* 2 drives), and reasonable-ish 
read/write rates in normal operation. With the prospect of minimizing the 
skip-penalty the read rate (which is what matters, again, in most cases) 
will go even higher.

By the way "normal operation" is what I am basing my observation on, 
because a degraded raid does not run for years without being taken care 
of. If it does - someone is doing it wrong. Besides with raid6 the 
degradation of operational speeds will be a contributing factor to 
repair the array *sooner*.

Compare to raid10, which has better read characteristics, but in order 
to reach the "any 2 drives" bounty, one needs to assemble a -l 10 -n 4 
-p f3, which isn't... very optimal (mom&pop just went from 2xsize to 
1.3xsize).

From your comment above I gather you disagree with this. Can you 
elaborate more on the economics of mom&pop installations, and how my 
assesment is (euphemism) wrong? :)

Cheers

