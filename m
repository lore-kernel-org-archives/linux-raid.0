From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Mon, 05 Mar 2012 21:29:59 -0800
Message-ID: <4F55A0D7.4040908@zytor.com>
References: <4F54B997.3060207@crc.id.au> <4F54D314.9060504@anonymous.org.uk> <4F550BA8.3010306@crc.id.au> <20120306070143.4f8abc0e@notabene.brown> <4F556FA1.5020006@crc.id.au> <20120306132701.1b9600f4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120306132701.1b9600f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Steven Haigh <netwiz@crc.id.au>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/05/2012 06:27 PM, NeilBrown wrote:
> 
> So it is still called fsync_bdev and invalidate_bdev as long as the
> ioctl function for the underlying disk returns -EINVAL or -ENOTTY.
> 
> The function that shows that warning is scsi_verify_blk_ioctl in 
> block/scsi_ioctl.c The worst it can do is return -ENOTTY, and that
> is safe.
> 
> So the warning is bogus, the code still works.
> 

We should whitelist ioctls if they are legitimately used and harmless.
 Do we have a specific list?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

