From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Really need RESYNC at the time of RAID1&5 creation?
Date: Mon, 30 Jun 2003 15:11:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306301511570187.67A9C782@shargaas.coreyfro.com>
References: <00b901c33f4f$715be540$6401a8c0@bmoon>
 <20030630220308.GQ12240@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030630220308.GQ12240@marowsky-bree.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just my 2 cents but were it not for the initial resync last week, I may
have never known that my RAID was shafted.

sure, once it synced, it took two hours, but that is a price I am willi=
ng
to pay...

*********** REPLY SEPARATOR  ***********

On 7/1/2003 at 12:03 AM Lars Marowsky-Bree wrote:

>On 2003-06-30T14:34:51,
>   bmoon <bo@anthologysolutions.com> said:
>
>> Hi Neil & Raiders,
>>=20
>> I am not quite sure if we really need to resync the array at the tim=
e of
>> RAID 1 or RAID 5 array creation. I tried and tested without RESYNC b=
y
>> modifying "case1" and "case2" from MDADM source below, I could not
notice
>> any problems or issues.
>
>It's necessary to ensure consistency of the RAID, so that later, you c=
an
>detect whether the RAID has scrambled some of your disk.
>
>Otherwise, you'd never know whether it wouldn't still be an artifact
>leftover from the creation of the array.
>
>Another option would be a bitmap of used chunks so you could tell one
>from the other, but that wouldn't make as much sense on a heavily used
>array. So just initialize it once.
>
>
>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>
>--=20
>SuSE Labs - Research & Development, SuSE Linux AG
> =20
>"If anything can go wrong, it will." "Chance favors the prepared (mind=
)."
>  -- Capt. Edward A. Murphy            -- Louis Pasteur
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
