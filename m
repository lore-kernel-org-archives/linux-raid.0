From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Booting from a raid1 device ?
Date: Mon, 27 Oct 2003 11:00:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9D412A.F68B1461@SteelEye.com>
References: <20031027152554.7738.qmail@web14507.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don Jessup wrote:
> 
>   Is it possible to boot from a raid1 device with the md.o built as a
>  2.4.22 kernel module?

Yes, but it's tricky. You'd have to load md.o and raid1.o in your initrd
(or other early boot time initialization) and then use some, e.g.,
statically-linked mdadm tool on that initrd to start the array. You
cannot, however, use md's RAID autodetect to autostart arrays that have
their component partitions marked as RAID autodetect (0xfd), if md is a
module.

--
Paul


> =====
> Don Jessup
> Asaca/Shibasoku Corp. of America
> 400 Corporate Circle, Unit G
> Golden, CO  80401
> 303-278-1111 X232
> donj@asaca.com
> http://www.asaca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
