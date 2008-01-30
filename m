From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:13:32 -0600
Message-ID: <479FC12C.9050602@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <20080129202156.GA32434@rap.rap.dk> <479FA540.70707@pobox.com> <479FBA98.10202@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FBA98.10202@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

>> According to man md(4), the o2 is likely to offer the best combination 
>> of read and write performance. Why would you consider f2 instead?
>>
> f2 is faster for read, most systems spend more time reading than writing.

According to md(4), offset "should give similar read characteristics to 
'far' if a suitably large chunk size is used, but without as much 
seeking for writes."

Is the man page not correct, conditionally true, or simply not 
understood by me (most likely case)?

I wonder what "suitably large" is...

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "The seconds marched past, transversing that mysterious boundary that
   separates the future from the past."
    			-- Jack Vance, "The Face"
