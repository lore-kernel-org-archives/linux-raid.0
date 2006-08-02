From: dean gaudet <dean@arctic.org>
Subject: Re: Converting Ext3 to Ext3 under RAID 1
Date: Wed, 2 Aug 2006 12:28:58 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608021222510.16694@twinlark.arctic.org>
References: <200607152056.55090.pwaldo@waldoware.com> <200607230753.47853.pwaldo@waldoware.com>
 <17603.25777.274507.385333@cse.unsw.edu.au> <200607230832.48807.pwaldo@waldoware.com>
 <17605.22207.56022.972200@cse.unsw.edu.au> <Pine.LNX.4.61.0608021205110.626@molbio.uoregon.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0608021205110.626@molbio.uoregon.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Graham <graham@molbio.uoregon.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2 Aug 2006, Dan Graham wrote:

> Hello;
>   I have an existing, active ext3 filesystem which I would like to convert to
> a RAID 1 ext3 filesystem with minimal down time.  After casting about the web
> and experimenting some on a test system, I believe that I can accomplish this
> in the following manner.
> 
>   - Dismount the filesystem.
>   - Shrink the filesystem to leave room for the RAID superblock at the end
>     while leaving the partition size untouched (shrinking by 16 blocks seems
> to
>     work )
>   - Create a degraded array with only the partition carrying the shrunk ext3
>     system
>   - start the array and mount the array.
>   - hot add the mirroring partitions.
> 
> The questions I have for those who know Linux-Raid better than I.
> 
>    Is this scheme even half-way sane?

yes

>    Is 16 blocks a large enough area?

i always err on the side of caution and take a few meg off then resize it 
back up to full size after creating the degraded raid1.  (hmm maybe mdadm 
has some way to tell you how large the resulting partitions would be... 
i've never looked.)

you pretty much have to do this all using a recovery or live CD...

don't forget to rebuild your initrds... all of them including older 
kernels... otherwise there could be one of them still mounting the 
filesystem without using the md device name (and destroying integrity).

don't forget to set the second disk boot partition active and install grub 
so that you can boot from it when the first fails... (after you've 
mirrored the boot or root partition).

-dean
