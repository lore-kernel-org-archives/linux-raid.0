From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Booting from a raid1 device ?
Date: Fri, 31 Oct 2003 12:40:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031031174032.GC819@ti19.telemetry-investments.com>
References: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com> <3FA06158.9040007@tls.msk.ru> <20031031082841.GB26757@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031031082841.GB26757@percy.comedia.it>
To: linux-raid@vger.kernel.org
Cc: Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

On Fri, Oct 31, 2003 at 09:28:42AM +0100, Luca Berra wrote:
> Btw i recall reading somewhere that grub actually modifies the disk it
> is booting from if luser wants to change the kernel command line.
> I dunno if it is true or not, and i am too lazy to read the source. Can
> anyone confirm or deny that?
 
That was me.  It may not be true, because I haven't had time and a
a spare machine to verify.

The symptom that we see is that /boot/grub/stage2 sometimes becomes
desynchronized between the RAID1 partitions after a reboot.

Every night we compare file MD5 sums temporally (day-over-day) and
spatially (between "identically" configured machines).  In the
event that a file block is desynchronized, we will typically see
the MD5 oscillate between two values, depending on which drive MD
chose to populate the cache.  An MD resync of /boot cures the problem.

Since this only seems to occur with /boot/grub/stage2, I've ruled out
most other theories.  We reboot a machine so infrequently that I've only
seen this three times in more than a year, so I haven't been motivated
to track it down.

Regards,

	Bill Rugolsky
