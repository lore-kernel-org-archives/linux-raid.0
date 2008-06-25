From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] sysfs superblock read oops
Date: Thu, 26 Jun 2008 09:45:16 +1000
Message-ID: <18530.55436.577183.364504@notabene.brown>
References: <20080624233533.GH9948@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Wednesday June 25
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 25, chris@arachsys.com wrote:
> Whilst correcting my rdev resize patch to deal with non-persistent metadata,
> I noticed that reading from /sys/block/mdX/md/rdY/super when there isn't a
> real superblock causes an oops rather than just returning zero length. The
> tiny attached patch fixes this.

You must be using a slightly old kernel.  The 'super' sysfs file was removed
on 19th March 2008 and is gone since 2.6.25-rc7.

commit 0e82989d95cc46cc58622381eafa54f7428ee679

Thanks,
NeilBrown

