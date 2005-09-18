From: Tyler <pml@dtbb.net>
Subject: Re: Highpoint 1820A
Date: Sun, 18 Sep 2005 02:04:18 -0700
Message-ID: <432D2D92.3090804@dtbb.net>
References: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:

>
> Hi.
>
> I have struggled with an 1820A for a while, trying to verify it's 
> properly functioning and failing. Does anyone have a success story 
> with this card under linux?
>
> Quite a long story.
>
> First I download the linux package, flash the controller with the 
> attached BIOS, compile the driver etc, everything looks fine. I create 
> the raid, I sync it up, write to it, everything looks fine and dandy. 
> Then I pull a drive, it's properly detected, I replug it and that's 
> also detected. I start a rebuild in the CLI under linux and it starts 
> resyncing. After resyuncing the computer just freezes, the very 
> instant after it says "rebuild complete". After some contact with 
> support@highpoint I end up installing XP and trying it there. I have 
> to reflash into a windows BIOS on the 1820A, but then it works perfectly.
>
> I then re-install linux and run the linux driver on the windows BIOS. 
> Now it's rebuild properly, but after I try to use the verify command, 
> it says "inconsistant" and starts rebuilding again. This can be done 
> three times in a row, it never seems to be consistant.
>
> That's my current situation. I am currently trying software RAID5 
> instead, we'll see if that works better.
>
> I would be very happy to hear from anyone with good experience with 
> this and their open source driver, and hear what configuration you're 
> using and if you had to do anything special.

I failed to mention it in my last email, but you may want to save 
yourself alot of grief anyways, and just use software raid, chances are 
it will be faster, and doesn't require such finicky drivers and support 
from highpoint or any other company for that matter, as long as there 
are drivers to see the card, and the ports as standard sata/ata ports 
(and possibly some different settings in the cards bios).

Tyler.


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.11.1/104 - Release Date: 9/16/2005

