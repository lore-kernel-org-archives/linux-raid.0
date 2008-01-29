From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:34:05 +0100
Message-ID: <479F557D.20502@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F5177.6060206@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Here's a baseline question: if I create a RAID10 array using default 
> settings, what do I get? I thought I was getting RAID1+0; am I really?

Maybe you are, depending on your settings, but this is beyond the point. No 
matter what 1+0 you have (linux, classic, or otherwise) you can not boot from 
it, as there is no way to see the underlying filesystem without the RAID layer.

With the current state of affairs (available mainstream bootloaders) the rule is:
Block devices containing the kernel/initrd image _must_ be either:
	* a regular block device (/sda1, /hda, /fd0, etc.)
	* or a linux RAID 1 with the superblock at the end of the device (0.9 or 1.2)


> My superblocks, by the way, are marked version 01; my metadata in 
> mdadm.conf asked for 1.2. I wonder what I really got.

This is how you find the actual raid version:

mdadm -D /dev/md[X] | grep Version

This will return a string of the form XX.YY.ZZ. Your superblock version is XX.YY.
