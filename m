From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 05:37:44 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0902200534450.14422@p34.internal.lan>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090220094356.GB26124@silver.sucs.org>
Sender: linux-ide-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 20 Feb 2009, Sitsofe Wheeler wrote:

> Whoops, I didn't mean to send that previous half formed mail :) Sorry.
>
> As mentioned in another mail there was a discussion on
> http://lkml.org/lkml/2009/1/31/28 and long thread talking about the
> introduction of the rotational flag here
> http://lkml.org/lkml/2009/1/5/340 . Cheapo SSDs or even USB keys are not
> auto detected as non-rotational devices by the kernel and after a bit of
> poking about I've come up with the following udev rules for my
> particular cases:
>
> SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{model}=="ASUS-PHISON *", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
> SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1606", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
> SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{manufacturer}=="SanDisk", ATTRS{product}=="Cruzer Micro", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
>
> Ever since the rotational option appeared I've been trying cfq but prior
> to that I was using noop or deadline. However it doesn't look like
> anyone has sat down and run the numbers to see what affect the
> ioscheulder/rotational flag is having on cheapo SSDs - all the
> suggestions are anecdotal. Could you run some benchmarks with these
> different options and report back the results?
>
> -- 
> Sitsofe | http://sucs.org/~sits/
>

$ grep rotational -r /usr/src/linux/
/usr/src/linux/drivers/scsi/NCR5380.c: * USLEEP_POLL should be a maximum rotational latency.
/usr/src/linux/fs/partitions/sun.c:             __be16 rspeed;     /* Disk rotational speed */
/usr/src/linux/fs/ufs/ufs_fs.h: * Compute the cylinder and rotational position of a cyl block addr.
/usr/src/linux/fs/ufs/ufs_fs.h: __fs32  fs_nrpos;               /* number of rotational positions */
/usr/src/linux/fs/ufs/ufs_fs.h:#define UFS_42POSTBLFMT          -1      /* 4.2BSD rotational table format */
/usr/src/linux/fs/ufs/ufs_fs.h:#define UFS_DYNAMICPOSTBLFMT     1       /* dynamic rotational table format */
/usr/src/linux/fs/ufs/ufs_fs.h: __s32   s_nrpos;        /* number of rotational positions */
/usr/src/linux/include/linux/blkdev.h:#define QUEUE_FLAG_NONROT      14 /* non-rotational device (SSD) */
/usr/src/linux/include/linux/genhd.h:   __u16   d_rpm;                  /* rotational speed */

# find /sys/|grep -i rotational
#

Which kernel{option} do you enable to enable support for that option in /sys?

Justin.

