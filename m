From: raid@ddx.a2000.nu
Subject: RE: 3ware 7500-12, bad write speed
Date: Sat, 12 Oct 2002 00:05:27 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210120003450.29225-100000@ddx.a2000.nu>
References: <A1964EDB64C8094DA12D2271C04B812672C771@tabby>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A1964EDB64C8094DA12D2271C04B812672C771@tabby>
To: Adam Radford <aradford@3WARE.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Oct 2002, Adam Radford wrote:

> Can you run the following commands, then re-run your 3ware benchmark and see
> if the results change?
>
> echo "60" > /proc/sys/vm/bdflush
> echo "512" > /proc/sys/vm/max-readahead
> echo "256" > /proc/sys/vm/min-readahead

Do any of this settings (or any other settings in /proc/sys/vm) help sw
raid ?

also what are the best parameters for mke2fs (both sw and hw raid)
(i now run mke2fs -j -m 0 /dev/sdb1 (or /dev/md0)



