From: Adam Radford <aradford@3WARE.com>
Subject: RE: 3ware 7500-12, bad write speed
Date: Mon, 14 Oct 2002 11:08:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A1964EDB64C8094DA12D2271C04B812672C77E@tabby>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'raid@ddx.a2000.nu'" <raid@ddx.a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You probably won't get any benefit of 3ware with software raid by
changing max/min readahead, since md.c sets its own readahead.

For the writes, try it and find out.

-Adam

-----Original Message-----
From: raid@ddx.a2000.nu [mailto:raid@ddx.a2000.nu]
Sent: Friday, October 11, 2002 3:05 PM
To: Adam Radford
Cc: linux-raid@vger.kernel.org
Subject: RE: 3ware 7500-12, bad write speed


On Thu, 10 Oct 2002, Adam Radford wrote:

> Can you run the following commands, then re-run your 3ware benchmark and
see
> if the results change?
>
> echo "60" > /proc/sys/vm/bdflush
> echo "512" > /proc/sys/vm/max-readahead
> echo "256" > /proc/sys/vm/min-readahead

Do any of this settings (or any other settings in /proc/sys/vm) help sw
raid ?

also what are the best parameters for mke2fs (both sw and hw raid)
(i now run mke2fs -j -m 0 /dev/sdb1 (or /dev/md0)



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
