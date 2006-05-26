From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm and 2.4 kernel?
Date: Fri, 26 May 2006 17:01:54 +1000
Message-ID: <17526.42978.992496.348952@cse.unsw.edu.au>
References: <4475FAE3.6080309@phx6a.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ste on Thursday May 25
Sender: linux-raid-owner@vger.kernel.org
To: Ste <ste@phx6a.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 25, ste@phx6a.ath.cx wrote:
> Hi, for various reasons i'll need to run mdadm on a 2.4 kernel.
> Now I have 2.4.32 kernel.
> 
> Take a look:
> 
> root@data:~# mdadm --create --verbose /dev/md0 --level=1 
> --bitmap=/root/md0bitmap -n 2 /dev/nda /dev/ndb --force --assume-clean
> mdadm: /dev/nda appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
> mdadm: /dev/ndb appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
> mdadm: size set to 39118144K
> Continue creating array? y
> mdadm: Warning - bitmaps created on this kernel are not portable
>   between different architectured.  Consider upgrading the Linux kernel.
> mdadm: Cannot set bitmap file for /dev/md0: No such device
> 

2.4 does not support bitmaps (nor do early 2.6 kernels).

> 
> root@data:~# mdadm --create --verbose /dev/md0 --level=1  -n 2 /dev/nda 
> /dev/ndb --force --assume-clean
> mdadm: /dev/nda appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
> mdadm: /dev/ndb appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
> mdadm: size set to 39118144K
> Continue creating array? y
> mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
> root@data:~# 

It seems /dev/md0 is already active somehow.
Try
  mdadm -S /dev/md0
first.  What does "cat /proc/mdstat" say?

NeilBrown


> 
> Obviously the devices "/dev/nda" and "/dev/ndb" exists (i can make fdisk 
> on them).
> 
> Can someone help me?
> Thanks.
> Stefano.
> 
>             
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
