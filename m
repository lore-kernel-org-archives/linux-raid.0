From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Sun, 05 Jul 2015 16:58:35 -0600
Message-ID: <1769278.0JzAUmkQ4M@balsa>
References: <emf8fb4dd8-3843-4c1c-b8e4-35b5028b3f14@littlez>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <emf8fb4dd8-3843-4c1c-b8e4-35b5028b3f14@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat 04 Jul 2015 04:38:18 PM you wrote:
> >>6.00: ATA-8: ST3000DM001-9YN166, CC4H, max UDMA/133
> >>
> >>  ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> >>  ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> >>  ata7.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> >>  ata8.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> >>  ata8.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> >>  ata5.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> >>  ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> >>  ata6.00: configured for UDMA/133
> >>  ata4.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
> >>  ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> >
> >OWWWWW OWWWWWW OWWWWW
> >
> >Are these 3TB Seagate Barracudas? (Same as mine). You DO NOT want to be
> >running raid 5 or 6 on these things !!!! They're desktop drives not
> >meant for raid.
> >
> >They do not support ERC. *One* *soft* failure on these and you run a
> >good chance of trashing your array !!!!
> >
> >Make sure you've got your raid timeout increased - there's plenty of
> >threads about how to do it - otherwise one disk hiccup for any reason
> >is
> >likely to cause a cascade of failures !!!!
> >
> >You need to upgrade them to Western Digital Reds or similar asap.
> >
> >Cheers,
> >Wol
> 
> Hi Wol,
> 
> Yes, these are the 3GB Seagates. They have been running 24/7 for about 3
> years now. I lose a drive occasionally, replace and rebuild. I will
> consider the REDs for the next time I do an upgrade - I imagin I would
> have to replace all 7 drives at once. How about the Seagate NAS HDDs?

I've just been replacing my desktop drives (all seagates, 1, 2 and 3 TB) as 
they fail. I've got 5 WD REDs now, in two separate arrays. I think 2 2TB REDs 
(out of 7 drives total) in my main NAS raid5 array (If I had room for one more 
drive, I'd make it a raid6), and 3 3TB REDS (out of 6 main drives, one hot 
spare, and one cold spare) in my backup raid6 array.

Yeah, I've become paranoid enough that I have a full backup of the main NAS 
array now. I actually had to use it recently, due to a really stupid mistake 
I'd rather not talk about that wiped the filesystem ;D probably half of the 
array "failures" I've had were pebkac, so having a full backup copy is 
incredibly important for me. The backup array also stores backups of my 
/important/ rsnapshot backups of my machine configs, documents, and other 
important things.

> I will look at the the raid timeout. Thank-you for the tip.
> 
> - Justin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
