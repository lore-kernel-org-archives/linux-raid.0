From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Re: Highpoint 1820 Redux
Date: Thu, 15 Jan 2004 10:03:42 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4006D5FE.50503@physics.ucsd.edu>
References: <1074180553.25091.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074180553.25091.52.camel@localhost.localdomain>
To: numlock@freesurf.ch
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you absolutely have to go with a do it yourself solution to a large=20
IDE raid array use 3ware PCIX cards on a supermicro board. 3ware has th=
e=20
overall best support in Linux with utilities and source code drivers=20
included with the kernel. I have also had experience with Adaptec and=20
SIIG, both onboard and addin cards with only limited success.

If you want to have no contention for the PCI bus supermicro even makes=
=20
a board with two south bridge so that the PCI bus is split. However PCI=
X=20
has about an 800MBps so even two of these cards should not be a problem=
=20
but the possibility is there if you want it. We actually used those=20
boards but that was to support two dual Myrinet cards in the same box,=20
or about 8Gbps. Two 8 disk sets will only run in the hundreds of mbits/=
s.

I also recommend you plan for hot spares, get at least two cold standby=
=20
disks and at least one spare controller.

But...for the cost you probably do not want to roll your own RAID=20
anymore. For about the same money you can get an entirely integrated=20
solution with redundancy in the controllers and a fiberchannel interfac=
e=20
to your control node or switch. You can either attach the RAID to a=20
system directly, or purchase a fiberchannel switch and mix and match=20
between multiple disk packs and multiple nodes.

Two that I have worked with include the 4.5TB 16 disk device from=20
http://www.infortrend.com/ and the XServer Raid from apple=20
http://www.apple.com/xserve/raid/ that can handle up to 3.5TB.

The former uses SATA, the latter PATA drivers. Both have hot swap,=20
redundant controllers, large memory disk caches and batteries to keep=20
the cache alive for days as an option and both can hook into any=20
fiberchannel PCI card or fiberchannel switch.

Having used both roll your own RAID in our clusters and the fiberchanne=
l=20
attached IDE Raid devices the fiberchannel style wins hands down for=20
reliability, ease of support, performance (a weak spot in the past) and=
=20
even cost which is comparable.

Cheers,

Terrence




Jo=EBl Bourquard wrote:
> Hi,
>=20
> I would appeciate some advice on SATA controllers.. and since many
> people appear to be concerned, I'm posting it here.
>=20
> The arrays will be two software RAID5 of 8 SATA disks each.
>=20
> The mainboard will probably be a Tyan S2880GNR. In short it provides:
> - two 64-bit 66MHz PCI-X slots
> - and two 64-bit 66/133MHz PCI-X slots.
>=20
> Unless it proves to be foolish, I'll probably put 1 CPU on it.
>=20
> Now I was about to simply take two Highpoint RocketRAID 1820, but
> according to some posts here, it seems the guys at Highpoint didn't
> provide great Linux support after all. Sigh.
>=20
> Now it seems they added a "Linux OpenBuild driver" there:
> http://www.highpoint-tech.com/USA/brr1820.htm
>=20
> Does it use libata ? Is it just a marketing joke ? Has anyone tried i=
t
> with an actual board ?
>=20
> It seems Jeff Garzik recommends the Promise or ServerWorks 4- and 8-p=
ort
> boards instead (from http://www.spinics.net/lists/raid/msg03936.html)=
=2E
>=20
> Trouble is, I have seen no such 8-port board. The only thing I found =
on
> the web was a SuperMicro board with a Marvell (?) chip onboard:
> http://www.supermicro.com/PRODUCT/Accessories/DAC-SATA-MV8.htm
>=20
> They seem to have sources for a kernel module there:
> ftp://ftp.supermicro.com/driver/SATA/DAC_SATA-MV8/LinuxIAL/
>=20
> Now I'm a bit lost.. I mean, of these two boards (Highpoint and
> SuperMicro), which one (if any) is supposed to work well in Linux
> 2.4.20+ or 2.6.0+ ? Which one would work with TCQ enabled ?
>=20
> My primary concern when making a RAID5 is the read performance. So th=
at
> would be nice if my controller is among the fastest when using libata=
=2E
> In particular, TCQ support (when it happens) will be important.
>=20
> Since hardware RAID is not needed, and there are four PCI-X slots, I
> thought about using four 4-port controllers (or maybe three 6-port
> controllers).
>=20
> Now...
> - are they slower than 3ware (JBOD) and other 8-port controllers ?
> - do they have onboard SRAM ?
>=20
> Fortunately, since it is a dedicated machine, pretty much any kernel
> version can be used if needed.
>=20
> Sorry for the long post..
>=20
> Thanks in advance !
>=20
> Joel
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
