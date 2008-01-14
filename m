From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 14:21:45 +1100
Message-ID: <18314.54601.196877.828373@notabene.brown>
References: <20080114123726.19968.patches@notabene>
	<1080114014531.20354@suse.de>
	<20080114020459.GN27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Viro on Monday January 14
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 14, viro@ZenIV.linux.org.uk wrote:
> On Mon, Jan 14, 2008 at 12:45:31PM +1100, NeilBrown wrote:
> > 
> > Due to possible deadlock issues we need to use a schedule work to
> > kobject_del an 'rdev' object from a different thread.
> > 
> > A recent change means that kobject_add no longer gets a refernce, and
> > kobject_del doesn't put a reference.  Consequently, we need to
> > explicitly hold a reference to ensure that the last reference isn't
> > dropped before the scheduled work get a chance to call kobject_del.
> > 
> > Also, rename delayed_delete to md_delayed_delete to that it is more
> > obvious in a stack trace which code is to blame.
> 
> I don't know...  You still get kobject_del() and export_rdev()
> in unpredictable order; sure, it won't be freed under you, but...

I cannot see that that would matter.
kobject_del deletes the object from the kobj tree and free sysfs.
export_rdev disconnects the objects from md structures and releases
the connection with the device.  They are quite independent.

> 
> What is that deadlock problem, anyway?  I don't see anything that
> would look like an obvious candidate in the stuff you are delaying...

Maybe it isn't there any more....

Once upon a time, when I 
   echo remove > /sys/block/mdX/md/dev-YYY/state

sysfs_write_file would hold buffer->sem while calling my store
handler.
When my store handler tried to delete the relevant kobject, it would
eventually call orphan_all_buffers which would try to take buf->sem
and deadlock.

orphan_all_buffers doesn't exist any more, so maybe the deadlock is
gone too.
However the comment at the top of sysfs_schedule_callback in
sysfs/file.c says:

 *
 * sysfs attribute methods must not unregister themselves or their parent
 * kobject (which would amount to the same thing).  Attempts to do so will
 * deadlock, since unregistration is mutually exclusive with driver
 * callbacks.
 *

so I'm included to leave the code as it is....  ofcourse the comment
could be well out of date.

NeilBrown
