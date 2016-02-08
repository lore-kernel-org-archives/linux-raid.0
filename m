From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Mon, 08 Feb 2016 10:38:40 +0100
Message-ID: <7465555.90dcXqM3S1@matkor-toshiba>
References: <1670804.QnHtKWfib8@nell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1670804.QnHtKWfib8@nell>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 07 February 2016 22:14:08 Thomas Fjellstrom wrote:
> I'm wondering what the "best" route for me to go is. There's a few op=
tions
> that I know of, like flashcache, dm-cache, and bcache. The question i=
s which
> of those is better suited to my use case?

bcache cons:
- no maintainer, bugs living years
- partition have to be formatted as bcache

lvmcache cons:
- in case of failure of caching device, whole cache volume stops workin=
g (data=20
is not lost though).
- cumbersome way of removing cache from LV when caching device is not=20
accessible/failed.

lvmcache pros:
- One can turn on/off caching for active/mounted LV.

We moved from bcache to lvmcache (knowing it's limitations) using write=
-
through mode and for more-reads-than-writes DB access patterns [1].


[1]: Examble postgresql load (sdc is caching SSD, over sda/b RAID10).
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq=
-sz=20
avgqu-sz   await r_await w_await  svctm  %util
sda               0.00    33.93    0.07  179.13     0.00     3.38    38=
=2E59    =20
6.23   34.75   23.50   34.76   2.63  47.07
sdb               0.00    35.97    0.03  177.17     0.00     3.38    39=
=2E04    =20
9.57   53.99  337.00   53.94   2.97  52.66
sdc               8.03     2.63  631.07  201.13     6.04     3.35    23=
=2E10    =20
0.19    0.23    0.19    0.35   0.15  12.34



Regards,
--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 	kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
				Nikos Kazantzakis - "Grek Zorba"

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
