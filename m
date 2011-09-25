From: Robert L Mathews <lists@tigertech.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 11:07:08 -0700
Message-ID: <4E7F6DCC.10605@tigertech.com>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109222249.12892.tfjellstrom@shaw.ca> <20110923105834.71fc7c78@natsu> <201109222310.28684.tfjellstrom@shaw.ca> <4E7C81E0.1040707@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7C81E0.1040707@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner wrote:

> Solve your problem with a 50% more $$ LSI SAS1068E based Intel 8 port 
> PCIe x4 SAS/SATA HBA, which uses the mptsas driver:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157

When this card is used in JBOD mode, is the on-disk format identical to 
a standard disk that's not plugged into a RAID card?

In other words, if the card fails, is it possible to take the disks and 
connect them directly to any non-RAID SATA/SAS motherboard? Or would you 
need a replacement card to read the data?

(There should be a special term for proprietary JBOD formats to prevent 
people from being burned by this... something like "JBOPD".)

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
