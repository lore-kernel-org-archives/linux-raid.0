From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
Date: Mon, 24 Nov 2008 15:56:12 +0900
Message-ID: <492A500C.9090200@kernel.org>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124062417.GZ28946@ZenIV.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

Al Viro wrote:
>> I suppose so.  Maybe just void (*release)(struct gendisk *) but Jens is
>> the maintainer.  Jens, what do you think?
> 
> First of all, release is already taken (with exactly that argument, BTW).

Right.  :-(

> And doing that at freeing gendisk is a bad idea - md.ko might have been
> long gone by the time you've got there, not to mention anything else...
> IOW, it's too late; once the damn thing is not opened anymore (and nobody
> is the middle of trying to open it), the module might be dead and gone,
> so all uses of ->private_data and ->fops are illegal aftenr that point.

mddev holds module reference and till the gendisk is gone mddev won't
be gone, so as long as gendisk is around the respective mddev and
md.ko are around.

This is because creation and deletion of md devices are managed by
userland and the module is kept referenced as long as there are active
devices.  The current block interface only verifies ops availability
before open and asks drivers to verify object validity separately in
->open, which makes sense if the intention is to allow rmmod while
devices are hot, but it also requires the low level driver to
implement index of all active devices and look them up atomically
during ->open, which sometimes is unnatural to implement as it's
unnecesary for any other purpose and can create subtle races as shown
by md.

I don't think it's necessary to allow modules to unload while devices
are hot.  SCSI doesn't follow it (at least not at the block layer),
nor does md.  It's seldom necessary to unload those modules in the
first place and when necessary active devices can be killed via sysfs
or mdadm (which BTW makes more sense to me - kill the users before
unloading the module).  Without such requirement, both block and
character devices can stick with more regular reference counting like
the rest of the kernel.

Thanks.

-- 
tejun
