From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md: add bad block flag to disk state
Date: Wed, 1 Feb 2017 10:12:15 -0800
Message-ID: <20170201181215.4d5nfyxmpsmgenks@kernel.org>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
 <1485259419-2308-2-git-send-email-tomasz.majchrzak@intel.com>
 <20170130233341.l5eiars5lbgowrht@kernel.org>
 <20170201095352.GA24920@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201095352.GA24920@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Wed, Feb 01, 2017 at 10:53:52AM +0100, Tomasz Majchrzak wrote:
> On Mon, Jan 30, 2017 at 03:33:41PM -0800, Shaohua Li wrote:
> > On Tue, Jan 24, 2017 at 01:03:38PM +0100, Tomasz Majchrzak wrote:
> > > Add a new flag to report that bad blocks are present on a disk. It will
> > > allow userspace to notify the user of the problem.
> > > 
> > > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > > ---
> > >  drivers/md/md.c                | 2 ++
> > >  include/uapi/linux/raid/md_p.h | 1 +
> > >  2 files changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 0abb147..1a807ec 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -6034,6 +6034,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
> > >  			info.state |= (1<<MD_DISK_WRITEMOSTLY);
> > >  		if (test_bit(FailFast, &rdev->flags))
> > >  			info.state |= (1<<MD_DISK_FAILFAST);
> > > +		if (rdev->badblocks.count)
> > > +			info.state |= (1<<MD_DISK_BB_PRESENT);
> > 
> > Userspace can find if a disk has badblocks by reading the bad_blocks sysfs
> > file. Why adds another interface?
> > 
> > Thanks,
> > Shaohua
> 
> Yes, indeed, it can. I have chosen to do it this way to keep it consistent
> with mdadm which uses GET_DISK_INFO ioctl to get disk information. All data
> provided in this ioctl is also available in sysfs file (rdev state), however
> ioctl is still used (legacy). The same applies for details subcommand of
> mdadm. To answer your question - yes, I could avoid new flag but it would
> make mdadm side of my improvement much more complicated.

I intended to avoid adding new user interface if possible. Not sure about this
case though. How complicated in the mdadm side if we use the bad_block sysfs
file?

Jes, how do you think from the mdadm side?

Thanks,
Shaohua
