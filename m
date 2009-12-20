From: Andre Tomt <andre@tomt.net>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 15:53:08 +0100
Message-ID: <4B2E3A54.5050009@tomt.net>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <4B2D4731.3090702@gmail.com> <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com> <200912200255.16513.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912200255.16513.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Michael Evans <mjevans1983@gmail.com>, Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20.12.2009 10:55, Thomas Fjellstrom wrote:
> While the driver support isn't "perfect"*, I have an AOC-SASLP-MV8, a 2 port
> SAS 4x PCI-e card. (with SAS->SATA converters, its an 8 port SATA card)
>
> When I was running some tests on individual drives, and watching iostat, I
> saw over 500MB/s combined throughput, and that was with only 5 drives.
> Theoretically it should be capable of 1GB/s given its a x4 card.
> Theoretically.
>
> At the very least, the card should be more than capable of providing enough
> bandwidth for all 8 ports to be filled with regular mechanical hard drives
> (sans port expanders).

Having tried it connected directly to the north bridge, it seems to top 
out at ~650-700MB/s (also using Windows driver). Which is not too bad 
for a pcie 1.0 x4 card, but unfortunatly will only manage to saturate 
about ~5 modern mechanical drives (currently at 120-130MB/s each for 
SATA 7200rpm), if high sequential performance is all you're looking for.

Currently I solved that by having 4 drives from the array on that card, 
and populating the last four ports with with drives that are seldomly 
used and when used get mostly random i/o but still needs a port ;-)

Still good value for money, indeed.
