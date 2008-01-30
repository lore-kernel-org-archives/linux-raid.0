From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 13:01:37 +0100
Message-ID: <47A06721.4090307@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F557D.20502@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Moshe Yudkowsky wrote:
>> Here's a baseline question: if I create a RAID10 array using default 
>> settings, what do I get? I thought I was getting RAID1+0; am I really?
> 
> Maybe you are, depending on your settings, but this is beyond the point. 
> No matter what 1+0 you have (linux, classic, or otherwise) you can not 
> boot from it, as there is no way to see the underlying filesystem 
> without the RAID layer.
> 
> With the current state of affairs (available mainstream bootloaders) the 
> rule is:
> Block devices containing the kernel/initrd image _must_ be either:
>     * a regular block device (/sda1, /hda, /fd0, etc.)
>     * or a linux RAID 1 with the superblock at the end of the device 
> (0.9 or 1.2)
> 
> 

If any poor soul finds this in the mailing list archives, the above should read:

...
	* or a linux RAID 1 with the superblock at the end of the device (either 
version 0.9 or _1.0_)
....
