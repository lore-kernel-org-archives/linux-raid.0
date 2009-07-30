From: David Rees <drees76@gmail.com>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 13:11:20 -0700
Message-ID: <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
	<20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090730101846.GA17332@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/7/30 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> I think raid10,f2 only degrades 10-20 % while raid1 can degrade as mu=
ch
> as 50 %. For writing it is about the same, given that you use a file
> system on top of the raid.

Has anyone done any benchmarks of near vs far setups?

=46rom what I understand, here's how performance should go for a 2-disk
raid10 setup:

Streaming/large reads far: Up to 100% faster since reads are striped
across both disks
Streaming/large reads near: Same as single disk as reads can't be
striped across both disks

Streaming/large writes far: Slower than single disk, since disks have
to seek to write.  How much of a hit in performance will depend on
chunk size.
Streaming/large writes near: Same as single disk.

Random/small reads far: Up to 100% faster
Random/small reads near: Up to 100% faster

Random/small writes far: Same as single disk.
Random/small writes near: Same as single disk.

So basically, if you have a setup which mostly reads from disk, using
a far layout is beneficial, but if you have a setup which does a
higher percentage of writes, sticking to a near layout will be faster.

I recently set up an 8-disk RAID10 across 8 7200 disks across 3 control=
lers.

5 disks are in an external enclosure via eSATA and a PCIe card.
2 disks are using onboard SATA controller
1 disk is using onboard IDE controller

I debated whether or not to use near or far, but ultimately stuck with
near for two reasons:

1. The array mostly sees write activity, streaming reads aren't that co=
mmon.
2. I can only get about 120 MB/s out of the external enclosure because
of the PCIe card [1] , so being able to stripe reads wouldn't help get
any extra performance out of those disks.

-Dave

[1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silico=
n_Image_3124
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
