From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid
 Level Migration and Online Capacity Expansion
Date: Tue, 27 Dec 2005 07:55:14 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0512270751300.13179@lajli.gau.hu>
References: <200512221707.jBMH7PCS028943@cichlid.com>
 <17323.2382.350576.347316@smtp.charter.net>  <Pine.LNX.4.58.0512222359390.13179@lajli.gau.hu>
 <53aae5ff0512262246s4928ed68v4de0b027f0622645@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53aae5ff0512262246s4928ed68v4de0b027f0622645@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeane <jeane.genet@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Dec 2005, jeane wrote:

> bonjour!
bonjur, ca va? :)

> I was going thrugh the thread I am also in the processing of deciding
> weither to procurz H/W raid, One significant matter would be
> performances of the systems,

On a server-class hardware, no significant cpu load can be observed.
We have serverworks/xeon or Adaptec, LSI and Fusion scsi ctrl, they are
good (in this order: Fusion MPT very impressiv :)
The sun v20z AMD-8131,  LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT
Dual Ultra320 SCSI is good to.

But, the cheap motherboards (sis chipset) and bad config can kill cpu.
Especialy the wrong PATA config, like raid1 on hda/hdb.

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
