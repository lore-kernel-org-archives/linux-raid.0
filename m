From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Data corruption on software raid.
Date: Sun, 18 Mar 2007 10:02:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703180959090.32397@p34.internal.lan>
References: <20070318131606.GJ6063@freshdot.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070318131606.GJ6063@freshdot.net>
Sender: linux-raid-owner@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 18 Mar 2007, Sander Smeenk wrote:

> Hello!  Long story. Get some coke.
>
> I'm having an odd problem with using software raid on two Western
> Digital disks type WD2500JD-00F (250gb) connected to a Silicon Image
> Sil3112 PCI SATA conroller running with Linux 2.6.20, mdadm 2.5.6

[[ .. snip .. ]]

See comments below.

| Personalities : [raid1]
| md0 : active raid1 hda2[0] hdb1[1]
|       120060736 blocks [2/2] [UU]

My main question:

Why the 'heck' are you running a RAID1 with a master/slave combination? 
That is probably the -worst- way to run it.  When using any form of RAID, 
make sure you do not share an IDE channel for any one raid device.

Advice?  Hook up each drive as a master, then your rebuild speed should go 
to 30-60MB/s.

Traditional Troubleshooting:

What does fdisk -l /dev/hda
           fdisk -l /dev/hdb

Report?

Also,

What does:

smartctl -a /dev/hda
smartctl -a /dev/hdb

show?

Then,

smartctl -t short /dev/hda
smartctl -t short /dev/hdb

Wait 5-10 minutes, re-run the commands (-a) above.

Then,

smartctl -t long /dev/hda
smartctl -t long /dev/hdb

Then re-run the (-a) smartctl above.

--------

Those errors look really weird, I would separate the two disks, each on 
their own IDE channel and see if your problem goes away.

Justin.

