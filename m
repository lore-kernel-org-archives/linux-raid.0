From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch v5 1/1] md: Software Raid autodetect dev list not array
Date: Wed, 29 Aug 2007 08:18:18 -0700
Message-ID: <46D58E3A.9000704@oracle.com>
References: <200708222058.45480.mjevans1983@comcast.net> <4877c76c0708281211s55aded4ajceb283da25223659@mail.gmail.com> <46D4748A.4070909@oracle.com> <200708290106.06945.mjevans1983@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200708290106.06945.mjevans1983@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Michael J. Evans" <mjevans1983@comcast.net>
Cc: Michael Evans <mjevans1983@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-raid.ids

Michael J. Evans wrote:
> From: Michael J. Evans <mjevans1983@gmail.com>
> 
> In current release kernels the md module (Software RAID) uses a static array
>  (dev_t[128]) to store partition/device info temporarily for autostart.
> 
> This patch replaces that static array with a list.
> 
> Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>
> --- 

So only the text above goes into the permanent changelog (if it's
used as is).  That text tells what the patch does but not why it
does it.  Telling why is more important.  Some of the text below
should be moved up to the changelog area, possibly with some other
editing for readability (see BEGIN/END below).

> CCing akpm@linux-foundation.org
> 
> Version 5:
> patched modified to cleanly patch against 2.6.23-rc4 (Offsets only)
> Removed credit from head of file since the changelogs are archived.
> 
> Version 4:
> Minor formatting cleanup for kzAlloc error message.
> Should I remove the first patch section in version 5?
> 
> Version 3:
> md_autodetect_dev failure message is now more usefully verbose.
> removed unused i_found that was leftover from initial verification.
> Thank you Randy Dunlap for pointing where INT_MAX was, fixme fixed.
> 
> Version 2:
> using list_add_tail, and corrected missing i_passed++;.
> removed sections of code that would never be reached.
> 
> Version 1:
> The data/structures are only used within md.c, and very close together.
> However I wonder if the structural information shouldn't go in to...
> ../../include/linux/raid/md_k.h instead.
> 

BEGIN

> I discovered this (and that the devices are added as disks/partitions are
> discovered at boot) while I was debugging why only one of my MD arrays would
> come up whole, while all the others were short a disk.
> 
> I eventually discovered that it was enumerating through all of 9 of my 11 hds
> (2 had only 4 partitions apiece) while the other 9 have 15 partitions
> (I wanted 64 per drive...). The last partition of the 8th drive in my 9 drive
> raid 5 sets wasn't added, thus making the final md array short both a parity
> and data disk, and it was started later, elsewhere.

END

> Subject: [patch 1/1] md: Software Raid autodetect dev list not array
> 
> SOFTWARE RAID (Multiple Disks) SUPPORT
> P:	Ingo Molnar
> M:	mingo@redhat.com
> P:	Neil Brown
> M:	neilb@suse.de
> L:	linux-raid@vger.kernel.org
> S:	Supported
> Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
> 
> 12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
>     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
>     CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
>     enabled.
> 
> It has been tested with CONFIG_SMP set and unset (Different x86_64 systems).
> It has been tested with CONFIG_PREEMPT set and unset (same system).
> CONFIG_LBD isn't even an option in my .config file.
> 
> Note: between 2.6.22 and 2.6.23-rc3-git5
>                 rdev = md_import_device(dev,0, 0);
> became
>                 rdev = md_import_device(dev,0, 90);
> So the patch has been edited to patch around that line.
> 
> Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
