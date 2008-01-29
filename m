From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 16:41:53 +0100
Message-ID: <479F4941.1050304@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F42A5.8040007@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Linux raid10 MODULE (which implements that standard raid10
> LEVEL in full) adds some quite.. unusual extensions to that
> standard raid10 LEVEL.  The resulting layout is also called
> raid10 in linux (ie, not giving new names), but it's not that
> raid10 (which is again the same as raid1+0) as commonly known
> in various literature and on the internet.  Yet raid10 module
> fully implements STANDARD raid10 LEVEL.

I will let Neil speak about what he meant by RAID10: whether it is raid10 + 
weird extensions, or a generalization of drive/stripe layouts.

However if you want to be so anal about names and specifications: md raid 10 
is not a _full_ 1+0 implementation. Consider the textbook scenario with 4 drives:

(A mirroring B) striped with (C mirroring D)

When only drives A and C are present, md raid 10 with near offset will not 
start, whereas "standard" RAID 1+0 is expected to keep clunking away.

Peter
