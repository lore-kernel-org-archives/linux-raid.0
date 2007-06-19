From: Mike <mikee@mikee.ath.cx>
Subject: Re: suggestions for inexpensive linux jbod?
Date: Tue, 19 Jun 2007 02:26:22 +0000 (UTC)
Message-ID: <f57ese$lsi$1@sea.gmane.org>
References: <f566d2$84u$1@sea.gmane.org> <Pine.LNX.4.64.0706181255540.31683@p34.internal.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In article <Pine.LNX.4.64.0706181255540.31683@p34.internal.lan>, Justin Piszcz wrote:
> 
> 
> On Mon, 18 Jun 2007, Mike wrote:
> 
>> I'm creating a larger backup server that uses bacula (this
>> software works well). The way I'm going about this I need
>> lots of space in the filesystem where temporary files are
>> stored. I have been looking at the Norco (link at the bottom),
>> but there seem to be some grumblings that the adapter card
>> does not play well with linux.
>>
>> Has anyone used this device or have another suggestion? I'm
>> looking at something that will present lots of disk to the
>> linux box (fedore core 5, kernel 2.6.20) that I will put
>> under md/RAID and LVM. I want to have between 1.5TB and 3.0TB
>> of usable space after all the RAID'ing.
>>
>> Mike
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133001
> 
> Get 3 Hitachi 1TB drives and use SW RAID5 on an Intel 965 motherboard OR 
> use PCI-e cards that use the Silicon Image chipset.
> 
> 04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid 
> II Controller (rev 01)
> 
> Justin.

Any idea if the Hitachi 1 TB drives will work in a Dell PowerEdge 800? I
have two 80GB drives in the box right now that I would like to replace
with four of the 1 TB drives.

Mike

