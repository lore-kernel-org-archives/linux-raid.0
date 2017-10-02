From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Mon, 2 Oct 2017 19:29:34 +1100
Message-ID: <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/09/17 18:34, Eyal Lebedinsky wrote:
> I read through the list and it seems to be the more common suggestion.
> 
> It is old now (I see it mentioned a few years ago), and downloading the tools to
> flash it to IT mode recently became difficult (is there an official site?).
> Yet it is relatively cheap.
> 
> So, is there another candidate for 8 way HBA for use with linux software raid?
> 
> TIA

I got replies that suggest LSI (or equiv) 9211-8i or 9300-8i as good cards.

The price difference is significant, so I wonder what I get for the extra
money, especially as I plan to use it as a plain HBA (so no hwr raid, is
this what the IT fw is?).

For example, is the 9211 (older model?) likely to not work with a new
mobo a year from now (I plan to upgrade)?
Broadcom removed the 9211 from their site, is the 9207-8i the current
replacement model?

I will not use SSDs with the card, so handling 8 HDDs should not be a
stretch for either one?

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
