From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: Bizarre RAID "failure"
Date: Thu, 19 Feb 2004 14:39:40 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0402191434590.6370@umi.cfht.hawaii.edu>
References: <1077230692.28817.485.camel@s8n-1.thereinc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1077230692.28817.485.camel@s8n-1.thereinc.com>
To: Tom Maddox <tmaddox@thereinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It might not be related but I've seen odd behaviour with that kernel
and XFS family when xfs_repair/XFS Recovery is run while the array is
resyncing.

If you have the opportunity to try some tests, you might try booting
the system without the volume mounted to avoid the automatic XFS
checking. When the resync is complete, then try mounting the volume.

-Kanoa

On Thu, 19 Feb 2004, Tom Maddox wrote:

> Hi, all,
>
> I'm encountering a bizarre problem with software RAID 5 under Linux that
> I'm hoping someone on this list can help me solve or at least
> understand.
>
> I've got a box running Red Hat 7.3 with SGI's 2.4.18 XFS 1.1 kernel.
> It's using three FastTrak TX 2000 (PDC20271) cards in non-RAID mode with
> three Western Digital 200 GB drives.  I'm using those controllers
> because they were handy and they support large drives.  The drives are
> in an XFS-formatted RAID 5 array using md, which has never given me
> problems before.  In this case, however, I'm running into some seriously
> anomalous behavior.
>
> If the system goes down unexpectedly (e.g., because of a power failure),
> the RAID array comes back up dirty and begins to rebuild itself, which
> is odd enough on its own.  What's worse is that, whenever this happens,
> the rebuild hangs at about 2.4%.  When it reaches that point, the array
> becomes totally nonresponsive--I can't even query its status with mdadm
> or any other tool, although I can use "cat /proc/mdstat" to see the
> status of the rebuild.  Any command that attempts to access the RAID
> drive hangs.
>
> My assumption would normally be that there's a hardware failure
> somewhere, but I've swapped out each component individually (including
> cables!) and the same problem keeps happening.
>
> Has anyone seen this behavior before, and can you recommend a solution?
>
> Thanks,
>
> Tom
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
