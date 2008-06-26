From: "David Lethe" <david@santools.com>
Subject: Re: [PATCH] disable queue flag test in barrier check
Date: Thu, 26 Jun 2008 10:24:00 -0500
Message-ID: <22f301c8d7a0$c5e87fc0$9201a8c0@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe
List-Id: linux-raid.ids

Unflushed writes are 100% effective for losing data and corrupting file systems.  Data isn't saved until it is on the magnetic media.  Batterybackup modules for disk controllers help, but there is no substitute for a ups.  Even with a bbu on disk controller, if the kernel hasn't flushed write to the controller, and system crashes or loses power, the kernel io queue will never reach the controllers bbu.

You have a moral obligation to use a ups... And if you work for a US company, then Sarbox pretty much makes this a legal obligation and a criminal offense if you don't protect certain databases with something as reasonable and cheap as a ups

-----Original Message-----

From:  "Eric Sandeen" <sandeen@sandeen.net>
Subj:  Re: [PATCH] disable queue flag test in barrier check
Date:  Thu Jun 26, 2008 9:57 am
Size:  1K
To:  "David Lethe" <david@santools.com>
cc:  "Timothy Shimmin" <tes@sgi.com>; "xfs-oss" <xfs@oss.sgi.com>; "LinuxRaid" <linux-raid@vger.kernel.org>; "NeilBrown" <neilb@suse.de>; "jeremy@sgi.comwe" <jeremy@sgi.comwe>

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
 


