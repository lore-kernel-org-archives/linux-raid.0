From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Issue removing failed drive and re adding on raid 6
Date: Sat, 04 Jul 2015 16:38:18 +0000
Message-ID: <emf8fb4dd8-3843-4c1c-b8e4-35b5028b3f14@littlez>
References: <5597922A.90402@youngman.org.uk>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5597922A.90402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>6.00: ATA-8: ST3000DM001-9YN166, CC4H, max UDMA/133
>>  ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>  ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>>  ata7.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>  ata8.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>>  ata8.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>  ata5.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>>  ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>  ata6.00: configured for UDMA/133
>>  ata4.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>>  ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>
>OWWWWW OWWWWWW OWWWWW
>
>Are these 3TB Seagate Barracudas? (Same as mine). You DO NOT want to be
>running raid 5 or 6 on these things !!!! They're desktop drives not
>meant for raid.
>
>They do not support ERC. *One* *soft* failure on these and you run a
>good chance of trashing your array !!!!
>
>Make sure you've got your raid timeout increased - there's plenty of
>threads about how to do it - otherwise one disk hiccup for any reason 
>is
>likely to cause a cascade of failures !!!!
>
>You need to upgrade them to Western Digital Reds or similar asap.
>
>Cheers,
>Wol


Hi Wol,

Yes, these are the 3GB Seagates. They have been running 24/7 for about 3 
years now. I lose a drive occasionally, replace and rebuild. I will 
consider the REDs for the next time I do an upgrade - I imagin I would 
have to replace all 7 drives at once. How about the Seagate NAS HDDs?

I will look at the the raid timeout. Thank-you for the tip.

- Justin

