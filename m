From: Neil Brown <neilb@suse.de>
Subject: Re: BUG: soft lockup detected on CPU#1! (was Re: raid6 resync blocks the entire system)
Date: Thu, 22 Nov 2007 16:11:00 +1100
Message-ID: <18245.3940.225928.560543@notabene.brown>
References: <fhq60j$an9$1@ger.gmane.org>
	<200711201633.39142.bs@q-leap.de>
	<Pine.LNX.4.64.0711201125440.23485@coffee.psychology.mcmaster.ca>
	<200711201932.25258.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Tuesday November 20
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Mark Hahn <hahn@mcmaster.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday November 20, bs@q-leap.de wrote:
> 
> My personal (wild) guess for this problem is, that there is somewhere a global 
> lock, preventing all other CPUs to do something. At 100%s (at 80 MB/s) 
> there's probably not left any time frame to wake up the other CPUs or its 
> sufficiently small to only allow high priority kernel threads to do 
> something.
> When I limit the sync to 40MB/s each resync-CPU has to wait sufficiently long 
> to allow the other CPUs to wake up.
> 
> 

md doesn't hold any locks that would interfere with other parts of the
kernel from working.

I cannot imagine what would be causing your problems.  The resync
thread makes a point of calling cond_resched() periodically so that it
will let other processes run even if it constantly has work to do.

If you have nothing that could write to the RAID6 arrays, then I
cannot see how the resync could affect the rest of the system except
to reduce the amount of available CPU time.  And as CPU is normally
much faster than drives, you wouldn't expect that effect to be very
great.

Very strange.

Can you do 'alt-sysrq-T' when it is frozen and get the process traces
from the kernel logs?

Can you send me "cat /proc/mdstat" after the resyn has started, but
before the system has locked up.

I'm sorry that I cannot suggest anything more useful.

NeilBrown

