From: Neil Brown <neilb@suse.de>
Subject: Re: Thoughts on using SSD
Date: Fri, 27 Mar 2009 15:31:37 +1100
Message-ID: <18892.22185.768994.295766@notabene.brown>
References: <49CC0B0D.5000904@tmr.com>
	<72dbd3150903261751r911114ak16b2f9cd0d1da191@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Rees on Thursday March 26
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday March 26, drees76@gmail.com wrote:
> On Thu, Mar 26, 2009 at 4:09 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> > If I were to create a small raid device, raid1, made of the 4GB Ssd and 4GB
> > of SATA space, if I made the SATA write-mostly and write-behind, and put the
> > journal for my raid arrays (and bitmaps?) that seems likely to provide a
> > significant performance gain in small storage.
> >
> > Am I missing anything here? Is there an obvious drawback I'm missing?
> 
> Yeah, the fact that it doesn't seem to be possible to take advantage
> of the write-behind feature? :-p
> 
> Besides fsync, I think it may have something to do with barriers.  As
> in, when you flush a barrier, that causes entire cache to get flushed
> to disk, including your write-behind disk.

Nope.  The barriers are sent separately to both devices.  Yes, they
both get flushed, but we don't wait for the write-behind flush to
complete.

NeilBrown


> 
> Hopefully Neil can chime in here.  I found this thread from a while
> back which seemed relevant, but I haven't been able to digest the
> whole thing yet: http://lkml.org/lkml/2007/5/25/71
> 
> -Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
