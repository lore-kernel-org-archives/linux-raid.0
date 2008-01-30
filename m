From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 17:36:49 -0500
Message-ID: <47A0FC01.1090908@tmr.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <20080129202156.GA32434@rap.rap.dk> <479FA540.70707@pobox.com> <479FBA98.10202@tmr.com> <479FC12C.9050602@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FC12C.9050602@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Bill Davidsen wrote:
>
>>> According to man md(4), the o2 is likely to offer the best 
>>> combination of read and write performance. Why would you consider f2 
>>> instead?
>>>
>> f2 is faster for read, most systems spend more time reading than 
>> writing.
>
> According to md(4), offset "should give similar read characteristics 
> to 'far' if a suitably large chunk size is used, but without as much 
> seeking for writes."
>
> Is the man page not correct, conditionally true, or simply not 
> understood by me (most likely case)?
>
> I wonder what "suitably large" is...
>
My personal experience is that as chunk gets larger random write gets 
slower, sequential gets faster. I don't have numbers any more, but 
20-30% is sort of the limit of what I saw for any chunk size I consider 
reasonable. f2 is faster for sequential reading, tune your system to 
annoy you least. ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


