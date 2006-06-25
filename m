From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: Multiple raids on one machine?
Date: Sun, 25 Jun 2006 18:44:58 -0400
Message-ID: <20060625224427.M84762@contactbda.com>
References: <449F100D.6030509@cjx.com>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F100D.6030509@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

use LVM, that way you can resize the volumns


---------- Original Message -----------
From: Chris Allen <chris@cjx.com>
To: linux-raid@vger.kernel.org
Sent: Sun, 25 Jun 2006 23:37:01 +0100
Subject: Multiple raids on one machine?

> Back to my 12 terabyte fileserver, I have decided to split the storage 
> into four partitions
> each of 3TB. This way I can choose between XFS and EXT3 later on.
> 
> So now, my options are between the following:
> 
> 1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
> I do this? fdisk won't handle it. Can GNU Parted handle partitions this big?
> 
> 2. Partition the raw disks into four partitions and make 
> /dev/md0,md1,md2,md3.
> But am I heading for problems here? Is there going to be a big 
> performance hit
> with four raid5 arrays on the same machine? Am I likely to have dataloss 
> problems
> if my machine crashes?
> 
> Thanks for listening...
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

