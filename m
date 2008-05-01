From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] md: add new / required locking for calls to blk_remove_plug and blk_plug_queue
Date: Wed, 30 Apr 2008 17:50:34 -0700
Message-ID: <e9c3a7c20804301750o7621a5c5i4c2d92bc83ae0772@mail.gmail.com>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	 <20080430011943.20468.71869.stgit@dwillia2-linux.ch.intel.com>
	 <18457.4220.20511.737042@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18457.4220.20511.737042@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 30, 2008 at 5:36 PM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday April 29, dan.j.williams@intel.com wrote:
>  > Now that queue flags are no longer atomic (commit:
>  > 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e)  we must protect calls to
>  > blk_remove_plug with spin_lock(q->queue_lock).
>
>  Can't we just do
>
>   q->queue_lock = &conf->device_lock
>
>  and appropriate places in the various ->run functions?
>
>  It seems to be that we are doing appropriate locking, we just need to
>  convince queue_flag_set / queue_flag_clear that the correct lock is
>  locked.
>  ??
>

That's much simpler.  Hmm... as an additional cleanup should
device_lock then move to mddev_t since it really is a mddev-level
lock?  There seem to be more than a few places that cast
mddev->private just to get conf->device_lock.  Then all this lock
initialization is centralized.

--
Dan
