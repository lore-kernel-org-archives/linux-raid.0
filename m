From: Neil Brown <neilb@suse.de>
Subject: Re: Failed RAID5 array grow after reboot interruption; mdadm: Failed to restore critical section for reshape, sorry.
Date: Thu, 19 Jun 2008 14:25:34 +1000
Message-ID: <18521.57278.92951.935685@notabene.brown>
References: <3E998AD6CC01E746957550D4CD642A742303F8@TGEN-M2.ad.tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jmolina@tgen.org on Monday June 16
Sender: linux-raid-owner@vger.kernel.org
To: jmolina@tgen.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 16, jmolina@tgen.org wrote:
> 
> During the grow process, this system slowly went unresponsive, and I
> was forced to reboot it after about 30 hours.  At first I was not
> able to run any mdadm commands to see the status of the grow (about
> 30 minutes after starting), then I was not able to log in with a new
> shell, then after about 24 hours I was able to use a previously
> opened shell to see that tons of CRON jobs and other work had backed
> up, however during all of this time the system was still acting as
> an IP router doing NAT.  Finally, after about 30 hours, the dhcpd
> daemon stopped giving out leases and then finally traffic stopped
> and I could not ping the host any longer (not a lease problem). 

This is a bit of a worry.  It sounds like the system was running out
of memory.  It would seem to suggest that either the reshape process
was leaking memory, or that it was blocking writeout somehow so that
other memory wasn't getting freed.
However I cannot measure it doing either of these things.

If you can reproduce this, I'd love to see the content of
   /proc/meminfo
   /proc/slabinfo
   /proc/slab_allocators

at 5 minutes intervals.   But I don't expect you'll want to try that
experiment :-)


NeilBrown
