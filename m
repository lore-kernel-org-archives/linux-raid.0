From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 09:01:51 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BA23F.7000506@wasp.net.au>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>	 <406B9F3E.4020701@wasp.net.au> <1080795066.16499.15.camel@binkley>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1080795066.16499.15.camel@binkley>
To: seth vidal <skvidal@phy.duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

seth vidal wrote:
>>One point. Hardware raid (and faux hardware raid) provides real hot swap with on-the-fly rebuilds.
>>Linux software raid can't (yet).
> 
> 
> umm. That's surprising. My software raid arrays running on dell
> powervault 221s scsi boxes with adaptec 39160 controllers are
> hotswappable and when I put in a new disk and add it to the array it
> resyncs on the fly.
> 
> Are you just talking about ide-based raid?

Yes. ATA and SATA raid (Which is the majority of low budget linux software raid stuff)
I realise scsi is hotswap. It comes with the turf.

I would find it pretty hard to justify the expense of scsi for my 7 drive 1.4TB low speed array (Low 
speed because I never *need* more than about 2MB/s in any direction but I need heaps of space)

Brad
