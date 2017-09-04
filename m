From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Superblock Missing
Date: Mon, 4 Sep 2017 17:49:47 +0200
Message-ID: <20170904154947.GA5263@metamorpher.de>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de>
 <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
 <20170902164906.GA6823@metamorpher.de>
 <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Mitchell <mr.david.mitchell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 03, 2017 at 11:35:25PM -0400, David Mitchell wrote:
> I really do NOT remember running the  --create command.

There is no other explanation for it. It has happened somehow.

> The pictures over 512k don't display correctly.

So not only/necessarily a wrong data offset, but also wrong drive order.

> At this point I'm hoping for help on next steps in recovery/troubleshooting.

1. Use overlays.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

   That way you can safely experiment and create RAID with 
   different settings. (Use --assume-clean and/or missing)

2. Check first 128M of each drive (your current data offset).
   See if you can find a valid filesystem header anywhere.
   That way you could determine the correct data offset.

3. Find a JPEG header (any known file type, like a 2-3M file)
   and look at the other drives for the same offset. You should be 
   able to deduce RAID layout, chunksize, drive order from that.

Instead of 3) you can also simply trial and error with overlays 
until you find a setting that allows photorec to find larger files intact.

The resync might not necessarily have damaged your data. If the offsets 
were the same and the RAID level was the same, and the drives were in 
sync, a resync even with wrong settings would still produce the same data. 
For XOR, a ^ b = c and b ^ a = c so switching the drives does no damage 
provided you don't write anything else...

Regards
Andreas Klauer
