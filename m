From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 008 of 14] Convert md to use kzalloc throughout
Date: Thu, 1 Dec 2005 14:42:52 -0800
Message-ID: <20051201144252.768ea121.akpm@osdl.org>
References: <20051201141508.29384.patches@notabene>
	<1051201032328.29641@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051201032328.29641@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> -	conf = kmalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
>  +	conf = kzalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
>  -	new = (mddev_t *) kmalloc(sizeof(*new), GFP_KERNEL);
>  +	new = (mddev_t *) kzalloc(sizeof(*new), GFP_KERNEL);
>  -	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
>  +	rdev = (mdk_rdev_t *) kzalloc(sizeof(*rdev), GFP_KERNEL);

It'd be nice to nuke the unneeded cast while we're there.

<edits the diff>

OK, I did that.
