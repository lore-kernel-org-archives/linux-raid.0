From: Dave Chinner <david@fromorbit.com>
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
Date: Wed, 25 Jun 2008 08:57:24 +1000
Message-ID: <20080624225724.GN29319@disturbed>
References: <48605A8E.9070903@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <xfs-bounce@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <48605A8E.9070903@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Mon, Jun 23, 2008 at 09:23:10PM -0500, Eric Sandeen wrote:
> So md raid1 is happy to pass down any barrier writes that it sees, but
> this bit in xfs_mountfs_check_barriers() at mount time:
> 
>         if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
>                                         QUEUE_ORDERED_NONE) {
>                 xfs_fs_cmn_err(CE_NOTE, mp,
>                   "Disabling barriers, not supported by the underlying
> device");
>                 mp->m_flags &= ~XFS_MOUNT_BARRIER;
>                 return;
>         }
> 
> winds up with XFS disabling barriers on these devices.  However, if this
> is simply commented out, XFS happily tests barriers, finds that they
> work, leaves them turned on and all subsequent barrier writes to the
> device succeed.
> 
> Perhaps what we have here is a failure to communicate?  :)

What we have is MD doing something strange and non-standard to
implement barriers on RAID1. All other devices that support barriers
define the barrier implementation as something other than
QUEUE_ORDERED_NONE.

> I'm not sure; *should* XFS be looking for a QUEUE_ORDERED tag?

It was put there for some reason - now lost in the mists of time, I
think. I suspect it was for detecting volume managers that didn't
support barriers properly and weren't returning the correct
errors to barrier I/O....

> Should MD be setting one?

If it supports barriers, then it probably should be.

> Maybe there should be a QUEUE_ORDERED_PASSTHRU flag?
> Or should XFS just stick with the test write and ignore the flag?  I'm
> not sure of the queue->ordered flag details, but it seems that XFS & md
> raid1 both try hard to keep barriers in force, and there's a disconnect
> here somewhere.

Yeah, the problem was that last time this check was removed was
that a bunch of existing hardware had barriers enabled on them when
not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
devices. Having to change the root drive config on a wide install
base was considered much more of support pain than leaving the
check there. I guess that was more of a distro upgrade issue than
a mainline problem, but that's the history. Hence I think we
should probably do whatever everyone else is doing here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
