From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 19:14:50 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306261914500491.05546D13@ilneval.coreyfro.com>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
 <1056662597.10690.6.camel@gregdell.example.com>
 <200306261444280640.52F72FDF@shargaas.coreyfro.com>
 <20030626215606.A29149@newbox.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030626215606.A29149@newbox.localdomain>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to know if Linux can address more than 4GB's of RAM (on a 32 bit processor without using dirty tricks like Intel's 36bit hack) including the swap system.

I am pretty sure that all OS's using 32bit CPU's in a 32bit way can only address 4GB's of RAM, including swap.  Ergo, when RAM gets cheap enough, swap could become obsolete.

I'll probably have to blow out my raid before all is done with me.  Anyone know a way I could occupie 4GB's or more RAM quickly?

*********** REPLY SEPARATOR  ***********

On 6/26/2003 at 9:56 PM Scott McDermott wrote:

>Corey McGuire on Thu 26/06 14:44 -0700:
>> In Linux, is there a reason for using swap if you can
>> afford the RAM?
>
>Hmm...if you really aren't using some pages, why not have
>them paged out during some idle time and have more free
>physical memory available immediately without having to wait
>for pageout, should demand occur? I don't know if Linux will
>ever page out even very old pages if there is no memory
>pressure at all, but it probably makes sense to do so in
>order to have memory available immediately, should a huge
>demand occur.  Then again, should those pages be demanded
>again, you would have to wait for pagein.  I wonder what
>Linux does?
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

