From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 26 Sep 2011 08:08:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109260807520.13829@uplift.swm.pp.se>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109222249.12892.tfjellstrom@shaw.ca> <20110923105834.71fc7c78@natsu> <201109222310.28684.tfjellstrom@shaw.ca> <4E7C81E0.1040707@hardwarefreak.com> <4E7F6DCC.10605@tigertech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F6DCC.10605@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 25 Sep 2011, Robert L Mathews wrote:

>> Solve your problem with a 50% more $$ LSI SAS1068E based Intel 8 port PCIe 
>> x4 SAS/SATA HBA, which uses the mptsas driver:
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157
>
> When this card is used in JBOD mode, is the on-disk format identical to a 
> standard disk that's not plugged into a RAID card?

Yes.

> In other words, if the card fails, is it possible to take the disks and 
> connect them directly to any non-RAID SATA/SAS motherboard? Or would you need 
> a replacement card to read the data?

Yes.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
