From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: RAID5 causing lockups
Date: Wed, 25 Jun 2003 13:56:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306251356330437.4DA4F49C@shargaas.coreyfro.com>
References: <200306251216300921.4D495D48@shargaas.coreyfro.com>
 <1056573394.24919.62.camel@mattswrk>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1056573394.24919.62.camel@mattswrk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

drives are silent.  No activity at all.

Maybe i'll give it a try tonight again.  I can give it a bunch more
horsepower (have it underclocked because the system is basicly a big disk)
maybe if I have more available CPU, the arrays will be a bit more busy if
they really are rebuilding.

still, the problem causes top to stop.  I wouldn't think that would be a
problem if the array was just rebuilding...

*********** REPLY SEPARATOR  ***********

On 6/25/2003 at 1:36 PM Matt Simonsen wrote:

>On Wed, 2003-06-25 at 12:16, Corey McGuire wrote:
>> Hey folks,
>> 
>> I just upgraded my system from a ~200GB mirror to a ~1TB RAID5, but all
>has
>> not transitioned well.
>
>
>Did the RAID array every finish syncing? It may take a long time
>(1048576 megs / 10 mb/sec / 3600 seconds/hr = 29 hours!) ... 
>
>I have one (SCSI) system with a slower CPU, syncing the array I was sure
>something was wrong. Once the array was up, though, everything has
>worked great. I just have to be sure it shuts down clean or the rebuild
>is painful!
>
>Maybe I'm way off, but I'd just give it a day to see if it eventually
>syncs. If you can login, do a cat of /proc/mdstat every 15 minutes, if
>it's making progress I'd leave it.
>
>Matt




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

