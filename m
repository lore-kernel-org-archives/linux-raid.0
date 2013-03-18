From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: SATA start unit command?
Date: Mon, 18 Mar 2013 18:32:33 +0100
Message-ID: <20130318173233.GA2295@lazy.lzy>
References: <103777438.20130318003050@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <103777438.20130318003050@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?iso-8859-1?Q?F=FCgenstein?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 18, 2013 at 12:30:50AM +0100, Rainer F=FCgenstein wrote:
> hi,
>=20
> for some reasons I need to keep power consumption at startup as low a=
s
> possible. since the server is booting from SSD, it is possible to sen=
d
> a "start unit" (or similar) command to all SATA drives early in the
> init process.
>=20
> as far as I've searchengined, the drives and the SATA controller need
> to support this feature. but my assumption is that when the drives ar=
e
> not needed at startup (since they would be started by the OS), the
> controller won't need to support "start unit".  what is your
> experience on this matter?=20
>=20
> drives in question are WD Green 3TB drives (WDC WD30EZRX-00DC0B0), th=
e
> controllers at hand are a promise SATA 300 TX4 (don't laugh ;-) ) and
> a supermicro AOC-SAT2-MV8.

Hi Rainer,

I'm facing a similar issue.

That's what I got so far...

Many HDDs, but it seems not all, support the so
called Staggered Spin Up, this means they are in
sleep mode, when powered up.
A SATA bus scan will wake them up.

The Linux AHCI driver performs, per default, but
it could be changed by parameter, a serial bus
scan. This means it will wake up the HDDs one after
the other sequentially and not alltogether.
At least, this is what I understood, but I did not
tested it personally, I just trust the information
I found around.
Check "Linux AHCI SSS" with some search engine and
some patience.

Other drivers I do not know.

If you boot from SSD and you program the HDDs to
stay sleepy (jumper, firmware or cable select,
more info at https://en.wikipedia.org/wiki/Spin-up
and referenced links) it *should* work.

Hope this helps,

bye,

pg

>=20
> tnx.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
