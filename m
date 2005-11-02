From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH md 001 of 10] Make sure /block link in /sys/.../md/ goes to correct devices.
Date: Wed, 2 Nov 2005 13:46:11 -0800
Message-ID: <20051102214611.GE23247@kroah.com>
References: <20051102205640.22689.patches@notabene> <1051102101452.23840@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051102101452.23840@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2005 at 09:14:52PM +1100, NeilBrown wrote:
> 
> If a block_device is a partition, then it's kobject is
>   bdev->bd_part->kobj
> otherwise (if it is a full device), the kobject is 
>   bdev->bd_disk->kobj
> 
> As md wants back-links to the correct object (whether partition or
> not), we need to respect this difference...
> (Thus current code shows a link to the whole device, whether we are
> using a partition or not, which is wrong).
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

