From: Gordon Henderson <gordon@drogon.net>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 19:37:43 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501201933180.12589@lion.drogon.net>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
 <Pine.LNX.4.56.0501201805070.12589@lion.drogon.net> <41EFFA53.3030809@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EFFA53.3030809@mvista.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Bellon <mbellon@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 Jan 2005, Mark Bellon wrote:

> I've seen this too. The worst case can actually last for over 2 minutes.
>
> We've been running with a patch to the RAID 1 driver that handles this
> so critical applications do not hang for too long. Basically it uses
> timers in the RAID 1 driver to force the disk to be treated as actually
> having failed if it doesn't respond within a reasonable time (tunable
> but usually ~3 seconds). It then handles the I/O requests coming back
> async. and does the clean up.

This is intersting, but make it an option (kernel compile, sysctl,
etc.)... I have a small home server/firewall that I run with the disks
spun down (noflushd) and spinning up a disk sometimes takes 8 seconds -
it's a RAID-1 set and seems to cope OK with the disks spinning down & up
again as required...

Gordon
