From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 12:59:39 +0000
Message-ID: <20080114125939.GP27894@ZenIV.linux.org.uk>
References: <20080114123726.19968.patches@notabene> <1080114014531.20354@suse.de> <20080114020459.GN27894@ZenIV.linux.org.uk> <18314.54601.196877.828373@notabene.brown> <20080114034322.GO27894@ZenIV.linux.org.uk> <18314.59832.14451.334084@notabene.brown> <18315.284.774998.348672@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18315.284.774998.348672@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 14, 2008 at 05:28:44PM +1100, Neil Brown wrote:
> On Monday January 14, neilb@suse.de wrote:
> > 
> > Thanks.  I'll see what I can some up with.
> 
> How about this, against current -mm
> 
> On both the read and write path for an rdev attribute, we
> call mddev_lock, first checking that mddev is not NULL.
> Once we get the lock, we check again.
> If rdev->mddev is not NULL, we know it will stay that way as it only
> gets cleared under the same lock.
> 
> While in the rdev show/store routines, we know that the mddev cannot
> get freed, do to the kobject relationships.
> 
> rdev_size_store is awkward because it has to drop the lock.  So we
> take a copy of rdev->mddev before the drop, and we are safe...
> 
> Comments?

*cringe*

I really don't like the entire scheme, to be honest.  BTW, what happens
if you try to add the same device to the same array after having it kicked
out?  If that comes before your delayed kobject_del(), the things will
get nasty since sysfs will (rightfully) refuse to add another entry with
the same name and parent while the old one is still there and for all
sysfs knows is going to stay there...
