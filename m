From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: RAID6 issues
Date: Wed, 28 Sep 2011 00:52:10 -0600
Message-ID: <201109280052.10938.thomas@fjellstrom.ca>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com> <201109271504.02642.thomas@fjellstrom.ca> <4E828AAF.3030909@hardwarefreak.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E828AAF.3030909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andriano <chief000@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 27, 2011, Stan Hoeppner wrote:
> On 9/27/2011 4:04 PM, Thomas Fjellstrom wrote:
> >> Stan Hoeppner<stan@hardwarefreak.com>  wrote:
> >> 
> >> The 9210-8i is a newer generation card using the SAS2008 chip.  IOPS
> >> potential is over double that of the 1068E cards, 320M vs 140M, and
> >> you'll have support for drives larger than 2TB.  It also supports SATA3
> >> link speed whereas the 1068E chips only support SATA2.  It has a PCIe x8
> >> 2.0 interface for 8GB/s b/w, whereas the 1068E has a PCIe x8 1.0
> >> interface for only 4GB/s.
> >> 
> >> In short, it's has quite a bit more capability than the 1068E based
> >> cards.
> > 
> > Yeah, i was impressed by the claimed specs. I bet if i knew how much it
> > sells for, i'd be shocked. I did a little searching but didn't have much
> > luck.
> 
> That's because the 9210* is...
> "*Only available to OEMs through LSI direct sales."
> IBM sells the 9210-8i as the ServeRAID M1015, available at Newegg for
> $320 (way over priced as with all things Big Blue).  IBM adds optional
> RAID5/50 fakeraid to the BIOS with an additional license key payment.
> The retail version of the 9210-8i is the LSI 9240-8i, available at
> Newegg for $265.
> 
> However, the specs on the 9211-8i are the same, and the connector layout
> is better--front vs top.  I recommend it over of the 9240-8i.  And it's
> a little cheaper to boot, $240 vs $265, at Newegg:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816118112
> 
> 9211-8i full specs:
> http://www.lsi.com/products/storagecomponents/Pages/LSISAS9211-8i.aspx
>
> Unless you need to use drives larger than 2TB the $155 Intel 1068E card
> is a far better buy at almost $100 less.  If you need to connect more
> than 8 drives, get a 9211-4i and one of these Intel expanders for 20
> drive ports:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117207
> 
> This combo with run you ~$450, or $22.50/port for 20 ports.  The 9211-8i
> runs $30/port for 8 ports.

Very interesting and useful information :) I'm actually trading my time for 
the card, a very nice fellow on the local lug list offered after (I assume) he 
saw my earlier thread here.

I've been thinking about getting an expander. Won't happen for a bit/while.

> > p.s. Sory for the duplicate Stan, I couldn't figure out how to disable
> > html on my android mail client, and linux-raid bounced it.
> 
> No need to apologize.  Sh*t happens.

Thanks for the information so far, its been quite helpful.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
