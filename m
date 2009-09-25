From: Neil Brown <neilb@suse.de>
Subject: Re: md data-check causes soft lockup
Date: Fri, 25 Sep 2009 16:54:10 +1000
Message-ID: <19132.26898.341533.52076@notabene.brown>
References: <4AB7C11E.60801@howardsilvan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lee Howard on Monday September 21
Sender: linux-raid-owner@vger.kernel.org
To: Lee Howard <faxguy@howardsilvan.com>
Cc: dan.j.williams@intel.com, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 21, faxguy@howardsilvan.com wrote:
> Linux software RAID maintainers and developers,
> 
> Two months ago I wrote to the Linux kernel mailing list regarding a 
> condition expressed as "BUG: soft lockup - CPU#3 stuck for 61s!".  I 
> initially battled this recurring problem in both Fedora 10 and Fedora 
> 11.  Rafael J. Wysocki suggested that I update the kernel (to 2.6.31-rc4 
> or later) and see if the problem resurfaced.  I then used kernel 
> 2.6.31-0.94.rc4.fc12.x86_64 and found that the problem still continued, 
> but noticeably only when the md data-check process was run.
> 
> You can read the last post to the LKML thread (with links to the entire 
> thread) here:
> 
> http://lkml.org/lkml/2009/8/6/387

Thanks for the report.

It looks like the difference between the cpu/RAM speed and the drive
speed is small enough that the CPU gets stuck comparing lots of blocks
for multiple seconds.

This patch should fix it.  I'll see that it goes upstream.

NeilBrown

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1703,6 +1703,7 @@ static void raid1d(mddev_t *mddev)
 				generic_make_request(bio);
 			}
 		}
+		cond_resched();
 	}
 	if (unplug)
 		unplug_slaves(mddev);
