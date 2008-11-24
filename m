From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Date: Mon, 24 Nov 2008 14:48:23 +0000
Message-ID: <20081124144823.GC28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk> <492AB480.5060207@kernel.org> <492AB98C.7030105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <492AB98C.7030105@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

On Mon, Nov 24, 2008 at 11:26:20PM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Can we then make gendisk hold owner module till it gets released?  It
> > would be much nicer to write code to if we can keep the regular object
> > reference counting across module boundaries and being able to taking
> > down a module while devices are active isn't a too important
> > requirement.  For vast majoerity (ide, scsi, md) one way or the other
> > doesn't even matter at all.
> 
> If always holding reference is too much of a change, we can do
> 
> 	if (gendisk->fops->disk_release) {
> 		__module_get(gendisk->fops->owner);
> 		gendisk->fops->disk_release(gendisk);
> 		module_put(gendisk->fops->owner);
> 	}

With ->fops in already freed memory?  Good idea, that...

Look, that's the wrong object *and* the wrong place; gendisk is separate
from driver-specific data structures for a good reason.

_IF_ you want to tie something to "opened or in process of being opened",
the right place is __blkdev_get()/blkdev_put() (BTW, note that get_gendisk()
is essentially a part of __blkdev_get()).

It's not about rmmod of module while some disk is opened; _that_ is impossible
as is.  It's about e.g. modules like sd.ko that would be flat-out impossible
to unload at all.

Think for a minute: we do have a bunch of gendisks created by sd; they stay
around until we rmmod the damn thing and we really want it that way.
We can't have their existence pinning sd down.  What we do is "module is
busy if any of those is opened or in the middle of opening".

The same goes for just about any block driver out there; md is weird for
one reason - it wants to have devices possible to open without any prior
event that would mark the beginning of availability (such as e.g. hardware
detection for SCSI, IDE, etc.).  That is a side effect of bad API - there
*is* a moment for md that would be a good candidate for such event (array
being completely configured and available for normal IO), but that would
require an API for creating and configuring these suckers that wouldn't
start with "First you open the very device you are trying to create..."
Too bad - we are tied to lousy userland interface and can't get rid of
it.  That is where all the PITA is coming from.

And the right way to deal with that is to have explicit boundaries for
"opened or in process of being opened"; we almost have them (probe and
final release), so the only point we are missing is on failure exit from
__blkdev_get()...

I really think that it's much saner than trying to change the lifetime
rules for gendisk, etc.
