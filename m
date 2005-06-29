From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Wed, 29 Jun 2005 10:40:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0506291027460.26718-100000@firewall2.tmr.com>
References: <42C226B9.4000504@nighthawkrad.net>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C226B9.4000504@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2005, Christopher Smith wrote:

> > Personally, I wouldn't mess with iSCSI or GNBD. You don't need GNBD in 
> > this scenario anyway; simple nbd (which is in the mainline kernel...get 
> > the userland tools at sourceforge.net/projects/nbd) will do just fine, 
> > and I'd be willing to bet that it is more stable and faster...
> 
> I'd briefly tried nbd, but decided to look elsewhere since it needed to 
> much manual configuration (no included rc script, /dev nodes appear to 
> have to be manually created - yes, I'm lazy).

Based on one test of nbd, it seems to be stable. I did about what you are 
trying, a RAID1 to create an md device, then did an encrypted filesystem 
on it. My test was minor, throw a lot of data at it, check that it is 
there (md5sum), reboot and verify everything still works, drop the local 
drive and rebuild. I did NOT try a rebuild on the nbd drive.

> 
> I've just finished trying NBD now and it seems to solve both my problems 
> - rebuild speed is a healthy 40MB/sec + and the failures are dealt with 
> "properly" (ie: the md device goes into degraded mode if a component nbd 
> suddenly disappears).  This looks like it might be a goer for the disk 
> node/RAID-over-network back-end.

I failed it manually, can't say what pulling the plug will do. Glad it's 
working, I may be doing this on a WAN in the fall.

-- 
bill davidsen <davidsen@tmr.com>

