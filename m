From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 + writemostly
Date: Tue, 16 Dec 2008 08:26:41 +1100
Message-ID: <18758.52113.251622.783466@notabene.brown>
References: <cccedfc60812151030y630bb6c3g40a926bced2b1c09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> According to the manpage for mdadm, --write-mostly can only be used
> add build, create, or add time.  How does one set write-mostly devices
> *after* they've been added?

You cannot.
The easiest approach is to remove it and re-add it with the
write-mostly flag.

> 
> mdadm /dev/mdX --write-mostly /dev/someDevice
> succeeds but does nothing.
> 
> According to Documentation/md.txt, writing writemostly into
> /sys/block/mdX/md/dev-someDevice/state
> should do it, and it sort of appears to:
> 
> turnip:~ # mdadm --detail /dev/md11
> /dev/md11:
...
>     Number   Major   Minor   RaidDevice State
>        2      43        0        0      active sync   /dev/nbd0
>        3       8        0        1      active sync   /dev/sda
> turnip:~ # echo writemostly > /sys/block/md11/md/dev-nbd0/state
> turnip:~ # mdadm --detail /dev/md11
> /dev/md11:
..
>     Number   Major   Minor   RaidDevice State
>        2      43        0        0      active sync writemostly   /dev/nbd0
>        3       8        0        1      active sync   /dev/sda
> turnip:~ # mdadm --examine-bitmap /dev/nbd0
>         Filename : /dev/nbd0
>            Magic : 6d746962
>          Version : 4
>             UUID : cf24d099:9e174a79:2a2f6797:dcff1420
>           Events : 3840
>   Events Cleared : 3840
>            State : OK
>        Chunksize : 4 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 78123988 (74.50 GiB 80.00 GB)
>           Bitmap : 19074 bits (chunks), 0 dirty (0.0%)
> turnip:~ #
> 
> 
> Why doesn't --examine-bitmap show the right mode?

What were you expecting?  The bitmap never reports anything about
writemostly, only write-behind.

> 
> Also, removing the bitmap from the array does not zero out the bitmap
> on the actual device. Shouldn't it do that?

No.  It simply records in the array metadata that there is no bitmap.
It might be sensible to get "--examine-bitmap" to report that the
bitmap is not active in some way.

NeilBrown


> turnip:~ # mdadm --grow /dev/md11 --bitmap=none
> turnip:~ # mdadm --examine-bitmap /dev/nbd0
>         Filename : /dev/nbd0
>            Magic : 6d746962
>          Version : 4
>             UUID : cf24d099:9e174a79:2a2f6797:dcff1420
>           Events : 3841
>   Events Cleared : 3841
>            State : OK
>        Chunksize : 4 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 78123988 (74.50 GiB 80.00 GB)
>           Bitmap : 19074 bits (chunks), 0 dirty (0.0%)
> turnip:~ #
> 
> This is with mdadm 2.6.4 on 2.6.25.18-0.2-default
> I can try mdadm 3.0 if you like.
> 
> -- 
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
