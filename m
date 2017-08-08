From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 0/5] block: a virtual block device driver for testing
Date: Tue, 8 Aug 2017 14:05:07 -0700
Message-ID: <20170808210507.setdwunzrad4t7xp@kernel.org>
References: <cover.1501945859.git.shli@fb.com>
 <42bfcce1-8329-c0df-7457-107b388491ff@suse.de>
 <20170807163607.msflun2r4q5tlpsk@kernel.org>
 <f6896ce5-1752-feba-fadb-dbc89dbf4e20@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f6896ce5-1752-feba-fadb-dbc89dbf4e20@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Tue, Aug 08, 2017 at 02:31:54PM -0600, Jens Axboe wrote:
> On 08/07/2017 10:36 AM, Shaohua Li wrote:
> > On Mon, Aug 07, 2017 at 10:29:05AM +0200, Hannes Reinecke wrote:
> >> On 08/05/2017 05:51 PM, Shaohua Li wrote:
> >>> From: Shaohua Li <shli@fb.com>
> >>>
> >>> In testing software RAID, I usually found it's hard to cover specific cases.
> >>> RAID is supposed to work even disk is in semi good state, for example, some
> >>> sectors are broken. Since we can't control the behavior of hardware, it's
> >>> difficult to create test suites to do destructive tests. But we can control the
> >>> behavior of software, software based disk is an obvious choice for such tests.
> >>> While we already have several software based disks for testing (eg, null_blk,
> >>> scsi_debug), none is for destructive testing, this is the reason we create a
> >>> new test block device.
> >>>
> >>> Currently the driver can create disk with following features:
> >>> - Bandwidth control. A raid array consists of several disks. The disks could
> >>>   run in different speed, for example, one disk is SSD and the other is HD.
> >>>   Actually raid1 has a feature called write behind just for this. To test such
> >>>   raid1 feature, we'd like the disks speed could be controlled.
> >>> - Emulate disk cache. Software must flush disk cache to guarantee data is
> >>>   safely stored in media after a power failure. To verify if software works
> >>>   well, we can't simply use physical disk, because even software doesn't flush
> >>>   cache, the hardware probably will flush the cache. With a software
> >>>   implementation of disk cache, we can fully control how we flush disk cache in a
> >>>   power failure.
> >>> - Badblock. If only part of a disk is broken, software raid continues working.
> >>>   To test if software raid works well, disks must include some broken parts or
> >>>   bad blocks. Bad blocks can be easily implemented in software.
> >>>
> >>> While this is inspired by software raid testing, the driver is very flexible
> >>> for extension. We can easily add new features into the driver. The interface is
> >>> configfs, which can be configured with a shell script. There is a 'features'
> >>> attribute exposing all supported features. By checking this, we don't need to
> >>> worry about compability issues. For configuration details, please check the
> >>> first patch.
> >>>
> >> Any particular reason why you can't fold these changes into brd or null_blk?
> >> After all, without those testing features it is 'just' another ramdisk
> >> driver...
> > 
> > null_blk isn't a good fit. ramdisk might be, but I try to not. We are adding
> > new interfaces, locks and so on. Adding the features into ramdisk driver will
> > mess it up. Binding it to ramdisk driver will make adding new features harder
> > too, because the test driver doesn't really care about performance while
> > ramdisk does.
> 
> I'm curious why null_blk isn't a good fit? You'd just need to add RAM
> storage to it. That would just be a separate option that should be set,
> ram_backing=1 or something like that. That would make it less critical
> than using the RAM disk driver as well, since only people that want a "real"
> data backing would enable it.
> 
> It's not that I'm extremely opposed to adding a(nother) test block driver,
> but we at least need some sort of reasoning behind why, which isn't just
> "not a good fit".

Ah, I thought the 'null' of null_blk means we do nothing for the disks. Of
course we can rename it, which means this point less meaningful. I think the
main reason is the interface. We will configure the disks with different
parameters and do power on/off for each disks (which is the key we can emulate
disk cache and power loss). The module paramter interface of null_blk doesn't
work for the usage. Of course, these issues can be fixed, for example, we can
make null_blk use the configfs interface. If you really prefer a single driver
for all test purpose, I can move the test_blk functionalities to null_blk.

Thanks,
Shaohua
