From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.2 - kexec problem/bug
Date: Tue, 24 Jan 2006 14:08:58 +1100
Message-ID: <17365.39498.479748.569207@cse.unsw.edu.au>
References: <20060123125406.2055fd44@snibbles.dedenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario  =?ISO-8859-1?Q?=20D=F6ring?= on Monday January 23
Sender: linux-raid-owner@vger.kernel.org
To: Mario =?UTF-8?B?RMO2cmluZw==?= <mario@dedenet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 23, mario@dedenet.de wrote:
> Hello :)
> 
> when rebooting my gentoo system with mdadm-2.2, I get the following
> error message on shutdown:
> 
> mdadm: fail to stop array /dev/md0: Device or resource busy
> md0 is my root partition
> 
> 
> /dev/md0 is my root parition.
> 
> That is no problem with a real reboot or shutdown.
> 
> 
> But with a "kexec reboot" the rebooted kernel hangs with
> several dma and irq errors.
> 
> The problem does not exist in version mdadm-2.1
> 

This does not sound at all like it could be an mdadm issue.  If you
are getting dma and irq errors then I suspect some low lever device
driver is misbehaving or getting confused by kexec.

> 
> I am not sure if this is the right place for reporting this issue..

A good place to start, but I don't think you'll find the answer here.  
If there is a 'kexec' mailing list, try there, otherwise
linux-kernel@vger.kernel.org.
Also, include lots more details.  Precise error messages, what sorts
of drives and controllers you have, and the exact sequence of events.

NeilBrown


> 
> 
> Regards,
> Mario.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
