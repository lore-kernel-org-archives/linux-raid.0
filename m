From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 000 of 6] md: Assorted fixes and features for md for 2.6.21
Date: Tue, 20 Feb 2007 18:22:36 -0500
Message-ID: <45DB82BC.60805@tmr.com>
References: <20070220172544.15678.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070220172544.15678.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Following 6 patches are against 2.6.20 and are suitable for 2.6.21.
> They are not against -mm because the new plugging makes raid5 not work
> and so not testable, and there are a few fairly minor intersections between
> these patches and those patches.
> There is also a very minor conflict with the hardware-xor patches - one line
> of context is different.
>
> Patch 1 should probably go in -stable - the bug could cause data
> corruption in a fairly uncommon raid10 configuration, so that one and
> this intro are Cc:ed to stable@kernel.org.
>
> Thanks,
> NeilBrown
>
>
>  [PATCH 001 of 6] md: Fix raid10 recovery problem.
>  [PATCH 002 of 6] md: RAID6: clean up CPUID and FPU enter/exit code
>  [PATCH 003 of 6] md: Move warning about creating a raid array on partitions of the one device.
>  [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
>  [PATCH 005 of 6] md: Restart a (raid5) reshape that has been aborted due to a read/write error.
>  [PATCH 006 of 6] md: Add support for reshape of a raid6

Every month or so there are a bunch of patches like this, which do 
various enhancements to the kernel. And these are usually based against 
the release kernel, and all is fine. But every once in a while there is 
a patch which is more urgent, in this case the RAID10 one, which is 
really desirable to get into every kernel running on a machine. Are 
patches marked as needed for -stable also fast tracked to -git inclusion?

If this isn't in -git14 I'm going to rebuild with it before testing 
Neil's NFS stuff. The NFS server test data is on RAID10 ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

