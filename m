From: Jan Kara <jack@suse.cz>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Thu, 8 Mar 2012 11:54:41 +0100
Message-ID: <20120308105441.GB6681@quack.suse.cz>
References: <4F54B997.3060207@crc.id.au>
 <4F54D314.9060504@anonymous.org.uk>
 <4F550BA8.3010306@crc.id.au>
 <20120306070143.4f8abc0e@notabene.brown>
 <4F556FA1.5020006@crc.id.au>
 <20120306132701.1b9600f4@notabene.brown>
 <4F55A0D7.4040908@zytor.com>
 <20120308110421.45d337b9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120308110421.45d337b9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Haigh <netwiz@crc.id.au>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-raid.ids

On Thu 08-03-12 11:04:21, NeilBrown wrote:
> On Mon, 05 Mar 2012 21:29:59 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 03/05/2012 06:27 PM, NeilBrown wrote:
> > > 
> > > So it is still called fsync_bdev and invalidate_bdev as long as the
> > > ioctl function for the underlying disk returns -EINVAL or -ENOTTY.
> > > 
> > > The function that shows that warning is scsi_verify_blk_ioctl in 
> > > block/scsi_ioctl.c The worst it can do is return -ENOTTY, and that
> > > is safe.
> > > 
> > > So the warning is bogus, the code still works.
> > > 
> > 
> > We should whitelist ioctls if they are legitimately used and harmless.
> >  Do we have a specific list?
> > 
> > 	-hpa
> > 
> > 
> 
> We had the following in our SLES kernel for a while, though it seems it
> disappeared when we pulled in 3.0.18.
> Jan: should we put this stuff back?
  Yeah, we should. I think it was removed by accident - partly because the
patch doing the change was tagged as in mainline but it actually differed
from mainline slightly.

								Honza

> @@ -78,11 +83,19 @@ Index: linux-3.0-SLE11-SP2/block/scsi_ioctl.c
>  +      case SG_GET_RESERVED_SIZE:
>  +      case SG_SET_RESERVED_SIZE:
>  +      case SG_EMULATED_HOST:
> ++      case BLKFLSBUF:
> ++      case BLKROSET:
>  +              return 0;
>  +      case CDROM_GET_CAPABILITY:
> -+              /* Keep this until we remove the printk below.  udev sends it
> -+               * and we do not want to spam dmesg about it.   CD-ROMs do
> -+               * not have partitions, so we get here only for disks.
> ++      case CDROM_DRIVE_STATUS:
> ++      case FDGETPRM:
> ++      case RAID_VERSION:
> ++      case MTIOCGET:
> ++#ifdef CONFIG_COMPAT
> ++      case 0x801c6d02:        /* MTIOCGET32 */
> ++#endif
> ++              /* Keep this until we remove the printk below. udev/dd sends
> ++               * these and we do not want to spam dmesg about it. CD-ROMs
> ++               * & tapes do not have partitions, so we get here only for
> ++               * disks.
>  +               */
>  +              return -ENOTTY;
>  +      default:
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
