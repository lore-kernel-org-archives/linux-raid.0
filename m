From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 - cache
Date: Thu, 20 Jan 2011 07:20:16 +1100
Message-ID: <20110120072016.1b2162c8@notabene.brown>
References: <AANLkTik7xBOYVgZJC0sStpK=oPHdX53XzwYC5CVDKy_v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik7xBOYVgZJC0sStpK=oPHdX53XzwYC5CVDKy_v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 18:13:23 -0200 Roberto Spadim <roberto@spadim.com.b=
r>
wrote:

> Hi guys, from a long email i will start this one: (the last one wasn=B4=
t send)
>=20
> think about this:
>=20
> /dev/sda (sata disk 1000gb size, latency of 1ms to move head, 100mb/s
> to write/read)
> /dev/sdb (ssd 1gb size, latency of <100us to find what flash and
> position, 500mb/s to write/read)
> ram memory (8gb size, with 1gb not used)
> /dev/mdxxx (the new device i=B4m calling it as raid0-cache)
>=20
> how raid0-cache work?
>=20
>=20
> how to create raid?
> tell what the sequencial read cache estrategy:
> memory(tell fixed memory size) - /dev/sdb - /dev/sda - another device
> (maybe just 2 is suficiente /dev/sdb and /dev/sda)...
>=20
>=20
> how to read?
> first, read from the first read device (memory)
> if information not there -> read from second read device (/dev/sdb),
> update information at first read device, return the read value
> if information not there -> read from third read device (/dev/sda),
> update information at second and first read device, return the read
> value
>=20
> how to write?
> flush space from first read device to second read device
> write to first read device, return OK
>=20
> background thread:
> sync from first write device (memory) to second write device (/dev/sd=
b)
> flush from second write device (/dev/sdb) to third write device (/dev=
/sda)
>=20
> startup:
> using cache:
>  flush everythink from first write device (memory) to second write
> device (/dev/sdb)
>  flush everythink from second write device (/dev/sdb) to second write
> device (/dev/sda)
>  since memory is volatille, at startup it can=B4be flushed...
> without cache:
>  make first write device unusable (memory)
>  make second write device unusable
>  here we can have write problems, since a wrong power off, can lost
> information from cache (first and second write device)
>=20
>=20
>=20
> anyidea who can make it?

"Hey, I've got this clever idea, I wish someone would implement it" alm=
ost
always results in ... nothing.
People with the ability to implement are much more interested in implem=
enting
their own ideas.

But see also "bcache".

NeilBrown

> thanks
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
