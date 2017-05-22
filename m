From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: raid5 to raid6 reshape never appeared to start, how to
 cancel/revert
Date: Mon, 22 May 2017 21:33:04 +0200
Message-ID: <20170522193304.GA4379@metamorpher.de>
References: <CAAMCDefCqUCY4Pd5im1u-JPh_SLG6BG8Onb8JxuPwoAkgXOkrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAMCDefCqUCY4Pd5im1u-JPh_SLG6BG8Onb8JxuPwoAkgXOkrA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 22, 2017 at 01:57:44PM -0500, Roger Heflin wrote:
> I had a 3 disk raid5 with a hot spare.  I ran this:
> mdadm --grow /dev/md126 --level=6 --backup-file /root/r6rebuild
> 
> I suspect I should have changed the number of devices in the above command to 4.

It doesn't hurt to specify, but that much is implied.
Growing 3 device raid5 + spare to raid6 results in 4 device raid6.

> The backup-file was created on a separate ssd.

Is there anything meaningful in this file?
 
> trying assemble now gets this:
>  mdadm --assemble /dev/md126 /dev/sd[abe]1 /dev/sdd
> --backup-file=/root/r6rebuild
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> examine shows this (sdd was the spare when the --grow was issues)
>  mdadm --examine /dev/sdd
> /dev/sdd1:

You wrote /dev/sdd above, is it sdd1 now? 

>         Version : 0.91.00

Ancient metadata. You could probably update it to 1.0...

>   Reshape pos'n : 0

So maybe nothing at all changed on disk?

You could try your luck with overlay

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

mdadm --create /dev/md42 --metadata=0.90 --level=5 --chunk=64 \
      --raid-devices=3 /dev/overlay/{a,b,c}

> It does appear that I added sdd rather than sdd1 but I don't believe
> that is anything critical to the issue as it should still work fine
> with the entire disk.

It is critical because if you use the wrong one the data will be shifted.

If the partition goes to the very end of the drive, I think the 0.90 
metadata could be interpreted both ways (as metadata for partition 
as well as whole drive).

If possible you should find some way to migrate to 1.2 metadata.
But worry about it once you have access to your data.

Regards
Andreas Klauer
