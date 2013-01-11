From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 11:52:17 -0700
Message-ID: <201301111152.17571.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri Jan 11, 2013, Chris Murphy wrote:
> On Jan 11, 2013, at 10:39 AM, Chris Murphy <lists@colorremedies.com> wrote:
> > They probably have a high ERC time out as all consumer disks do so you
> > should also check /sys/block/sdX/device/timeout and make sure it's not
> > significantly less than the drive. It may be possible for smartctl or
> > hdparm to figure out what the drive ERC timeout is.
> > 
> > http://cgi.csc.liv.ac.uk/~greg/projects/erc/
> 
> Actually what I wrote is misleading to the point it's wrong. You want the
> linux device time out to be greater than the device timeout. The device
> needs to be allowed to give up, and report back a read error to linux/md,
> so that md knows it should reconstruct the missing data from parity, and
> overwrite the (obviously) bad blocks causing the read error.
> 
> If the linux device time out is even a little bit less than the drive's
> timeout, md never gets the sector read error, doesn't repair it, since
> linux boots the whole drive. Now instead of repairing a few sectors, you
> have a degraded array on your hands. Usual consumer drive time outs are
> quite high, they can be up to a couple minutes long. Linux device time out
> is 30 seconds.
> 

Hm, ok. I'll look into that, and set those up properly.

Thanks.

> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
