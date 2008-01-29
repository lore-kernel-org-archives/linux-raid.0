From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:42:04 +0300
Message-ID: <479F575C.5020009@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F5177.6060206@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Michael Tokarev wrote:
> 
>> There are more-or-less standard raid LEVELS, including
>> raid10 (which is the same as raid1+0, or a stripe on top
>> of mirrors - note it does not mean 4 drives, you can
>> use 6 - stripe over 3 mirrors each of 2 components; or
>> the reverse - stripe over 2 mirrors of 3 components each
>> etc).
> 
> Here's a baseline question: if I create a RAID10 array using default
> settings, what do I get? I thought I was getting RAID1+0; am I really?

..default settings AND even (4, 6, 8, 10, ...) number of drives.  It
will be "standard" raid10 or raid1+0 which is the same, as many stripes
of mirrored (2 copies) data as fits with the number of disks.  With odd
number of disks it obviously will be soemthing else, not a "standard"
raid10.

> My superblocks, by the way, are marked version 01; my metadata in
> mdadm.conf asked for 1.2. I wonder what I really got. The real question

Ugh.  Another source of confusion.  In --superblock=1.2, "1" stands
for the format, and "2" stands for the placement.  So it's really
format version 1.  From mdadm(8):

              1, 1.0, 1.1, 1.2
                     Use  the  new  version-1 format superblock.  This has few
                     restrictions.   The  different  sub-versions  store   the
                     superblock  at  different locations on the device, either
                     at the end (for 1.0), at the start (for 1.1) or  4K  from
                     the start (for 1.2).


> in my mind now is why grub can't find the info, and either it's because
> of 1.2 superblocks or because of sub-partitioning of components.

As has been said numerous times in this thread, grub can't be used with
anything but raid1 to start with (the same is true for lilo).  Raid10
(or raid1+0, which is the same) - be it standard or linux extension format -
is NOT raid1.

/mjt
