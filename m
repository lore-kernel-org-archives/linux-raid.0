From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: Question for Neil/Superblocks
Date: Fri, 27 Nov 2009 23:22:22 +0100
Message-ID: <1259360542.31633.188.camel@localhost>
References: <alpine.DEB.2.00.0911271624450.30813@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911271624450.30813@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2009-11-27 at 16:27 -0500, Justin Piszcz wrote:
> Hi Neil,
> 
> A couple of things, recently I tried to make a new system (MDADM/latest/SW 
> RAID1) and noticed that GRUB & LILO still only support 0.90 superblocks. 
> This leads me to my next question.
> 
> Will the newer superblocks be supported? I ask this due to my final 
> question.
> 
> With 0.90 superblocks, I have never seen any array (raid1,raid5,raid6) try 
> to correct a read-error, but when I made an array with 1.2 superblocks 
> (not the boot volume of course) using VelociRaptors, great for testing 
> crap disks that don't work in read, I did see it try to correct read 
> errors!  I was wondering if that is only applicable to superblocks >= 
> 1.x+?
> 
> I know you can build yourself an initrd/miniroot so/on/so forth but its 
> nice when you can just build a kernel, run lilo and have it auto-detect 
> the raid1 volumes and boot accordingly (as you can with 0.90 superblocks).
have a separate boot partition raid1....


> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

