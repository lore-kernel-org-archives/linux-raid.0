From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 17:39:31 -0500
Message-ID: <47A0FCA3.7070506@tmr.com>
References: <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk> <479FC427.1080007@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FC427.1080007@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>, Moshe Yudkowsky <moshe@pobox.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Keld J=C3=B8rn Simonsen wrote:
>> On Tue, Jan 29, 2008 at 06:44:20PM -0500, Bill Davidsen wrote:
>>
>>> Depending on near/far choices, raid10 should be faster than raid5,=20
>>> with far read should be quite a bit faster. You can't boot off=20
>>> raid10, and if you put your swap on it many recovery CDs won't use=20
>>> it. But for general use and swap on a normally booted system it is=20
>>> quite fast.
>>
>> Hmm, why would you put swap on a raid10? I would in a production
>> environment always put it on separate swap partitions, possibly a=20
>> number,
>> given that a number of drives are available.
>>
>
> Because you want some redundancy for the swap as well. A swap=20
> partition/file becoming inaccessible is equivalent to yanking out a=20
> stick of memory out of your motherboard.

I can't say it better. Losing a swap area will make the system fail in=20
one way or the other, in my systems typicalls expressed as a crash of=20
varying severity. I use raid10 because it is the fastest reliable level=
=20
I've found.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
