From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: RAID5 causing lockups
Date: Wed, 25 Jun 2003 12:41:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306251241310578.4D604338@shargaas.coreyfro.com>
References: <Pine.LNX.4.33.0306251524310.2439-100000@router.windsormachine.com>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0306251524310.2439-100000@router.windsormachine.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NASTY!

Thanks, I'll give that a whirl.  Is there a way I can kill all power
manglement outside of the BIOS just to make sure I prevent this?  Once this
is working, I won't even need console blanking.

Should I make sure APM is killed in the kernel config too?  I think I may
have turned it on when I added RAID5 support, thinking I'd use idle calls
now that I have 6 7200RPM drives to heat up my case ;-)

The system opporated in a mirror just fine for around year, if that makes a
difference... using two of these drives (hde and hdk if my memory serves)

*********** REPLY SEPARATOR  ***********

On 6/25/2003 at 3:28 PM Mike Dresser wrote:

>On Wed, 25 Jun 2003, Corey McGuire wrote:
>
>> I have 6 drives and 3 controllers.  Each drive is a 200GB WD drive, set
>to
>> "Single/Master" on their channel.
>
>Go get the utility on wdc's site to fix the problems they have, and see
>what happens after that.
>
>http://support.wdc.com/download/index.asp#raidno3ware
>
>They have problems with power management, and the drive is kicked out of
>the raid array.
>
>This may or may not be the trouble, but at least see if it needs it.
>
>Mike




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

