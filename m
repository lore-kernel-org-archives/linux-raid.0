From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Date: Fri, 28 Nov 2008 11:23:14 +1100
Message-ID: <18735.14834.899120.164099@notabene.brown>
References: <20081124035516.3465.66413.stgit@notabene.brown>
	<20081124035530.3465.26724.stgit@notabene.brown>
	<492A2B2B.7030606@kernel.org>
	<18730.14324.830648.449469@notabene.brown>
	<492A3CE6.4010206@kernel.org>
	<20081124062417.GZ28946@ZenIV.linux.org.uk>
	<492A500C.9090200@kernel.org>
	<20081124133124.GB28946@ZenIV.linux.org.uk>
	<492AB480.5060207@kernel.org>
	<492AB98C.7030105@suse.de>
	<20081124144823.GC28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Viro on Monday November 24
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tejun Heo <teheo@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

On Monday November 24, viro@ZenIV.linux.org.uk wrote:
> 
> I really think that it's much saner than trying to change the lifetime
> rules for gendisk, etc.

I'm not sure there is anything wrong with the lifetime rules for
gendisk....

In my mind a big issue is:
   What should happen if "open" is racing with "destroy device" ?

For 'sd', if you open before the decision has been made to tear down
the data structures, the open succeeds but you start getting EIO on
any IO.
If you open after the decision, you get ENODEV (or ENXIO?).
If you wait a little longer and some other device gets hot-plugged,
then the open succeeds on a different physical device.

For 'md' the situation is quite different, due to unfortunate legacy
interface design.
An open should never fail with ENODEV.
It might return a device on which read/write always fails and only
various 'ioctls' work, or it might return a device which is fully
working.

So we need to close the window in which ENODEV can be returned.

I think the code I wrote is the best way to close that window.  If we
detect that we are in the window during open, wait for the window to
close and retry, by returning ERESTARTSYS.


I've thought more about the possibility of the disk_release method
which is used to tear down the md data structures but I don't think it
would really answer the need.

A key point in time is when blk_unregister_region is called to
remove the mapping from minor number to the gendisk.
At any time before this, new references can be taken by an open.
At any time after this, any open will be directed through ->probe
which can do any necessary interlocking with ->open.

Currently we need to call blk_unregister_region before the final
put_disk otherwise a new reference could be taken while that put_disk
is running.
blk_unregister_region is normally called by unlink_gendisk called by
del_gendisk.
So we need to call del_gendisk before the final call to put_disk.
And once we have called del_gendisk we may as well clean up the md
specific stuff there and not bother with a ->disk_release method.

So I'm having trouble seeing what is wrong with my approach (other
than the fact it implements an unfortunate choice of user-space
interface, which we agree is a legacy requirement) or how anything
else could provide a better solution.

I can appreciate that there might be other issues with gendisk lifetime
(such as the fact that get_disk takes a reference to the module but
put_disk doesn't) but I suspect they are largely orthogonal to my
current issue.

Finally, I suspect that there is a problem with my patch as it stands
with respect to module reference counting.  I'll have to explore to
be sure exactly what is happening, but I strongly suspect it is
wrong.  Thank you for highlighting that issue for me.

NeilBrown
