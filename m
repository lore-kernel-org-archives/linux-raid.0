From: Scott Long <scott_long@adaptec.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 21:40:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40358FB2.80609@adaptec.com>
References: <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu> <200402191958.i1JJwP225623@bzs.org> <40358C68.80205@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40358C68.80205@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: michael@insulin-pumpers.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Michael wrote:
>  > Bear in mind that what you are calling "true hardware raid" is really
>  > a microprocessor programmed to do the raid algorithims. Usually these
>  > microprocessors are stretched to the limit to handle the throughput
>  > of modern udam drives. I don't know but I suspect that the small
>  > overhead use in the mmu for software raid has far more and faster
>  > throughput than any of these dedicated microprocessors..... and, you
>  > can see the code and know it is bug free or will be if you report the
> 
> Nod...  many hardware RAIDs are turning out this way.  A certain vendor
> whose name does -not- start with 'A' manages to make their hardware RAID
> perform so poorly, it is _half_ the speed of a software RAID using the
> same drives, on a single non-RAID Adaptec SCSI controller.
> 

Whoever could that be????

> Most hardware RAID isn't 100% ASIC, but rather a general ASIC and
> firmware with the RAID code in it.
> 

Well, the 8030x (i960) chips are really tailored for RAID.  That's why
they have a PCI-PCI bridge, XOR accelerator, and DRAM controller built
into the package.

> OTOH, hardware RAID really wins for situations like RAID-1, where you
> can -halve- the amount of data going across the PCI bus versus software
> RAID.

If performance is how you measure the quality of RAID, then you can't
forget the benefit of a large write cache on the controller and the
intelligence in the raid stack to use it well.  However, the real
benefit to hardware-accelerated RAID is the ability to guarantee that
your reads and writes always succeed, regardless of the failure thrown
at it.  Of course, the number of cards out there that actually meet
this goal is quite small, even from companies whose names start with
'A'.

Scott


