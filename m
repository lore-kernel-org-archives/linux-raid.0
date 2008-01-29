From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:09:52 +0300
Message-ID: <479F33B0.20506@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F0E17.30409@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F0E17.30409@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Peter Rabbitson wrote:
> 
>> It is exactly what the names implies - a new kind of RAID :) The setup
>> you describe is not RAID10 it is RAID1+0. As far as how linux RAID10
>> works - here is an excellent article:
>> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> 
> Thanks. Let's just say that the md(4) man page was finally penetrating
> my brain, but the Wikipedia article helped a great deal. I had thought
> md's RAID10 was more "standard."

It is exactly "standard" - when you create it with default settings
and with even number of drives (2, 4, 6, 8, ...), it will be exactly
"standard" raid10 (or raid1+0, whatever) as described in various
places on the net.

But if you use odd number of drives, or if you pass some fancy --layout
option, it will look differently.  Still not suitable for lilo or
grub, at least their current versions.

/mjt
