From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md SET_BITMAP_FILE compat ioctl
Date: Thu, 28 Sep 2006 17:31:23 +1000
Message-ID: <17691.31307.866365.272842@cse.unsw.edu.au>
References: <4512F55D.5030907@steeleye.com>
	<4514014E.1060302@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday September 22
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 22, paul.clements@steeleye.com wrote:
> The SET_BITMAP_FILE ioctl currently doesn't have a compat entry, so on 
> 64-bit systems a 32-bit mdadm will fail:
> 
> Sep 20 16:34:52 caspian kernel: ioctl32(mdadm:8056): Unknown cmd fd(3) 
> cmd(8004092b){00} arg(00000004) on /dev/md0
> 
> The fix is to build a 64-bit mdadm or apply the following patch (compile 
> tested only).

Thanks. I'll make sure it gets to akpm.

NeilBrown

> 
> --
> Paul
> --- ./include/linux/compat_ioctl.h.orig	2006-09-22 11:14:53.000000000 -0400
> +++ ./include/linux/compat_ioctl.h	2006-09-22 11:15:24.000000000 -0400
> @@ -121,6 +121,7 @@ ULONG_IOCTL(START_ARRAY)
>  COMPATIBLE_IOCTL(STOP_ARRAY)
>  COMPATIBLE_IOCTL(STOP_ARRAY_RO)
>  COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
> +ULONG_IOCTL(SET_BITMAP_FILE)
>  /* DM */
>  COMPATIBLE_IOCTL(DM_VERSION_32)
>  COMPATIBLE_IOCTL(DM_REMOVE_ALL_32)
