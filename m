From: Dave Jiang <djiang@mvista.com>
Subject: Re: multi-hosting support for carrier grade Linux
Date: Tue, 05 Apr 2005 16:34:07 -0700
Message-ID: <4253206F.7020600@mvista.com>
References: <20050405204155.GA32724@blade.az.mvista.com> <4253081F.6000901@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4253081F.6000901@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Dave Jiang wrote:
> 
>> I'm attempting to implement multihost support of the MD for environments
>> such as carrier grade Linux. Multihost support allows the RAID array to
>> be claimed by a particular host via a unique ID (unique SCSI host ID,
>> FibreChannel WWN, or geographical address of a chassis blade. That way
>> another host that can access the disks do not claim the same disks that
>> are used by the RAID array. 
> 
> 
> Why not just use SCSI reservations?

 From my understanding of SCSI reservations ownership of the entire disk 
claimed. If we have multiple host blades, it is possible that multiple 
hosts to claim separate partitions on a disk, each for their own RAIDs - 
not optimal for performance but useful in many embedded environments.

Even if reservations targeted specific portions of the disk the 
partitioning tools (e.g. fdisk) would have to be involved to keep things 
straight and deal with the multiple initiator situations. Tagging the 
superblocks IMHO seems much simpler.

Another issue comes up due to hotswapping. In some environments, such as 
FibreChannel, SCSI addresses may be dynamic making releasing a 
reservation impractical - the replacement host may not have the same 
SCSI addresses as its predecessor.

> 
>> I would like to store a 64bit unique ID on the
>> superblock of the device. The least intrusive way IMHO to do this is
>> implementing the feature via the management app such as mdadm in
>> userland. However, it seems that after I instruct the kernel to create 
>> the MD array via mdadm, the kernel starts out with a blank superblock 
>> and clobbers the
> 
> 
> If you write a valid superblock to the disk and then assemble the array, 
> the superblock doesn't get clobbered.

In order to target a particular partition to a specific host the 
superblock is the obvious place to place the discriminator. The assembly 
process simply bypasses the partitions that are not specifically 
targeted to it. This way a group of hosts on a shared peripheral 
connection (e.g. FibreChannel) would only claim what they should and 
ignore what they shouldn't.

Perhaps the UUID within the superblock could be built via a function 
that could be abstracted or overloaded. The data within only needs to be 
unique within its environment so it could contain geographical 
addressing, target information or whatever fits. Perhaps this sounds a 
bit less intrusive and requires little or perhaps no kernel changes?

>> data I have stored on the superblock via mdadm. Would it be acceptable
>> to modify the kernel such that the unique ID info is preserved during
>> the creation of the superblock by the kernel? Example patch follows:
> 
> 
> As for adding additional fields to the various superblock formats, you'd 
> have to ask Neil if he's open to that.
> 
> -- 
> Paul

------------------------------------------------------
Dave Jiang
Software Engineer
MontaVista Software, Inc.
mailto:djiang@mvista.com
------------------------------------------------------

