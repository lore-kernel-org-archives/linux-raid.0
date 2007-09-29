From: Chris Snook <csnook@redhat.com>
Subject: Re: Bonnie++ with 1024k stripe SW/RAID5 causes kernel to goto D-state
Date: Sat, 29 Sep 2007 14:33:52 -0400
Message-ID: <46FE9A90.8040402@redhat.com>
References: <Pine.LNX.4.64.0709291306320.4569@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709291306320.4569@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Kernel: 2.6.23-rc8 (older kernels do this as well)
> 
> When running the following command:
> /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 
> 16:100000:16:64
> 
> It hangs unless I increase various parameters md/raid such as the 
> stripe_cache_size etc..
> 
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       276  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
> root       277  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
> root      1639  0.0  0.0      0     0 ?        D<   12:14   0:00 [xfsbufd]
> root      1767  0.0  0.0   8100   420 ?        Ds   12:14   0:00 
> root      2895  0.0  0.0   5916   632 ?        Ds   12:15   0:00 
> /sbin/syslogd -r
> 
> See the bottom for more details.
> 
> Is this normal?  Does md only work without tuning up to a certain stripe 
> size? I use a RAID 5 with 1024k stripe which works fine with many 
> optimizations, but if I just boot the system and run bonnie++ on it 
> without applying the optimizations, it will hang in d-state.  When I run 
> the optimizations, then it exits out of D-state, pretty weird?

Not at all.  1024k stripes are way outside the norm.  If you do something way 
outside the norm, and don't tune for it in advance, don't be terribly surprised 
when something like bonnie++ brings your box to its knees.

That's not to say we couldn't make md auto-tune itself more intelligently, but 
this isn't really a bug.  With a sufficiently huge amount of RAM, you'd be able 
to dynamically allocate the buffers that you're not pre-allocating with 
stripe_cache_size, but bonnie++ is eating that up in this case.

	-- Chris
