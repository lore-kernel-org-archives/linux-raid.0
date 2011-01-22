From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA questions
 for HW owners/users
Date: Sat, 22 Jan 2011 10:04:25 -0600
Message-ID: <4D3B0009.6020006@hardwarefreak.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com> <4D39D8B5.1090901@hardwarefreak.com> <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans put forth on 1/21/2011 11:50 PM:

> I wouldn't mind spending an extra $50 on the controller IF I knew it
> supported 48 or 64 bit LBA, however neither the documentation on Intel

No product descriptions list 48 bit LBA because ALL SAS/SATA devices and HbAs
since ATA-6 (around 2003) natively support 48 bit LBA.  LBA48 is what got us
past the 137GB barrier.  The industry jumped from 28 bit LBA straight to 48 bit
LBA.  Google will show you this information in about 0.5 seconds.  I'll save you
those 0.5s:  http://www.48bitlba.com/

> and NewEgg specifies what is supported.  In fact I have to assume
> PCI-E 1.0 since it doesn't specify (not that it's an issue, 8 lane 1x
> vs 4 lane 2x is more or less the same thing; though 4x is more future
> proof since there is likely to be a slot that big on future
> motherboards at /least/ for physics GPU support).

It doesn't matter what card you choose, either x4 or x8, PCIe 1.0, 2.0, or 3.0.
 They all have plenty of b/w, all support 48bit LBA, and someone, somewhere,
makes a motherboard with all the slots of the size/type mix you need to fit the
specific PCIe 'width' cads you buy.  "Desktop" style boards are probably more
likely not to have PCIe x8 slots, but to have mostly x1 slots and maybe a single
x4 slots.  Server boards are more likely to have multiple x8 and x4 slots.
However, many desktop boards have multiple x16 slots into which you can install
and x8 or an x4 unless you really _need_ two, three, or 4 GPU cards.

> Are you suggesting the LSI based Intel card because you know it to
> properly support >32 bit LBA?

I know it supports 48 bit LBA in SATA mode and 64 bit LBA in SAS mode.  However,
so does the SuperMicro Marvell based HBA.  I recommend the Intel/LSI HBA simply
because it's a higher quality SAS chip, it'll give better performance, and you
won't have any potential driver headaches with it as you may with the Marvell
based card.

If your time is worth $25/hour, two hours wasted fighting an issue with the
Marvell chip/driver combo bought you the Intel/LSI HBA in the first place.  If
your time is worth nothing and you enjoy pulling hair out, go with the $50
cheaper Marvell based solution.  And, once again, if you're going to spend $1000
on drives, what an extra $50 for a good HBA for them?

It seems from reading your posts that this is a "dream" system you've been
_thinking_ about building for a few years now, and isn't something you're
actually going to build.  Even if this is simply an exercise in mental
masturbation, I'm glad to have spent the time on this thread if merely to
educate you about ATA, SATA, SAS, specifically WRT LBA, and the difference
between quality HBAs/storage chip and low quality HBAs/storage chips.

-- 
Stan
