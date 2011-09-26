From: Krzysztof Adamski <k@adamski.org>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 22:26:32 -0400
Message-ID: <1317003992.4039.249.camel@oxygen.netxsys.com>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	 <201109222249.12892.tfjellstrom@shaw.ca> <20110923105834.71fc7c78@natsu>
	 <201109222310.28684.tfjellstrom@shaw.ca>
	 <4E7C81E0.1040707@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7C81E0.1040707@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2011-09-23 at 07:56 -0500, Stan Hoeppner wrote:
> On 9/23/2011 12:10 AM, Thomas Fjellstrom wrote:
> 
> > I /really really/ wish the driver for this card was more stable, but you deal
> > with what you've got (in my case a $100 2 port SAS/8 port SATA card).
> 
> Please don't shield the identity of the problem card.  Others need to 
> know of your problems.  An educated guess tells me it is one of...
> 
> Card:    SuperMicro AOC-SASLP-MV8            Marvell 88SE6480
> Driver:  MVSAS
> 
> Card:    HighPoint RocketRAID 2680/2680SGL   Marvell 88SE6485
> Driver:  MVSAS
> 
> This ASIC/driver combo is so historically horrible with Linux that I'm 
> surprised all the owners haven't had a big bon fire party and thrown all 
> the cards in.  Or simply Ebay'd them to Windows users, where they seem 
> to work relatively OK.
> 
> Solve your problem with a 50% more $$ LSI SAS1068E based Intel 8 port 
> PCIe x4 SAS/SATA HBA, which uses the mptsas driver:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157
> 
> It seems this is the card most users switch to after being burned by the 
> cheap Marvell based SAS 2xSFF8087 cards.  The 1068E cards and the mptsas 
> driver are far more reliable, stable, and faster.  Many OEM cards from 
> IBM, Dell, etc, use this chip and can be had on Ebay for less than the 
> new retail Intel card.  In your situation I'd probably buy new Intel 
> just in case.  Hope this info/insight helps.
> 

Keep in mind that the 1068E based cards do NOT support 3T drives fully.

K

