From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 07 Jul 2003 11:42:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307071142330484.8AF6968B@shargaas.coreyfro.com>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
 <200307072029.14998.bernd-schubert@web.de>
Content-Type: text/plain; charset="ISO-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307072029.14998.bernd-schubert@web.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This question has been on the tip of my tongue... Thanks for your answer...

Out of curiousity, why do you use /dev/zero? Would dd to /dev/null cause
problems or is /dev/zero required for proper results?

>Hi,
>
>/proc/mdstat is to monitor the status of your raid, so when one drive
>fails it 
>becomes dropped out of the raid-array. Using mdadm you can monitor 
>/proc/mdstat and it even can send you a mail when one of your disks fails.
>So 
>if you really want to scan your disk once a week, why not running 'dd 
>if=/dev/mdX of=/dev/zero' ? So every block of every raid-disk should
>become 
>read and the md-driver should automatically drop a failing disk  out of
>the 
>raid. 
>I guess you could even try to repair a disk when it became dropped out of
>the 
>raid by running some scripts, but since I never trusted any disk that had 
>failed ones, I never worried about it.
>
>Bernd
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

