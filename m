From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/5] block: a virtual block device driver for testing
Date: Mon, 7 Aug 2017 10:29:05 +0200
Message-ID: <42bfcce1-8329-c0df-7457-107b388491ff@suse.de>
References: <cover.1501945859.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1501945859.git.shli@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 08/05/2017 05:51 PM, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> In testing software RAID, I usually found it's hard to cover specific cases.
> RAID is supposed to work even disk is in semi good state, for example, some
> sectors are broken. Since we can't control the behavior of hardware, it's
> difficult to create test suites to do destructive tests. But we can control the
> behavior of software, software based disk is an obvious choice for such tests.
> While we already have several software based disks for testing (eg, null_blk,
> scsi_debug), none is for destructive testing, this is the reason we create a
> new test block device.
> 
> Currently the driver can create disk with following features:
> - Bandwidth control. A raid array consists of several disks. The disks could
>   run in different speed, for example, one disk is SSD and the other is HD.
>   Actually raid1 has a feature called write behind just for this. To test such
>   raid1 feature, we'd like the disks speed could be controlled.
> - Emulate disk cache. Software must flush disk cache to guarantee data is
>   safely stored in media after a power failure. To verify if software works
>   well, we can't simply use physical disk, because even software doesn't flush
>   cache, the hardware probably will flush the cache. With a software
>   implementation of disk cache, we can fully control how we flush disk cache in a
>   power failure.
> - Badblock. If only part of a disk is broken, software raid continues working.
>   To test if software raid works well, disks must include some broken parts or
>   bad blocks. Bad blocks can be easily implemented in software.
> 
> While this is inspired by software raid testing, the driver is very flexible
> for extension. We can easily add new features into the driver. The interface is
> configfs, which can be configured with a shell script. There is a 'features'
> attribute exposing all supported features. By checking this, we don't need to
> worry about compability issues. For configuration details, please check the
> first patch.
> 
Any particular reason why you can't fold these changes into brd or null_blk?
After all, without those testing features it is 'just' another ramdisk
driver...

> This is William's intern project. I made some changes, all errors are mine. You
> are more than welcomed to test and add new features!
> 
Ah. But then why isn't he mentioned in the From: or Signed-off: lines?
Shouldn't he be getting some more credits than just 'William'?
(Unless William is in fact an alias for Kyungchan Koh, in which case a
name mapping would be nice ...)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
