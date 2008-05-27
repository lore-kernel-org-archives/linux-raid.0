From: "Grant Grundler" <grundler@google.com>
Subject: Re: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
Date: Mon, 26 May 2008 17:34:25 -0700
Message-ID: <da824cf30805261734g6dbd43yfda62124973b98cf@mail.gmail.com>
References: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan>
	 <4839A63E.4050409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4839A63E.4050409@rtr.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 25, 2008 at 10:47 AM, Mark Lord <liml@rtr.ca> wrote:
...
> Sure, if the bus and memory are fast enough.  You'll hit the Linux/libata
> transactions/sec limit at some point, but I don't know what that is.
>
> Eg. Here's a 4X (I think) card in my PCIe video slot:
>
> beefy:~# mdadm --create /dev/md0 --chunk=256 -l 0 --raid-devices=4
> /dev/sd[bcde]
> mdadm: array /dev/md0 started.
>
> beefy:~# hdparm -t --direct /dev/sd[bcde] /dev/md0
>
> /dev/sdb:
> Timing O_DIRECT disk reads:  218 MB in  3.01 seconds =  72.46 MB/sec
>
> /dev/sdc:
> Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.00 MB/sec
>
> /dev/sdd:
> Timing O_DIRECT disk reads:  192 MB in  3.01 seconds =  63.79 MB/sec
>
> /dev/sde:
> Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.07 MB/sec
>
> /dev/md0:
> Timing O_DIRECT disk reads:  768 MB in  3.00 seconds = 255.69 MB/sec

The bottle neck here is with the four disks.
Modern 1TB 7200 rpm disks have raw throughput rates up to around
100MB/s. Anything in the last 4-5 years should do better than 60MB/s.

In theory, ~16 disks (4 disks per 7042 port using Port Mulitpliers),
one should be able to hit 200+ MB/s per 7042 port and approach 900MB/s
total. Getting more than 900Mb/s will depend on the chipset. IIRC, the
MMRBC of 128 bytes will result in about 15% protocol overhead in the
PCI-e link.
Bigger PCI-e "burst" will result in dramatically less overhead (IIRC,
256Byte == 9% overhead.)

hth,
grant
