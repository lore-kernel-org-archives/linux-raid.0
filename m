From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Checking consistency of Linux software RAID
Date: Tue, 08 Jul 2003 14:47:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307081447530781.90C6A134@shargaas.coreyfro.com>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
 <200307072029.14998.bernd-schubert@web.de>
 <200307071142330484.8AF6968B@shargaas.coreyfro.com>
 <200307081851.31385.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307081851.31385.bernd-schubert@web.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

no big... I put "dd" to use, and it works like a charm... of course, I
won't really know if it works like a charm until something breaks...

That's the trouble with computers ;-)

*********** REPLY SEPARATOR  ***********

On 7/8/2003 at 6:51 PM Bernd Schubert wrote:

>Hello Corey!
>
>> This question has been on the tip of my tongue... Thanks for your
>answer...
>>
>> Out of curiousity, why do you use /dev/zero? Would dd to /dev/null c=
ause
>> problems or is /dev/zero required for proper results?
>>
>
>D'oh it seems I was a bit sleepy yesterday, of course, you are right -=
 it
>has=20
>to be /dev/null!=20
>And of course, one can only read from /dev/zero.=20
>
>Sorry for posting improper commands.
>
>
>Best regards,=09
>	Bernd
>
>
>> >Hi,
>> >
>> >/proc/mdstat is to monitor the status of your raid, so when one dri=
ve
>> >fails it
>> >becomes dropped out of the raid-array. Using mdadm you can monitor
>> >/proc/mdstat and it even can send you a mail when one of your disks
>fails.
>> >So
>> >if you really want to scan your disk once a week, why not running '=
dd
>> >if=3D/dev/mdX of=3D/dev/zero' ? So every block of every raid-disk
should
>> >become
>> >read and the md-driver should automatically drop a failing disk  ou=
t of
>> >the
>> >raid.
>> >I guess you could even try to repair a disk when it became dropped =
out
>of
>> >the
>> >raid by running some scripts, but since I never trusted any disk th=
at
>had
>> >failed ones, I never worried about it.
>> >
>> >Bernd
>> >-
>> >To unsubscribe from this list: send the line "unsubscribe linux-rai=
d"
in
>> >the body of a message to majordomo@vger.kernel.org
>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> /\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\
>>
>> coreyfro@coreyfro.com
>> http://www.coreyfro.com/
>> http://stats.distributed.net/rc5-64/psummary.php3?id=3D196879
>> ICQ : 3168059
>>
>> -----BEGIN GEEK CODE BLOCK-----
>> GCS d--(+) s: a-- C++++$ UBL++>++++ P+ L+ E W+++$ N+ o? K? w++++$>++=
+++$
>> O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+)
>> Dl++(++++) D++ G+ e>+++ h++(---) r++>+$ y++*>$ H++++ n---(----) p? !=
au
w+
>> v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
>> ------END GEEK CODE BLOCK------
>>
>> Home of Geek Code - http://www.geekcode.com/
>> The Geek Code Decoder Page - http://www.ebb.org/ungeek//
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>--=20
>Bernd Schubert
>Physikalisch Chemisches Institut / Theoretische Chemie
>Universit=E4t Heidelberg
>INF 229
>69120 Heidelberg
>e-mail: bernd.schubert@pci.uni-heidelberg.de
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html




/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\

coreyfro@coreyfro.com
http://www.coreyfro.com/
http://stats.distributed.net/rc5-64/psummary.php3?id=3D196879
ICQ : 3168059

-----BEGIN GEEK CODE BLOCK-----
GCS d--(+) s: a-- C++++$ UBL++>++++ P+ L+ E W+++$ N+ o? K? w++++$>+++++=
$
O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+)
Dl++(++++) D++ G+ e>+++ h++(---) r++>+$ y++*>$ H++++ n---(----) p? !au =
w+
v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
------END GEEK CODE BLOCK------

Home of Geek Code - http://www.geekcode.com/
The Geek Code Decoder Page - http://www.ebb.org/ungeek//

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
