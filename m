From: Jens Axboe <axboe@suse.de>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Tue, 2 Dec 2003 09:27:13 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031202082713.GN12211@suse.de>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de> <3FCB4CFA.4020302@backtobasicsmgmt.com> <20031201155143.GF12211@suse.de> <3FCC0EE0.9010207@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FCC0EE0.9010207@backtobasicsmgmt.com>
To: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>, linux-lvm@sistina.com
List-Id: linux-raid.ids

On Mon, Dec 01 2003, Kevin P. Fleming wrote:
> Jens Axboe wrote:
> 
> >Alright, so no bouncing should be happening. Could you boot with
> >mem=800m (and reproduce) just to rule it out completely?
> 
> Tested with mem=800m, problem still occurs. Additional test was done 

Suspected as much, just wanted to make sure.

> without device-mapper in place, though, and I could not reproduce the 
> problem! I copied > 500MB of stuff to the XFS filesystem created using 
> the entire /dev/md/0 device without a single unusual message. I then 
> unmounted the filesystem and used pvcreate/vgcreate/lvcreate to make a 
> 3G volume on the array, made an XFS filesystem on it, mounted it, and 
> tried copying data over. The oops message came back.

Smells like a bio stacking problem in raid/dm then. I'll take a quick
look and see if anything obvious pops up, otherwise the maintainers of
those areas should take a closer look.

> I'm copying this message to linux-lvm; the original oops message is 
> repeated below for the benefit of those list readers. I've got one more 
> round of testing to do (after the array resyncs itself), which is to try 
> a filesystem other than XFS.

That might be a good idea, although it's not very likely to be an XFS
problem as it happens further down the io stack. It should trigger just
as happily on IDE or SCSI if that was the case.

-- 
Jens Axboe

