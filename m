From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 23:26:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40358C68.80205@pobox.com>
References: <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu> <200402191958.i1JJwP225623@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200402191958.i1JJwP225623@bzs.org>
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael wrote:
> Bear in mind that what you are calling "true hardware raid" is really 
> a microprocessor programmed to do the raid algorithims. Usually these 
> microprocessors are stretched to the limit to handle the throughput 
> of modern udam drives. I don't know but I suspect that the small 
> overhead use in the mmu for software raid has far more and faster 
> throughput than any of these dedicated microprocessors..... and, you 
> can see the code and know it is bug free or will be if you report the 

Nod...  many hardware RAIDs are turning out this way.  A certain vendor 
whose name does -not- start with 'A' manages to make their hardware RAID 
perform so poorly, it is _half_ the speed of a software RAID using the 
same drives, on a single non-RAID Adaptec SCSI controller.

Most hardware RAID isn't 100% ASIC, but rather a general ASIC and 
firmware with the RAID code in it.

OTOH, hardware RAID really wins for situations like RAID-1, where you 
can -halve- the amount of data going across the PCI bus versus software 
RAID.

	Jeff



