From: "Colin Simpson" <csimpson@csl.co.uk>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 17:26:58 +0000
Message-ID: <1172510818.11898.33.camel@cowie>
References: <1172258378.21648.51.camel@cowie> <45DF46B7.3040707@maine.edu> <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz> <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mon, 2007-02-26 at 08:56 -0800, David Rees wrote:
>
> > You could configure smartd to do regular long selftests, which would
> > notify you on failures and allow you to take the drive offline and dd,
> > replace etc.
> 
> So what do you do when your drives in your array don't support SMART
> self tests for some reason?
> 
> The best solution I have thought of so far is to do a `dd if=/dev/mdX
> of=/dev/null` periodically, but this isn't as nice as running a check
> in the later kernels as it's not guaranteed to read blocks from all
> disks. I guess you could instead do the same thing but with the
> underlying disks instead of the raid device, then make sure you watch
> the logs for disk read errors.
> 
> -Dave

SATA isn't supported on RH 4's SMART.

If I say, 

dd if=/dev/sda2 of=/dev/null

where /dev/sda2 is a component of an active md device.

Will the RAID subsystem get upset that someone else is fiddling with the
disk (even in just a read only way)? And will a read error on this dd
(caused by a bad block) cause md to knock out that device?

Thanks

Colin

This email and any files transmitted with it are confidential and are intended solely for the use of the individual or entity to whom they are addressed.  If you are not the original recipient or the person responsible for delivering the email to the intended recipient, be advised that you have received this email in error, and that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. If you received this email in error, please immediately notify the sender and delete the original.


