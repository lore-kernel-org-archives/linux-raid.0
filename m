From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] disable queue flag test in barrier check
Date: Thu, 26 Jun 2008 09:57:18 -0500
Message-ID: <4863AE4E.5060908@sandeen.net>
References: <486307EA.7080007@sandeen.net> <48635284.3060001@sgi.com> <486398B7.50306@sandeen.net> <A20315AE59B5C34585629E258D76A97CDBCF11@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97CDBCF11@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe
List-Id: linux-raid.ids

David Lethe wrote:
> Fyi - related problem is seen with solaris & zfs when users attach them
> to hardware-based RAID subsystems.  The vendors had
> to make firmware tweaks to address solaris's
> flush-to-disk-after-all-writes.  
> 
> Not sure what you mean about non-volatile vs. volatile write cache,
> however.  If you want to see if write cache is enabled on a disk drive,
> or 
> Even a logical disk on a hardware-based RAId, under Linux, then google
> "mode page editor" for lots of choices.  Also look up zfs write cache
> raid and you'll get information that you can just as easily apply to
> Linux implementations of md. 

I'm not so interested in whether it is enabled; I'd like to know if it
is safe (to varying degrees) in the event of a power failure, and I
don't think there's any way we can know that.

So the administrator, if she's sure that all cached writes will hit disk
even if a breaker pops, can disable barriers.  If it's just a 32MB cache
seagate drive plugged  into the wall, you probably had better be sure
barriers are enabled or you may well have a scrambled filesystem
post-power-outage.

-Eric
