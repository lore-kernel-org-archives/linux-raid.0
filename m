From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 14:34:49 -0600
Message-ID: <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029021643.1c9e3195@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 2:16 PM, Roman Mamedov <rm@romanrm.ru> wrote:

> On Sun, 28 Oct 2012 14:10:00 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>>>> not for RAID 5
>>> 
>>>> RAID 5 implies 24x7 
>>> 
>>>> they're also not a 24x7 drive
>>> 
>>> Wrong on pretty much all points. Or perhaps you are just way too easily
>>> misguided by marketing b/s.
>> 
>> I read their own published specs. Doesn't matter whether that piece is used predominantly by marketing or not, it is a defacto contract that cannot substantially depart from the legalized warranty verbiage.
> 
> I could not find any specs from WD where it would say that this particular
> drive should be powered on for no more than X hours a day, and not 24x7.

http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771442.pdf

Oh no you're right, it's by inference. Green is a desktop drive. It's neither designed for nor marketed for RAID applications other than consumer RAID (which they consider 1 and 0.) And the Green spec sheet does say that.

http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-701229.pdf


> The closest thing I could find is [1], which after cutting out all the
> "we really really want to sell you this enterprise drive for 1.5x as much"

It's typical to do an upsell in all markets. Usually the upsell is a better product too, even if the markup is also a bit higher. It's not like you generally get products that are marked up for no reason at all. Eventually people figure this out, that you're a big fat liar, and then won't buy anything from you, even your cheapest product. (Unless of course you have some weirdly misguided blood loyalty thing going on.)

And on that note, I think WDC has done themselves a disservice by not doing a better job differentiating their products, that they decided to yank configurable SCT ERC in consumer drives, and therein created, very conveniently, space for a new drive, red, that previously didn't exist. Clever and annoying. But they are being rewarded so far. Red sales appear to be through the roof.


> boils down to describing the problem that dumb "hardware RAID" controllers
> have with drives without TLER, an issue irrelevant to mdadm users. So,
> anything else?

That's not true. A drive that can sit there like a bump on the log for 2 minutes before it issues an actual read failure on sector(s) means mdadm is likewise waiting, and everything above it is waiting. That's a long hang. I'd not be surprised to see users go for hard reset with such a system hang after 45 seconds let alone 2 minutes.

Ideally what you'd get is a quick first error recovery with a clean normally operating array. As soon as the first drive fails, the system would set the remaining drives to a slightly longer error recovery time so that you don't get nearly as quick error recovery on the remaining drives - ask them to try a little harder before they error out. If you get another read error, there is no mirror or parity to rebuild from. Best to try a little longer in such a degraded state.

Anyway, the idea mdadm users can't benefit from shorter ERC is untrue. They certainly can. But the open question is why would they be getting such long error recovery times in the first place? 7 seconds is a long time. 2 minutes is a WTF moment. Has the user been doing scrubs and smart tests at all?


Chris Murphy

