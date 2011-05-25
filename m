From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 2 of 9] MD:  should_read_superblock
Date: Wed, 25 May 2011 09:00:19 -0500
Message-ID: <99ECF7E7-26F0-4613-9269-2BB91EBBF54C@redhat.com>
References: <201105240306.p4O369g2029293@f14.redhat.com> <20110525140157.497bebaf@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110525140157.497bebaf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On May 24, 2011, at 11:01 PM, NeilBrown wrote:

> On Mon, 23 May 2011 22:06:09 -0500 Jonathan Brassow <jbrassow@f14.redhat.com>
> wrote:
> 
>> Patch name: md-should_read_superblock.patch
>> 
>> Add new function to determine whether MD superblocks should be read.
>> 
>> It used to be sufficient to check if mddev->raid_disks was set to determine
>> whether to read the superblock or not.  However, device-mapper (dm-raid.c)
>> sets this value before calling md_run().  Thus, we need additional mechanisms
>> for determining whether to read the superblock.  This patch adds the condition
>> that if rdev->meta_bdev is set, the superblock should be read - something that
>> only device-mapper does (and only when there are superblocks to be read/used).
>> 
>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> I've been feeling uncomfortable about this and have spent a while trying to
> see if my discomfort is at all justified.  It seems that maybe it is.
> 
> The discomfort is really at analyze_sbs being used for dm arrays.  It is
> really for arrays where md completely controls the metadata.  dm array are in
> a strange intermediate situation where some metadata is controlled by
> user-space (so md is told about some details of the array) and other metadata
> is managed by the kernel - so md finds those bits out by itself.
> 
> It isn't yet entirely clear to me how to handle the half-way state best.
> 
> But the particular problem is that analyse_sbs can call kick_rdev_from_array.
> This will call export_rdev which will call kobject_put(&rdev->kboj) which is
> bad because dm-based rdevs do not get their kobj initialised.
> 
> So I think analyse_sbs should not be used for dm arrays.
> Rather the code in dm-raid.c which parses the metadata_device info from the
> constructor line should load_super.  Then before md_run is called it should
> do the 'validate_super' step and record any failures.
> 
> So the only super_types method that md code would call on a dm-raid array
> would be sync_super.
> 
> Does that work for you?

That seems sensible.  It changes things up a bit though...

1) the load_super and validate_super functions would go into dm-raid.c, but stubs (returning EINVAL) would remain in md.c in order to fill-out the super_types pointers.
2) the device-mapper superblock would have to move to a common place because it would need to be shared by the super functions in dm-raid.c and sync_super in md.c.  I'd rather not put the new superblock in md_p.h... perhaps a new file, dm-raid.h?  (You could hide the superblock entirely in dm-raid.c, but you'd have to export a function from dm-raid.c that would be called by sync_super in md.c - necessitating a dm-raid.h again.  Is this a better solution?)

 brassow