From: Nathan Hunsperger <linux-raid@hunsperger.com>
Subject: Re: Bizarre RAID "failure"
Date: Fri, 20 Feb 2004 00:33:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040220083327.GB5535@munchnet.com>
References: <1077230692.28817.485.camel@s8n-1.thereinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1077230692.28817.485.camel@s8n-1.thereinc.com>
To: Tom Maddox <tmaddox@thereinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 19, 2004 at 02:44:52PM -0800, Tom Maddox wrote:
<SNIP>
> If the system goes down unexpectedly (e.g., because of a power failure),
> the RAID array comes back up dirty and begins to rebuild itself, which
> is odd enough on its own.  What's worse is that, whenever this happens,
> the rebuild hangs at about 2.4%.  When it reaches that point, the array
> becomes totally nonresponsive--I can't even query its status with mdadm
> or any other tool, although I can use "cat /proc/mdstat" to see the
> status of the rebuild.  Any command that attempts to access the RAID
> drive hangs.
<SNIP>
> Has anyone seen this behavior before, and can you recommend a solution?

Tom,

I have had problems very similar to this before.  I was running 14 fibre
channel disks on a QLA2100 HBA w/ various 2.4 kernels.  What I found
was that after a while of heavy IO, all access to the disks stopped,
and the rebuild would hang.  Additionally, any command that required
access to any filesystem data that wasn't cached (on any filesystem)
would hang.  By switching between the 3 or so available QLA drivers,
I could affect the delta between reboot and stall.  I knew the hardware
was fine, as it worked flawlessly under Solaris.  In the end, I had
to upgrade the HBA to a QLA2200, at which time I had no more problems.
Because the hardware works under different OSs, I have to believe that
my problem was an incompatability between the QLA2100 and the drivers
(even though they claimed to work for it).

I hope that at least gives you some possible insight.

- Nathan

> 
> Thanks,
> 
> Tom
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
