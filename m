From: Andrew Walrond <andrew@walrond.org>
Subject: Re: Is this hdparm -t output correct? (was Re: RAID1 & 2.6.9 performance problem)
Date: Mon, 17 Jan 2005 17:04:10 +0000
Message-ID: <200501171704.10374.andrew@walrond.org>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050117165133.GC99565@caffreys.strugglers.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 17 January 2005 16:51, Andy Smith wrote:
>
> As an aside, when I try this, how come I get this:
>
> $ sudo hdparm -t /dev/sda /dev/sdb /dev/md0
>
> /dev/sda:
>  Timing buffered disk reads:  152 MB in  3.03 seconds =  50.19 MB/sec
> HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl
> for device
>
> /dev/sdb:
>  Timing buffered disk reads:  152 MB in  3.03 seconds =  50.24 MB/sec
> HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl
> for device
>
> /dev/md0:
>  Timing buffered disk reads:  read(2097152) returned 524288 bytes
>
> (note warnings about ioctls and no speed output for /dev/md0)
>
> These are SATA drives in a RAID 1.

I edited out the "inappropriate ioctl" warnings in my output. Since the drives 
are not partitions, a flush would indeed be inappropriate. hdparm -t only 
does read timings anyway. As to why your md0 output is strange - no idea I'm  
afraid. :(

Andrew Walrond
