From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: RE: Mirroring swap
Date: Thu, 26 Jun 2003 14:44:28 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306261444280640.52F72FDF@shargaas.coreyfro.com>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
 <1056662597.10690.6.camel@gregdell.example.com>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1056662597.10690.6.camel@gregdell.example.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Personally, I think that if a system is so vital that it can't afford a
swap failure, then fill it full of RAM.  One can populate a 32bit system to
the max (4GB's) with quality RAM for less than a grand (less than $500 if
you buy real cheap stuff)

I don't know about Linux, but I know in Windows, swap is only vital because
M$ is too lazy to change their code.  Even in windows XP you need swap.
You can turn off "virtual memmory" but swap is just moved to ram (that's
right, real memory pretending to be fake memory pretending to be real
memory)

In Linux, is there a reason for using swap if you can afford the RAM?

*********** REPLY SEPARATOR  ***********

On 6/26/2003 at 2:23 PM Gregory Leblanc wrote:

>On Thu, 2003-06-26 at 01:30, Gordon Henderson wrote:
>[snip]
>> So now with important machines which had mirrored or RAIDed disk
systems,
>> I always put swap on a mirrored or RAID5d device.
>
>Swap on RAID 5 is going to have pretty poor performance, in general. 
>Swap needs to be both high bandwidth and low latency, both for reading
>and writing.  RAID 5 just isn't that.
>	Greg.
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html




/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\

coreyfro@coreyfro.com
http://www.coreyfro.com/
http://stats.distributed.net/rc5-64/psummary.php3?id=196879
ICQ : 3168059

-----BEGIN GEEK CODE BLOCK-----
GCS d--(+) s: a-- C++++$ UBL++>++++ P+ L+ E W+++$ N+ o? K? w++++$>+++++$
O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+)
Dl++(++++) D++ G+ e>+++ h++(---) r++>+$ y++*>$ H++++ n---(----) p? !au w+
v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
------END GEEK CODE BLOCK------

Home of Geek Code - http://www.geekcode.com/
The Geek Code Decoder Page - http://www.ebb.org/ungeek//

