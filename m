From: Andy Smith <andy@strugglers.net>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Thu, 10 Oct 2013 20:37:50 +0000
Message-ID: <20131010203750.GV1779@bitfolk.com>
References: <20131009123135.GT1779@bitfolk.com>
 <5256701C.3090807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5256701C.3090807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

(Thanks everyone else who's responded so far, too -- I'm paying
attention with interest)

On Thu, Oct 10, 2013 at 04:15:08AM -0500, Stan Hoeppner wrote:
> On 10/9/2013 7:31 AM, Andy Smith wrote:
> > Are there any gotchas to be aware of? I haven't much experience with
> > SSDs.
> 
> Yes, there is one major gotcha WRT md/RAID and SSDs, which to this point
> nobody has mentioned in this thread, possibly because it pertains to
> writes, not reads.  Note my question posed to you up above.  Since I've
> answered this question in detail at least a dozen times on this mailing
> list, I'll simply refer you to one of my recent archived posts for the
> details:
> 
> http://permalink.gmane.org/gmane.linux.raid/43984

When I first read that link I thought perhaps you were referring to
write performance dropping off a cliff due to SSD garbage caching
routines that kicked in, but then I read the rest of the thread and
I think maybe you were hinting at the single write thread issue you
talk about more in:

    http://www.spinics.net/lists/raid/msg44211.html

Is that the case?

> To be clear, the need for careful directory/file layout to achieve
> parallel throughput pertains only to the linear concatenation storage
> architecture described above.  If one is using XFS atop a striped array
> then throughput, either sequential or parallel, is -not- limited by
> file/dir placement across the AGs, as all AGs are striped across the disks.

So, in summary do you recommend the stacked RAID-0 on top of RAID-1
pairs instead of a RAID-10, where write performance may otherwise be
bottlenecked by md's single write thread?

Write ops are a fraction of the random reads and using RAID with a
battery-backed write cache solved that problem, but it does need to
scale linearly with whatever improvement we can get for the read
ops, so I would think it will still be something worth thinking
about, so thanks for pointing that out.

Thanks,
Andy
