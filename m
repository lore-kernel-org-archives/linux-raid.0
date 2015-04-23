From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bisected, with rfc/patch - was Re: BUG: unable to handle
	kernel NULL pointer dereference at sysfs_do_create_link_sd (after
	mdadm)
Date: Thu, 23 Apr 2015 09:37:24 +0200
Message-ID: <20150423073724.GA8139@lst.de>
References: <20150414171537.GH25394@azat> <20150423160551.45345f96@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150423160551.45345f96@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
List-Id: linux-raid.ids

Plase fix your device name lifetimes.

See the DM commit

    63a4f0 ("dm: fix add_disk() NULL pointer due to race with free_dev()")

for a template.

Unregistering the device too early means we'll have half constructed
bdis hanging around, which caused all kinds of problems for filesystems
and the writeback code.
