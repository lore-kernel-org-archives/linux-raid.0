From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 09:03:44 -0700
Message-ID: <200912200903.44435.tfjellstrom@shaw.ca>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <200912200255.16513.tfjellstrom@shaw.ca> <4B2E3A54.5050009@tomt.net>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2E3A54.5050009@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Michael Evans <mjevans1983@gmail.com>, Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun December 20 2009, Andre Tomt wrote:
> On 20.12.2009 10:55, Thomas Fjellstrom wrote:
> > While the driver support isn't "perfect"*, I have an AOC-SASLP-MV8, a 2
> > port SAS 4x PCI-e card. (with SAS->SATA converters, its an 8 port SATA
> > card)
> >
> > When I was running some tests on individual drives, and watching
> > iostat, I saw over 500MB/s combined throughput, and that was with only
> > 5 drives. Theoretically it should be capable of 1GB/s given its a x4
> > card. Theoretically.
> >
> > At the very least, the card should be more than capable of providing
> > enough bandwidth for all 8 ports to be filled with regular mechanical
> > hard drives (sans port expanders).
> 
> Having tried it connected directly to the north bridge, it seems to top
> out at ~650-700MB/s (also using Windows driver). Which is not too bad
> for a pcie 1.0 x4 card, but unfortunatly will only manage to saturate
> about ~5 modern mechanical drives (currently at 120-130MB/s each for
> SATA 7200rpm), if high sequential performance is all you're looking for.
> 
> Currently I solved that by having 4 drives from the array on that card,
> and populating the last four ports with with drives that are seldomly
> used and when used get mostly random i/o but still needs a port ;-)
> 
> Still good value for money, indeed.

I tried it on windows, and the tests were abysmal. worse than anything linux 
gave. Maybe it was windows's dynamic disks raid sucking, but it was 
horrible. I ran a disk benchmark test on it, and the whole suite of tests 
should have been able to finish after 12 hours, but after about 24, it 
wasn't even done the first read test.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
