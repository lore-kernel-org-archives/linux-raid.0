From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: Mon, 11 Nov 2002 11:47:08 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DD0093C.5080205@zytor.com>
References: <Pine.GSO.4.30.0211111138080.15590-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter L. Ashford wrote:
> 
>>I'm playing around with RAID-6 algorithms lately.  With RAID-6 I mean
>>a setup which needs N+2 disks for N disks worth of storage and can
>>handle any two disks failing -- this seems to be the contemporary
>>definition of RAID-6 (the originally proposed "two-dimensional parity"
>>which required N+2*sqrt(N) drives never took off for obvious reasons.)
> 
> This appears to be the same as RAID-2.  Is there a web page that gives a
> more complete description?
> 
http://www.acnc.com/04_01_06.html is a pretty good high-level 
description, although it incorrectly states this is two-dimensional 
parity, which it is *NOT* -- it's a Reed-Solomon syndrome.  The 
distinction is critical in keeping the overhead down to 2 disks instead 
of 2*sqrt(N) disk.

RAID-2 uses Hamming code, according to the same web page, which has the 
property that it will correct the data *even if you can't tell which 
disks have failed*, whereas RAID-3 and higher all rely on "erasure 
information", i.e. independent means to know which disks have failed. 
In practice this information is furnished by some kind of CRC or other 
integrity check provided by the disk controller, or by the disappearance 
of said controller.

	-hpa




