From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: SATA ontrollers and Linux MD
Date: Wed, 30 Aug 2006 14:11:00 +0100
Message-ID: <000f01c6cc35$bd628040$0e00a8c0@sherlock>
References: <541048249.20060403093652@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <541048249.20060403093652@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi,

I've a file server running on an Athlon XP 3200+ motherboard, currently using a
mixture of PATA and SATA-150 drives and Fedora Core 5 Linux. 5x 120GB Seagate
drives form a single raid-5 volume. One of those drives has failed, the rest
are old, and I'm looking to replace all of them. I'd appreciate any help
selecting components!

The motherboard uses a KT600 chipset and so includes two SATA-150 connections
serving 2 of the Raid-5 disks. The rest of the Raid-5 is currently run off a 2
channel Highpoint PATA PCI controller.

Currently, I'm looking at buying 5 Samsung P120 series drives - the 250GB
SATA-300 "SP2504C". To reduce cost I might possibly use 4 rather than 5, or
might go for the 160GB variant. Reason for these drives is I've found them
quiet, and reasonably fast & cool - all important to me. I don't need
cutting-edge performance, but reliability is good!

Controller-wise, finding suitable SATA-300 controllers is hard. Requirements
include at least 4 internal ports and a PCI not PCIe interface. I might end up
with a SATA-150 controller and upgrade it and the MB sometime later. I'm not
really after a dedicated RAID controller such as the 3ware ones, as (a) I can't
really justify the cost and (b) I want to use Linux MD for reasons of
portability.

Aside: Over PCI, is it better to use two separate 2-channel PCI cards or one
4-channel card? For example, 2x Sil 3112 chips or 1x Sil 3114, given that
you're using all disks in JBOD mode?

I'm very tempted by the Sil 3124 controller, although I've not had much luck
finding a PCI version of it. In the States there's a company "SATACard" who
appear to make one that's suitable, but I can't find a UK supplier. Scan are
selling the Supermicro 8 Port SATA 2 RAID Card AOC-SAT2-MV8, but with not much
info other than it's based on the Marvell Hercules-2 Rev. C0 SATA host
controller. Others that include the various Promise and Highpoint controllers,
but my experience of Promise QA is not good, and Highpoint SATA-300 seems to
use Infiniband, for which Linux support looks really cutting edge. I don't want
to use proprietary drivers and I'd much prefer something FC5 supports natively.

Any thoughts?

Thanks,

Ruth

