From: Neil Brown <neilb@suse.de>
Subject: Re: md rotates RAID5 spare at boot
Date: Fri, 11 Jan 2008 09:01:43 +1100
Message-ID: <18310.38343.339990.718263@notabene.brown>
References: <47852984.5040707@ultralame.com>
	<4786844D.4010104@tmr.com>
	<478685DA.8070701@ultralame.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jed Davidow on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Jed Davidow <jed@ultralame.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, jed@ultralame.com wrote:
> 
> It looks to me like md inspects and attempts to assemble after each 
> drive controller is scanned (from dmesg, there appears to be a failed 
> bind on the first three devices after they are scanned, and then again 
> when the second controller is scanned).  Would the scan order cause a 
> spare to be swapped in?
> 

This suggests that "mdadm --incremental" is being used to assemble the
arrays.  Every time udev finds a new device, it gets added to
whichever array is should be in.
If it is called as "mdadm --incremental --run", then it will get
started as soon as possible, even if it is degraded.  With the
"--run", it will wait until all devices are available.

Even with "mdadm --incremental --run", you shouldn't get a resync if
the last device is added before the array is written to.

What distro are you running?
What does
   grep -R mdadm /etc/udev

show?

NeilBrown
