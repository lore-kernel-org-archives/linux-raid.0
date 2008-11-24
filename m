From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
Date: Tue, 25 Nov 2008 02:18:18 +0900
Message-ID: <492AE1DA.2000808@suse.de>
References: <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk> <492AB480.5060207@kernel.org> <492AB98C.7030105@suse.de> <20081124144823.GC28946@ZenIV.linux.org.uk> <492AD169.9000805@suse.de> <20081124164245.GD28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124164245.GD28946@ZenIV.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

Al Viro wrote:
> On Tue, Nov 25, 2008 at 01:08:09AM +0900, Tejun Heo wrote:
> 
>> Devices can be killed from userland via sysfs for SCSI or mdadm for
>> md.  It's true that such approach is less convenient for unloading but
>> if it can make usual cases easier, why not?
> 
> _What_ usual cases?

Following from gendisk or whatever high level object to lower level
object.  open is most common but there are other places.

>> Well, I don't know.  It seems like a lot of trouble just to allow
>> "rmmod something" without first killing the devices and as people are
>> now so used to reference counted objects and ->release, not having it
>> on cdev or gendisk is quite a PITA.  (BTW, Greg, can you please drop
>> cdev->release patch for now, it's wrong as it currently stands).
> 
> gendisks *ARE* reference counted, damnit.  So are net_device and a lot
> of other things.

Yes it is (where did I say they weren't?) but different in that it is
a severing boundary for module reference and thus can't tell its
creator when it's dying.

> And no, it's not true that "struct net_device exists"
> implies "the low-level objects that once might have been related to it
> still exist" either.

No, it's not.  If it were, we wouldn't be arguing.  :-)

>> Can you see any problem with caching ->disk_release existence on
>> registration and wrap __module_get/put() around its invocation?  It
>> wouldn't change behavior of any existing drivers and md can use it if
>> it wants.  Doing "mdadm --stop --scan" would be enough to unload the
>> module and md can do whatever forward or back reference it wants to do
>> to work out the weird userland interface.
> 
> Other than general ugliness and special-casing where none is really needed?
> Special-casing as "very different life cycle if special method is present"...

The duality is ugly alright and will probably need a big fat comment
to explain what's going on but the current situation isn't too pretty
(or at least convenient) either.

> If anything, we need to go in opposite direction - give the drivers a way
> to say "my underlying object is gone, STFU and don't bother me with that
> gendisk ever again; free it when you are done with it, but from now on
> any access to it would better fail.  Oh, and I might find a new device
> in place of that any time now, so new open() would better get not fail
> just something in VFS still has a reference to that gendisk".
>
> Which is doable - note that we can unhash block_device, dissociate inodes
> from it and let new open() DTRT.  Earlier opened files will still have
> a reference to address_space of original block_device (which is why we
> have file->f_mapping instead of going through ->f_dentry->d_inode->i_mapping),
> so we are fine.

Yes, that will be great too.  I'm just unhappy with the current
situation which is in the middle of the two sane positions where
drivers have to worry about whether high level object is valid or not.
If it's either always valid or can be told to go away into oblivion
(proper severing, no ->release necessary at all), I won't have any
complaint.

Thanks.

-- 
tejun
