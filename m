From: "Bryan J. Smith" <b.j.smith@ieee.org>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 13:57:04 -0400
Message-ID: <1184781424.3641.50.camel@portatux64.mobile.smithconcepts.com>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
	 <469DF6B1.7030000@mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469DF6B1.7030000@mandriva.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe =?ISO-8859-1?Q?Ghib=F2?= <ghibo@mandriva.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2007-07-18 at 13:17 +0200, Giuseppe Ghib=C3=B2 wrote:
> Indeed not exists for PCI-e but Oden has spotted this PCI-X card
> (which is around 97$), based on marvell chipset:
> http://www.supermicro.com/products/accessories/addon/AoC-SAT2-MV8.cfm

Yes!  There are several Broadcom and Marvell ASICs that are eight (8)
SATA (and now even some SAS) channels in a single chip, of which, there
are several vendors selling them for $100 boards.  You do _not_ want an
on-board intelligence being an "intermediary" with software RAID, you
want _direct_ access to the SATA (or SAS) channels.  Besides, they are
cheaper.

Justin Piszcz ha scritto: =20
> I am sure one of your questions is, well, why use SW RAID5 on the=20
> controller?  Because SW RAID5 is usually much faster than HW RAID5,
> at least in my tests ...

Benchmarking direct disk access is a rather poor test of hardware RAID.
to truly evaluate if the off-load from the main system interconnect**
that a hardware RAID gives you, you need to benchmark your actual
_server_ application -- one with MD, the other with hardware RAID.
That's where you can tell if hardware RAID is going to buy you anything=
=2E

**NOTE:  It's the system interconnect bottleneck that is of concern, no=
t
so much the CPU.  A modern, superscalar, multi-core x86-64 CPU can do
XORs in its sleep, with just MMX (won't even peg your CPU 10%).  It's
the LOAD/STO push just to get the XOR that ties up your system
interconnect (often with your CPU only being 10% busy if your
application is not processor-bound, but I/O ;-) that's the problem.

It's been my experience that for web services, hardware RAID buys you
_little_, because you're more processor bound than I/O bound, so you
have cycles you can use while your interconnect is doing I/O processing=
=2E
But more on the database and file server side, I pair a hardware RAID
(e.g., AMCC/3Ware PPC400-based or Areca IOP/X-Scale-based) with a RX TO=
E
(_Receive_ TCP Off-load Engine) HBA "NIC" (e.g., LeWiz 4-port GbE PCIe)=
,
which keeps the system inteconnect free for pushing the application dat=
a
(instead of doing what is, essentially, "programmed I/O" for the XOR
software RAID operation).

Again benchmark your server _application_, not the disk I/O.


--=20
Bryan J. Smith         Professional, Technical Annoyance
mailto:b.j.smith@ieee.org   http://thebs413.blogspot.com
--------------------------------------------------------
        Fission Power:  An Inconvenient Solution

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
