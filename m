From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 15:47:30 +0100
Message-ID: <47A08E02.3000009@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk> <47A07D95.2030902@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A07D95.2030902@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:

> With 5-drive linux raid10:
> 
>    A  B  C  D  E
>    0  0  1  1  2
>    2  3  3  4  4
>    5  5  6  6  7
>    7  8  8  9  9
>   10 10 11 11 12
>    ...
> 
> A&B can't be removed - 0, 5.  A&C CAN be removed, as
> are A&D.  But not A&E - losing 2 and 7.  And so on.

I stand corrected by Michael, this is indeed the case with the current state 
of md raid 10. Either my observations were incorrect when I made them a year 
and a half ago, or some fixes went into the kernel since then.

In any way - linux md10 does behave exactly as a classic raid 1+0 when created 
with -n D -p nS where D and S are both even and D = 2S.
