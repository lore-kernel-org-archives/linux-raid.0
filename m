From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: How to fix mistake on raid: mdadm create instead of assemble?
Date: Sat, 8 Oct 2016 14:30:40 +0200
Message-ID: <20161008123040.GA4603@metamorpher.de>
References: <CAJh8RqUaT_D3GEkj9dWGY5d4e4icUKzyidV2JTVToKN=MpCRyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJh8RqUaT_D3GEkj9dWGY5d4e4icUKzyidV2JTVToKN=MpCRyQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Santiago DIEZ <santiago.diez@caoba.fr>
Cc: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 07, 2016 at 05:37:32PM +0200, Santiago DIEZ wrote:
> First thing I did is ddrescue the remaining partitions sd[abc]10 .
> ddrescue did not stumble into any read error so I assume all remaining
> partitions are perfectly safe.

So ... don't you still have a good copy?

You only killed one of them, right? Did not make same mistake twice?

> There comes my mistake: I ran the --create command instead of --assemble :
> 
> ================================================================================
> # mdadm --create --verbose /dev/md1 --raid-devices=4 --level=raid5
> --run --readonly /dev/loop0 /dev/loop1 /dev/loop2 missing
> 
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: /dev/loop0 appears to contain an ext2fs file system
>        size=5778741888K  mtime=Sat Sep  3 11:00:22 2016
> mdadm: /dev/loop0 appears to be part of a raid array:
>        level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
> mdadm: /dev/loop1 appears to be part of a raid array:
>        level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
> mdadm: /dev/loop2 appears to be part of a raid array:
>        level=raid5 devices=4 ctime=Wed Jan 25 09:08:11 2012
> mdadm: size set to 1926115840K
> mdadm: automatically enabling write-intent bitmap on large array
> mdadm: creation continuing despite oddities due to --run
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md1 started.
> ================================================================================

You had 0.90 metadata before, that is metadata at the end of the device. 
1.2 metadata is at the start of the device (4K from start). So you have 
overwritten your filesystem superblock...

You can --create again with --metadata=0.90 --chunk=64K options and 
see what is left to the rescue.

But it would be much better if you still had your good copy of the original.

Regards
Andreas Klauer
