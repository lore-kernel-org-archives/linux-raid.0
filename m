From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 07 Oct 2014 12:36:19 +0200
Message-ID: <20141007123619.Horde.tC2-gMUttC5BYOoaKogzlw9@webmail.gautschi.net>
References: <54336FC1.6080306@gautschi.net>
 <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
 <20141007095422.Horde.3l6BckPhfY5U8dchaOdLNA1@webmail.gautschi.net>
 <20141007092548.GC18786@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141007092548.GC18786@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What does the SMART info show for the drives - are there any reallocated
> blocks? A large number of those scattered over the disk would certainly
> cause seeking for both reads and writes.

I will check the SMART this evening but I don't think that this is causing
the seek. The sound is very constant and for the whole time of syncing  
the array.
I will also run a dd on the disk to compare.

> It's also worth checking whether there's anything else that would be
> accessing the disks in the background (monitoring/indexing/etc).

Unlikely because I have not yet created a filesystem after setting up  
the RAID4.

> I can't think of anything else that would be causing reads to seek - SMR
> disks or write-intent bitmaps would only affect writes.

Exactly

Is there any way or tool to monitor all disk read/write commands - not only
the count or amount but every access with LBA and length?

Patrick
