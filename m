From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: =?us-ascii?B?UmU6ICAgvyB0aGUgYmVzdCBqb3VybmFsaXN0LWZpbGVzeXN0ZW0g?=
 for a   raid5 ?
Date: Tue, 08 Jul 2003 14:47:56 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307081447560906.90C6AD69@shargaas.coreyfro.com>
References: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130>
 <Pine.LNX.4.44.0307031157450.18503-100000@chaos.egr.duke.edu>
 <befdg2$ev7$1@main.gmane.org>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <befdg2$ev7$1@main.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Last time I played with SuSE (8.2, which is the latest) their kernel had
ACL under ReisersFS... Of course, SuSE does alot with their distro, more
than most others, so it could be an in house hack for them... I don't know
the details, just letting you know what I saw...

*********** REPLY SEPARATOR  ***********

On 7/8/2003 at 2:34 PM Bradley D. Thornton wrote:

>"Joshua Baker-LePain" <jlb17@duke.edu> wrote in message
>news:Pine.LNX.4.44.0307031157450.18503-100000@chaos.egr.duke.edu...
>> On Thu, 3 Jul 2003 at 5:42pm, system_lists@nullzone.org wrote
>>
>> >     i dont wanna create a discusion between gurus. My question is so
>simple
>> > (well .. its not simple but ...).
>> >
>> > What do u think is the best journalist filesystem for a software raid5
>of
>> > 4*120 GB IDE UATA ?
>> > I will use this one for big files (lots of them) and small ones (just
a
>ftp
>> > but too for the users space).
>> >
>> > For a non-specific BIG/SMALL files .... JFS? Reiser3? Reiser4? EXT3?
>>
>> I've had very good luck with XFS for a long time now (over 2 years in
>> production, currently 5.5TB of formatted space).
>
>I guess that leads me to the question, does ReiserFS NOT support ACLs? I
>understand that XFS does (with a patch), but the page that I got this
>information from is kind of old
>(http://www.linux-mag.com/2002-10/jfs_01.html - which may also assist in
>helping one decide which file system to go with I suppose).
>
>The reason I ask is because I am interested in SAMBA/CIFS applications
>running Linux as a file server/PDC
>
>>
>> -- 
>> Joshua Baker-LePain
>> Department of Biomedical Engineering
>> Duke University
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>---
>Outgoing mail is certified Virus Free.
>Checked by AVG anti-virus system (http://www.grisoft.com).
>Version: 6.0.449 / Virus Database: 251 - Release Date: 01/27/03
>
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

