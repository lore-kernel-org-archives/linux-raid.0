From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Sat, 4 Jul 2015 10:10:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
References: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez> <5597922A.90402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1966040650-1435997446=:11810"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5597922A.90402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1966040650-1435997446=:11810
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 4 Jul 2015, Wols Lists wrote:

> On 04/07/15 07:10, Justin Stephenson wrote:
>> ata6.00: ATA-8: ST3000DM001-9YN166, CC4H, max UDMA/133
>> ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>> ata7.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata8.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>> ata8.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata5.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>> ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata6.00: configured for UDMA/133
>> ata4.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
>> ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>
> OWWWWW OWWWWWW OWWWWW
>
> Are these 3TB Seagate Barracudas? (Same as mine). You DO NOT want to be
> running raid 5 or 6 on these things !!!! They're desktop drives not
> meant for raid.

Not only that, but they're known to have en extremely high failure rate:

https://www.backblaze.com/blog/3tb-hard-drive-failure/

"As of March 31, 2015, 1,423 of the 4,829 deployed Seagate 3TB drives had 
failed, that’s 29.5% of the drives."

> Make sure you've got your raid timeout increased - there's plenty of 
> threads about how to do it - otherwise one disk hiccup for any reason is 
> likely to cause a cascade of failures !!!!

I recommend this as minimum (in rc.local for instance):

for x in /sys/block/sd[a-z] ; do
         echo 180  > $x/device/timeout
done

echo 4096 > /sys/block/md0/md/stripe_cache_size

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1966040650-1435997446=:11810--
