From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: upgrading LSI SAS9211-8i fw IR->IT
Date: Wed, 25 Oct 2017 00:04:37 +1100
Message-ID: <fd16035d-adaa-ddc5-1726-7b3873871853@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <20171024171457.563fbb2a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171024171457.563fbb2a@natsu>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/10/17 23:14, Roman Mamedov wrote:
> On Tue, 24 Oct 2017 22:47:48 +1100
> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
> 
>> I now want to upgrade the fw from IR to IT.
> 
> Is there any practical reason for doing that?

I want to avoid the risk of the IR fw writing any metadata to the disks which already
hold a software RAID.

Is it not the case that the IR fw may mess with the disks (I read a comment suggesting it might)?

Regardless, I want to update to fw 20 - the card is on 18 now.

> I have a SAS9212-4i with a very ancient IR firmware -- and the thing is, it
> just works perfectly as a dumb SATA controller, including full SMART access to
> connected disks -- what else is there to ask from it?

This is a fair comment which I will consider. ATM I avoid booting this card with the
disks connected.

> (no TRIM pass-through, but that's kind of "by design" with these cards, and I
> doubt it's fixed in the new firmware)

Not an issue for me.

> If I'm not mistaken it's IT that is the simpler firmware for when you don't
> need the hardware RAID, but considering the above, and how cumbersome and risky
> the flashing process is, what am I losing by staying with IR?

Yes, I expect the IT fw is simpler, and I hope more stable too as it mostly stays
out of the way.

> Anyways here's one more HOWTO on flashing that may or may not be more helpful
> than the ones you listed:
> https://wiki.hackspherelabs.com/index.php?title=LSI_Raid_Firmware_Bios_Flashing

Thanks for the link.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
