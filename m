From: Tyler <pml@dtbb.net>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 10:54:33 -0700
Message-ID: <42C2E059.2090502@dtbb.net>
References: <1120061430.21458.236.camel@volt>  <42C2CEF0.7030108@h3c.com> <1120066268.21458.252.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120066268.21458.252.camel@volt>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For 250GB drives, those Buffered disk reads seem rather slow.. they 
should be in the 35-50 range.  I would check your dma settings with 
hdparm as someone already suggested.  What speed of processor is in the 
server, and what type of IDE cards/controllers?  Maybe also check your 
/proc/interrupts for errors.. maybe you have an IRQ conflict.  Also 
double check your dmesg output.  What kernel are you using?

Tyler.

John Rowe wrote:

>Thanks for all the suggestions. 
>
>/proc/sys/dev/raid/speed_limit_max had the value "10000", changing it to
>200000 didn't make a difference. hdparm looks OK to me:
>
>/dev/hdm1:
> Timing buffer-cache reads:   128 MB in  1.19 seconds =107.56 MB/sec
> Timing buffered disk reads:  64 MB in  3.13 seconds = 20.45 MB/sec
>
>/dev/hdo1:
> Timing buffer-cache reads:   128 MB in  1.17 seconds =109.40 MB/sec
> Timing buffered disk reads:  64 MB in  3.85 seconds = 16.62 MB/sec
>rsync:/root# hdparm -Tt /dev/hda4
>
>/dev/hda4:
> Timing buffer-cache reads:   128 MB in  1.15 seconds =111.30 MB/sec
> Timing buffered disk reads:  64 MB in  4.31 seconds = 14.85 MB/sec
>
>/dev/hdc4:
> Timing buffer-cache reads:   128 MB in  1.16 seconds =110.34 MB/sec
> Timing buffered disk reads:  64 MB in  4.79 seconds = 13.36 MB/sec
>
>/dev/hdi3:
> Timing buffer-cache reads:   128 MB in  1.16 seconds =110.34 MB/sec
> Timing buffered disk reads:  64 MB in  2.73 seconds = 23.44 MB/sec
>
>/dev/hdk1:
> Timing buffer-cache reads:   128 MB in  1.16 seconds =110.34 MB/sec
> Timing buffered disk reads:  64 MB in  2.72 seconds = 23.53 MB/sec
>
>
>DMA is enabled for all six disks.
>
>If it helps, here is my raidtab. I wonder a little about the 64K chunk
>size on the stripe but a 128K size on the RAID5. Is this good or bad?
>
>raiddev             /dev/md0
>raid-level                  1
>nr-raid-disks               2
>chunk-size                  64k
>persistent-superblock       1
>nr-spare-disks              0
>    device          /dev/hda2
>    raid-disk     0
>    device          /dev/hdc2
>    raid-disk     1
>
>
>raiddev             /dev/md2
>raid-level                  0
>nr-raid-disks               2
>chunk-size                  64k
>persistent-superblock       1
>nr-spare-disks              0
>    device          /dev/hdm1
>    raid-disk     0
>    device          /dev/hdo1
>    raid-disk     1
>
>raiddev             /dev/md3
>raid-level                  5
>nr-raid-disks               5
>chunk-size                  128k
>parity-algorithm        left-symmetric
>persistent-superblock       1
>nr-spare-disks              0
>    device          /dev/hda4
>    raid-disk     0
>    device          /dev/hdc4
>    raid-disk     1
>    device          /dev/hdi3
>    raid-disk     2
>    device          /dev/hdk1
>    raid-disk     3
>    device          /dev/md2
>    raid-disk     4
>
>
>Comments gratefully received.
>
>John
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

