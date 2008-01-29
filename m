From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 15:47:16 +0100
Message-ID: <479F3C74.1050605@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F331F.7080902@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
  > Raid10 IS RAID1+0 ;)
> It's just that linux raid10 driver can utilize more.. interesting ways
> to lay out the data.

This is misleading, and adds to the confusion existing even before linux 
raid10. When you say raid10 in the hardware raid world, what do you mean? 
Stripes of mirrors? Mirrors of stripes? Some proprietary extension?

What Neil did was generalize the concept of N drives - M copies, and called it 
10 because it could exactly mimic the layout of conventional 1+0 [*]. However 
thinking about md level 10 in the terms of RAID 1+0 is wrong. Two examples 
(there are many more):

	* mdadm -C -l 10 -n 3 -o f2 /dev/md10 /dev/sda1 /dev/sdb1 /dev/sdc1
Odd number of drives, no parity calculation overhead, yet the setup can still 
suffer a loss of a single drive

	* mdadm -C -l 10 -n 2 -o f2 /dev/md10 /dev/sda1 /dev/sdb1
This seems useless at first, as it effectively creates a RAID1 setup, without 
preserving the FS format on disk. However md10 has read balancing code, so one 
could get a single thread sustained read at a speed twice what he could 
possibly get with md1 in the current implementation

I guess I will sit down tonight and craft some patches to the existing md* man 
pages. Some things are indeed left unsaid.

Peter

[*] The layout is the same but the functionality is different. If you have 1+0 
on 4 drives, you can survive a loss of 2 drives as long as they are part of 
different mirrors. mdadm -C -l 10 -n 4 -o n2 <drives> however will _NOT_ 
survive a loss of 2 drives.
