From: Maurilio Longo <maurilio.longo@libero.it>
Subject: Re: Badstripe proposal (was Re: Bad blocks are killing us!)
Date: Sat, 20 Nov 2004 14:15:30 +0100
Message-ID: <419F4372.CD77B4DD@libero.it>
References: <200411162307.iAGN7lN28260@www.watkins-home.com>
		<419B5050.1010501@dgreaves.com>
		<419C729D.3E36A473@libero.it> <20041119181222.6ce1f1be.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jure Pe ar <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jure Pe,

can we use dm-bbr without installing evms? I'd like not to install it s=
ince it
seems to me a cumbersome tool while my systems with raid1 and grub are =
fairly
easy to create and maintain.

regards.



Jure Pe ar ha scritto:

> On Thu, 18 Nov 2004 10:59:58 +0100
> Maurilio Longo <maurilio.longo@libero.it> wrote:
>
> > David and others,
> >
> > I'd like to add that evms ( http://evms.sourceforge.net/ ) already =
has a
> > bad-block management layer, maybe it could be merged inside md to h=
ave
> > write errors management as well, maybe :)
>
> BBR as it is called is implemented with a device mapper. AFAIK one ca=
n take
> dm managed block devices and build md with them.
>
> --
>
> Jure Pe=E8ar
> http://jure.pecar.org/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
 __________
|  |  | |__| md2520@mclink.it
|_|_|_|____| Team OS/2 Italia


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
