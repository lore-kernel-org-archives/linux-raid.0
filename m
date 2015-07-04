From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Sat, 04 Jul 2015 08:58:34 +0100
Message-ID: <5597922A.90402@youngman.org.uk>
References: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/07/15 07:10, Justin Stephenson wrote:
> ata6.00: ATA-8: ST3000DM001-9YN166, CC4H, max UDMA/133
> ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> ata7.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata8.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> ata8.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata5.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata6.00: configured for UDMA/133
> ata4.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA

OWWWWW OWWWWWW OWWWWW

Are these 3TB Seagate Barracudas? (Same as mine). You DO NOT want to be
running raid 5 or 6 on these things !!!! They're desktop drives not
meant for raid.

They do not support ERC. *One* *soft* failure on these and you run a
good chance of trashing your array !!!!

Make sure you've got your raid timeout increased - there's plenty of
threads about how to do it - otherwise one disk hiccup for any reason is
likely to cause a cascade of failures !!!!

You need to upgrade them to Western Digital Reds or similar asap.

Cheers,
Wol
