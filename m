From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 20:22:19 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306262022190167.0592257E@ilneval.coreyfro.com>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
 <1056662597.10690.6.camel@gregdell.example.com>
 <200306261444280640.52F72FDF@shargaas.coreyfro.com>
 <20030626215606.A29149@newbox.localdomain>
 <200306261914500491.05546D13@ilneval.coreyfro.com>
 <20030626222447.C29149@newbox.localdomain>
 <200306261957360966.057B8F63@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Granted.  And it will be a while before I even bust 512MB's with a personal system (I'm waiting for hammer time!  Then I can have my 4GB's AND swap) but as far as reliability, solid-state beats spinning platters ;-)

And its not like gobs of free RAM is useless in the Linux world.  Unlike windows, Linux keeps it RAM filled with cache until free RAM is needed (I have disk intensive windows apps that run far faster under WINE than Windows.  I love bragging about them ;-) 

Cache or swap, cache or swap.  Cash for cache or crash for swap.

PS, on a RAID related note, 10.7 out of the 12.5% crash point on my RAID5 rebuild. without DMA, 5907.1 minutes before my RAID sync's.

DMA, its what's for dinner.

*********** REPLY SEPARATOR  ***********

On 6/26/2003 at 10:24 PM Scott McDermott wrote:

>Corey McGuire on Thu 26/06 19:14 -0700:
>> I'd like to know if Linux can address more than 4GB's of
>> RAM (on a 32 bit processor without using dirty tricks like
>> Intel's 36bit hack) including the swap system.
>
>Without PAE (36-bit), then of course the limit is 32-bit
>addressing.
>
>You're right that 4G is not that expensive, but only certain
>workloads can actually use this much memory.  If your
>working set is only 256M, but you often do other work with
>different working sets, this is a good candidate for disk
>swap.  Since you only use the one working set at a time, you
>really don't need to fit all of your working sets in core at
>once and you are just wasting money.  Disk is still MUCH
>cheaper than fast memory.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html




/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\

coreyfro@coreyfro.com
http://www.coreyfro.com/
http://stats.distributed.net/rc5-64/psearch.php3?st=coreyfro
ICQ : 3168059

-----BEGIN GEEK CODE BLOCK-----
GCS !d--(+) s: a- C++++$ UL++>++++ P+ L++>++++ E- W+++$ N++ o? K? w++++$>+++++$ O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+) Dl++(++++) D++ G++(-) e>+++ h++(---) r++>+$ y++**>$ H++++ n---(----) p? !au w+ v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
------END GEEK CODE BLOCK------

Home of Geek Code - http://www.geekcode.com/
The Geek Code Decoder Page - http://www.ebb.org/ungeek//

