From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: Booting from a raid1 device ?
Date: Mon, 27 Oct 2003 23:11:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310272311.19232.dusty@strike.wu-wien.ac.at>
References: <20031027152554.7738.qmail@web14507.mail.yahoo.com> <3F9D412A.F68B1461@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9D412A.F68B1461@SteelEye.com>
Content-Disposition: inline
To: Paul Clements <Paul.Clements@SteelEye.com>, donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 27 October 2003 17:00, Paul Clements wrote:
> Don Jessup wrote:
> >   Is it possible to boot from a raid1 device with the md.o built as a
> >  2.4.22 kernel module?
>
> Yes, but it's tricky. You'd have to load md.o and raid1.o in your initrd
> (or other early boot time initialization) and then use some, e.g.,
> statically-linked mdadm tool on that initrd to start the array. You
> cannot, however, use md's RAID autodetect to autostart arrays that have
> their component partitions marked as RAID autodetect (0xfd), if md is a
> module.

BTW, assuming I have md.o not as module but statically in the kernel, which 
bootloader would support RAID1? I heard LlLO does this job but does also grub 
- which I prefer - support Linux SW-RAID1?

What about RAID5? Is there any bootloader that supports it?

		Best Regards,
		Hermann
-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

