From: Neil Brown <neilb@suse.de>
Subject: Re: md rotates RAID5 spare at boot
Date: Fri, 11 Jan 2008 11:22:48 +1100
Message-ID: <18310.46808.422657.207784@notabene.brown>
References: <47852984.5040707@ultralame.com>
	<4786844D.4010104@tmr.com>
	<478685DA.8070701@ultralame.com>
	<18310.38343.339990.718263@notabene.brown>
	<47869D2C.7020805@ultralame.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jed Davidow on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Jed Davidow <jed@ultralame.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, jed@ultralame.com wrote:
> distro: Ubuntu 7.10
> 
> Two files show up...
> 
> 85-mdadm.rules:
> # This file causes block devices with Linux RAID (mdadm) signatures to
> # automatically cause mdadm to be run.
> # See udev(8) for syntax
> 
> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
>         RUN+="watershed /sbin/mdadm --assemble --scan --no-degraded"
....
> 
> I see.  So udev is invoking the assemble command as soon as it detects 
> the devices.  So is it possible that the spare is not the last drive to 
> be detected and mdadm assembles too soon?

The "--no-degraded' should stop it from assembling until all expected
devices have been found.  It could assemble before the spare is found,
but should not assemble before all the data devices have been found.

The "dmesg" trace you included in your first mail doesn't actually
show anything wrong - it never starts and incomplete array.
Can you try again and get a trace where there definitely is a rebuild
happening.

And please don't drop linux-raid from the 'cc' list.

NeilBrown
