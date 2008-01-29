From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 10:16:55 -0600
Message-ID: <479F5177.6060206@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F42A5.8040007@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:

> There are more-or-less standard raid LEVELS, including
> raid10 (which is the same as raid1+0, or a stripe on top
> of mirrors - note it does not mean 4 drives, you can
> use 6 - stripe over 3 mirrors each of 2 components; or
> the reverse - stripe over 2 mirrors of 3 components each
> etc).

Here's a baseline question: if I create a RAID10 array using default 
settings, what do I get? I thought I was getting RAID1+0; am I really?

My superblocks, by the way, are marked version 01; my metadata in 
mdadm.conf asked for 1.2. I wonder what I really got. The real question 
in my mind now is why grub can't find the info, and either it's because 
of 1.2 superblocks or because of sub-partitioning of components.


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "You may not be interested in war, but war is interested in you."
    				-- Leon Trotsky
