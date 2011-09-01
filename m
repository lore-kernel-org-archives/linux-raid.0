From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 1 Sep 2011 18:33:34 +0200
Message-ID: <20110901163334.GA13347@apartia.fr>
References: <20110901154759.GA32649@apartia.fr>
 <20110901155913.GA20825@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110901155913.GA20825@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 01, 2011 at 04:59:13PM +0100, Robin Hill wrote:
> On Thu Sep 01, 2011 at 05:47:59PM +0200, Louis-David Mitterrand wrote:
> > 
> > I'm trying to create a raid6 array from 10x3T disks. Since disks > 2T
> > must use the GPT partion table I used parted to created a single
> > partition on each drive with the correct GPT partion type.
> > 
> > Now how do I make sure that these partitions have the correct "raid
> > autodetect" (fd) id? Is it even still needed? I didn't find any way to
> > set that flag in (g)parted.
> > 
> It's only needed for kernel auto-assembly (in which case you're also
> limited to 0.90 metadata and 2TB drives), so no, there's no need to use
> that. 0xDA seems to be the recommended partition type for RAID arrays
> nowadays - that should prevent the OS from trying to read them directly.

Auto-assembly and metadata are not related: I regularly use 1.2 metadata
on non-boot partitions and they auto-assemble fine.

However lilo won't boot on anything other than 0.9, this I found the
hard way :)

Kernel auto-assembly seems quite useful and desirable to me, especially
when using, say, initrd to unlock dm-crypt partitions (no need to
configure madadm.conf in the initrd).

BTW, what is that 0xDA type?

Cheers,
