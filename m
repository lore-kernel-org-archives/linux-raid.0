From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Tue, 30 Mar 2004 10:03:55 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <842610000.1080666235@aslan.btc.adaptec.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <200403261315.20213.kevcorry@us.ibm.com> <1644340000.1080333901@aslan.btc.adaptec.com> <200403270939.29164.kevcorry@us.ibm.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403270939.29164.kevcorry@us.ibm.com>
Content-Disposition: inline
To: Kevin Corry <kevcorry@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-raid.ids

> Well, there's certainly no guarantee that the "industry" will get it right. In
> this case, it seems that they didn't. But even given that we don't have ideal
> metadata formats, it's still possible to do discovery and a number of other
> management tasks from user-space.

I have never proposed that management activities be performed solely
within the kernel.  My position has been that meta-data parsing and
updating has to be core-resident for any solution that handles advanced
RAID functionality and that spliting out any portion of those roles
to userland just complicates the solution.

>> it is perfectly suited to some types of logical volume management
>> applications.  But that is as far as it goes.  It does not have any
>> support for doing "sync/resync/scrub" type operations or any generic
>> support for doing anything with meta-data.
> 
> The core DM driver would not and should not be handling these operations.
> These are handled in modules specific to one type of mapping. There's no
> need for the DM core to know anything about any metadata. If one particular
> module (e.g. dm-mirror) needs to support one or more metadata formats, it's
> free to do so.

That's unfortunate considering that the meta-data formats we are talking
about already have the capability of expressing RAID 1(E),4,5,6.  There has
to be a common meta-data framework in order to avoid this duplication.

>> In all of the examples you 
>> have presented so far, you have not explained how this part of the equation
>> is handled.

...

> Before the new disk is added to the raid1, user-space is responsible for
> writing an initial state to that disk, effectively marking it as completely
> dirty and unsynced. When the new table is loaded, part of the "resume" is for
> the module to read any metadata and do any initial setup that's necessary. In
> this particular example, it means the new disk would start with all of its
> "regions" marked "dirty", and all the regions would need to be synced from
> corresponding "clean" regions on another disk in the set.
> 
> If the previously-existing disks were part-way through a sync when the table
> was switched, their metadata would indicate where the current "sync mark" was
> located. The module could then continue the sync from where it left off,
> including the new disk that was just added. When the sync completed, it might
> have to scan back to the beginning of the new disk to see if had any remaining
> dirty regions that needed to be synced before that disk was completely clean.
> 
> And of course the I/O-mapping path just has to be smart enough to know which
> regions are dirty and avoid sending live I/O to those.
> 
> (And I'm sure Joe or Alasdair could provide a better in-depth explanation of 
> the current dm-mirror module than I'm trying to. This is obviously a very 
> high-level overview.)

So all of this complexity is still in the kernel.  The only difference is
that the meta-data can *also* be manipulated from userspace.  In order
for this to be safe, the mirror must be suspended (meta-data becomes stable),
the meta-data must be re-read by the userland program, the meta-data must be
updated, the mapping must be updated, the mirror must be resumed, and the
mirror must revalidate all meta-data.  How do you avoid deadlock in this
process?  Does the userland daemon, which must be core resident in this case,
pre-allocate buffers for reading and writing the meta-data?

The dm-raid1 module also appears to intrinsicly trust its mapping and the
contents of its meta-data (simple magic number check).  It seems to me that 
the kernel should validate all of its inputs regardless of whether the
ioctls that are used to present them are only supposed to be used by a
"trusted daemon".

All of this adds up to more complexity.  Your argument seems to be that,
since DM avoids this complexity in its core, this is a better solution,
but I am more interested in the least complex, most easily maintained
total solution.

>> The simplicity of DM is part of why it is compelling.  My belief is that
>> merging RAID into DM will compromise this simplicity and divert DM from
>> what it was designed to do - provide LVM transforms.
> 
> I disagree. The simplicity of the core DM driver really isn't at stake here.
> We're only talking about adding a few relatively complex target modules. And
> with DM you get the benefit of a very simple user/kernel interface.

The simplicity of the user/kernel interface is not what is at stake here.
With EMD, you can perform all of the same operations talked about above,
in just as few ioctl calls.  The only difference is that the kernel and
only the kernel, reads and modifies the metadata.  There are actually
fewer steps for the userland application than before.  This becomes even
more evident as more meta-data modules are added.

> I don't honestly expect to suddenly change your mind on all these issues.
> A lot of work has obviously gone into EMD, and I definitely know how hard it
> can be when the community isn't greeting your suggestions with open arms.

I honestly don't care if the final solution is EMD, DM, or XYZ so long
as that solution is correct, supportable, and covers all of the scenarios
required for robust RAID support.  That is the crux of the argument, not
"please love my code".

--
Justin

