From: Stefan Borggraefe <stefan@spybot.info>
Subject: Re: Help with recovering a RAID5 array
Date: Thu, 02 May 2013 16:17:04 +0200
Message-ID: <1756409.rphx7Sd8Zh@chablis>
References: <34199580.p6EyCyMeIZ@chablis> <3800236.bN8bMq2WMZ@chablis> <CADNH=7GNmLMZeAcueKmHP2QS=PKbgGBuR2GpM0yMGmDBDiijjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GNmLMZeAcueKmHP2QS=PKbgGBuR2GpM0yMGmDBDiijjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Donnerstag, 2. Mai 2013, 14:49:39 schrieb Mathias Bur=E9n:
> Ugh, Adaptec, not my favourite controller. Do you have arcconf
> installed? You could to arcconf getconfig 1 (or whatever your
> controller number is) to grab some information regarding your
> controller and the HDDs connected to it.

arcconf getconfig 1
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Inaccessible

----------------------------------------------------------------------
Logical device information
----------------------------------------------------------------------
   No logical devices configured

----------------------------------------------------------------------
Physical Device information
----------------------------------------------------------------------


Command completed successfully.

Could this be because we do not use the hardware RAID features of
the controller?
=20
> Do you have /dev/sg? devices? If so, smartctl -a might work on them.

Yes, but using smartctl -a/-x on these devices gives the same output as
using it on the /dev/sd? devices. :(

> Re the software RAID, I would double check the health of your HDDs
> before attempting anything.

Ok, this makes sense.
--=20
Best regards,
Stefan Borggraefe

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
