From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Show me the cache, was Mirroring swap
Date: Fri, 27 Jun 2003 16:31:55 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306271631550843.587FEC42@shargaas.coreyfro.com>
References: <Pine.GSO.4.33.0306271420230.7750-100000@sweetums.bluetronic.net>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0306271420230.7750-100000@sweetums.bluetronic.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Understand, but my point was that my disk happy windows apps actually work
better under wine than windows due to more persistent caching.

I have this asset-tracking app that I use to process application licenses.
It keeps all its data in a big text file.  In windows, processing the
results from a single system can take up to a minute.  In Linux, this takes
seconds.

Wizardry 8, a fun RPG, takes huge amounts of time to load new maps under
windows.  In linux, these maps load much more quickly.

Win-mx generates "bit prints" for files so when you search for a file, as
long as you know its bit print (actually, you don't need to, the program
handles it) you can easily find THAT SPECIFIC FILE on other peoples boxes.
Very nice!  Generating these bit prints is also faster under linux, but
this probably has less to do with cache and more to do with driver
performance.

*********** REPLY SEPARATOR  ***********

On 6/27/2003 at 2:24 PM Ricky Beam wrote:

>On Fri, 27 Jun 2003, Corey McGuire wrote:
>>"DisablePagingExecutive"=dword:00000001
>
>(That doesn't actually work.  NT/2000/XP will still page the kernel parts.
> But not much of it.)
>
>>...  "LargeSystemCache" hardly
>>helps, as it basicly tells Windows "yes, all RAM _CAN_ be used for cache"
>>instead of just a paultry 4MB.  Does this help?  Yeah, my 512MB machine
is
>>currently using 18MB's of cache.
>
>Currently, my XP Home laptop is using 356,188K of cache.  That will go to
>"all available RAM" if an application starts writing large volumes of data
>to disk. (Linux throttles processes that flood the cache.)
>
>--Ricky
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

