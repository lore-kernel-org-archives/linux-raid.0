From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Mon, 14 Feb 2005 08:05:51 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502140754340.29594@lion.drogon.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com>
 <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <421028BC.6040902@nsr500.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <421028BC.6040902@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Feb 2005, Tim Moore wrote:

> Gordon Henderson wrote:
> >
> > Anyone using Tyan Thunder K8W motherboards???
> >
> > I now know, there is a K8S (server?) version of that mobo, but at the time
> > it was all orderd, I wasn't aware of it - my thoughts are there there is
> > some sort of PCI/PCI-X problem with either the motherboard or the chipset,
> > and in all probability the K8S mobo will have the same chipsset and same
> > problems anyway...
>
> I'm using a K8W at work as a driver client for NAS testing.  Onboard
> Broadcom GigE, Linksys Marvell GigE, 2xWD1200JD + 2xMaxtor Maxline Plus II
> as RAID-0 and RAID-5 using the Sil_3114, 2.4.29, raidtools 1.0.  2+2x1GB
> PC-2700 in first and third slots for each CPU.  All PCI-X/HT configs set to
>   Auto in BIOS and Jumpers, 2.02b BIOS.  No issues except for a bad SATA cable.
>
> Striping yields ~90MB/s, RAID-5 about 65r, 55w on 8GB Bonnie++ runs, 2GB dd
> reads on raw devices yields ~55MB/s

I've not had any issues with the on-board 3114 controller. It's not
blindingly fast, but it's at the end of 2 PCI bridges and on a 33MHz
32-bit bus, but it's fine. I've had over 270MB/sec reads out of an 8-way
RAID-0 array. (300Mb/sec writes!) although I want raid-6 on all
partitions, that drops down to ~130MB/sec read.

The problems happen when I plug-in a PCI SATA card (3112 chipset based).
I've tried 2 different types of cards and while one is better than the
other (causes less or no lock-ups) it's still not perfect. I'm going to
try a 4-port card this week. It's solid with only one PCI card in.
Assitionally, if I plug a card into PCI slots 3 or 4, then the bios locks
up at boot time (Checking NVRAM ... )

Hm. According to the manual, your memory configuration isn't supported -
you should be using slots 1 & 2 for each processor to get 128-bit
access... I only have 2 x 512MB PC2700 modules in slots 1 & 2 of CPU0.

If this box was just going to be a fileserver (NAS sort of thing) then I'd
have gone with a single processor, but it's also going to be running some
huge CVS and MySQL application (home built version control system) and
they specified dual-processors. (The existing setup runs on a dual Xeon
PII/700 Dull box which takes up too much rack space and doesn't have
enough disks)

Gordon
