From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11 - with XFS
Date: Tue, 2 Dec 2003 10:06:00 +1100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <16331.51544.325544.106513@notabene.cse.unsw.edu.au>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com>
	<20031201141144.GD12211@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: message from Jens Axboe on Monday December 1
To: Jens Axboe <axboe@suse.de>
Cc: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>, LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>, Eric Jensen <ej@xmission.com>
List-Id: linux-raid.ids

On Monday December 1, axboe@suse.de wrote:
> On Mon, Dec 01 2003, Kevin P. Fleming wrote:
> > I've got a new system here with six SATA disks set up in a RAID-5 array 
> > (no partition tables, using the whole disks). I then used LVM2 tools to 
> > make the RAID array a physical volume, created a logical volume and 
> > formatted that volume with an XFS filesystem.
> > 
> > Mounting the filesystem and copying over the 2.6 kernel source tree 
> > produces this OOPS (and is pretty reproducable):
> > 
> > kernel BUG at fs/bio.c:177!
> 
> It's doing a put on an already freed bio, that's really bad.
> 

That makes 2 bug reports that seem to suggest that raid5 is calling
bi_end_io twice on the one bio. 

The other one was from Eric Jensen <ej@xmission.com>
with Subject: PROBLEM: 2.6.0-test10 BUG/panic in mpage_end_io_read
on  26 Nov 2003 

Both involve xfs and raid5.
I, of course, am tempted to blame xfs.....

In this case, I don't think that raid5 calling bi_end_io twice would
cause the problem as the bi_end_io that raid5 calls is  clone_end_io,
and that has an atomic_t to make sure it only calls it's bi_end_io
(bio_end_io_pagebuf) once, even if it were called multiple times itself.

So I'm wondering if xfs might be doing something funny after
submitting the request to raid5... though I don't find that convincing
either.

In this reports, the IO seems to have been request from the
pagebuf stuff (fs/xfs/pagebuf/page_buf.c).  In the other one it
is coming from mpage, presumably from inside xfs/linux/xfs_aops.c
These are very different code paths and are unlikely to share a bug
like this.

Which does tend to point the finger back at raid5. :-(

I'd love to see some more reports of similar bugs, in the hope that
they might shed some more light.

NeilBrown
