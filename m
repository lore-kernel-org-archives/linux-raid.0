From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: Show me the cache, was Mirroring swap
Date: Fri, 27 Jun 2003 11:04:27 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306271104270562.57541D29@shargaas.coreyfro.com>
References: <Pine.GSO.4.33.0306271209220.7750-100000@sweetums.bluetronic.net>
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0306271209220.7750-100000@sweetums.bluetronic.net>
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>"Unlike windows"?  Do you even *use* windows?  Windows has had the same
>filesystem caching capability as linux for many years now.  Linux is a lot
>more lax about what it'll keep in memory -- basically, cache pages will
>not be pushed out until something needs the memory (application or another
>cache page.)  Windows limits the ammount of cached space and tends to dump
>things a great deal faster...

Dude, that is what I said.

What I said was windows gives up way too quickly.  What I did not say is
that it doesn't cache at all, which would be insane.  Windows NT's memory
manglement is "pretty good" apart from its forgetfulness.

What is most annoying is there are hooks for tweaking cache size, but even
then, windows doesn't listen.  The only options in the windows registry
that have any lasting effects are these.

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory
Management]
"DisablePagingExecutive"=dword:00000001
"LargeSystemCache"=dword:00000001

The first one doesn't even effect cache, it just doesn't swap the kernel,
which greatly reduces the load on the cache.  "LargeSystemCache" hardly
helps, as it basicly tells Windows "yes, all RAM _CAN_ be used for cache"
instead of just a paultry 4MB.  Does this help?  Yeah, my 512MB machine is
currently using 18MB's of cache.

There are cache replacements on the web, but most are overpriced for what
they do.  Any free cache program is bogus (like system internal's cacheset)
because they use system calls that are most often ignored and frequently
reset, at least, from what I have seen in my attempts to make Windows NT
cache intelligently.



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

