From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Proposed enhancements to MD
Date: Thu, 15 Jan 2004 10:07:34 +1100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <16389.52150.148792.875315@notabene.cse.unsw.edu.au>
References: <40033D02.8000207@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: message from Scott Long on Monday January 12
To: Scott Long <scott_long@adaptec.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 12, scott_long@adaptec.com wrote:
> All,
> 
> Adaptec has been looking at the MD driver for a foundation for their
> Open-Source software RAID stack.  This will help us provide full
> and open support for current and future Adaptec RAID products (as
> opposed to the limited support through closed drivers that we have
> now).

Sounds like a great idea.

> 
> While MD is fairly functional and clean, there are a number of 
> enhancements to it that we have been working on for a while and would
> like to push out to the community for review and integration.  These
> include:

It would help if you said up-front if you were thinking of 2.4 or 2.6
or 2.7 or all of whatever.  I gather from subsequent emails in the
thread that you are thinking of 2.6 and hoping for 2.4.
It is definately too late for any of this to go into kernel.org 2.4,
but some of it could live in an external patch set that people or
vendors can choose or not.

> 
> - partition support for md devices:  MD does not support the concept of
>    fdisk partitions; the only way to approximate this right now is by
>    creating multiple arrays on the same media.  Fixing this is required
>    for not only feature-completeness, but to allow our BIOS to recognise
>    the partitions on an array and properly boot them as it would boot a
>    normal disk.

Your attached patch is completely unacceptable as it breaks backwards
compatability.  /dev/md1 (blockdev 9,1) changes from being the second
md array to being the first partition of the first md array.

I too would like to support partitions of md devices but there is not
really elegant way to do it.
I'm beginning to think the best approach is to use a new major number
(which will be dynammically allocated because Linus has forbidden new
static allocations).  This should be fairly easy to do.

A reasonable alternate is to use DM.  As I understand it, DM can work
with any sort of metadata (As metadata is handled by user-space) so
this should work just fine.

Note that kernel-based autodetection is seriously a thing of the past.
As has been said already, it should be just as easy and much more
manageable to do autodtection in early user-space.  If it isn't, then
we need to improve the early user-space tools.

> 
> - generic device arrival notification mechanism:  This is needed to
>    support device hot-plug, and allow arrays to be automatically
>    configured regardless of when the md module is loaded or initialized.
>    RedHat EL3 has a scaled down version of this already, but it is
>    specific to MD and only works if MD is statically compiled into the
>    kernel.  A general mechanism will benefit MD as well as any other
>    storage system that wants hot-arrival notices.

This has largely been covered, but just to add or clarify slightly:

 This is not an md issue.  This is either a buss controller or
 userspace issue.
 2.6 has a "hotplug" infrastructure and each buss should report
 hotplug events to userspace.
 If they don't they should be enhanced so they do.
 If they do, then userspace needs to be told what to do with these
 events, and when to assemble devices into arrays.

 
> 
> - RAID-0 fixes:  The MD RAID-0 personality is unable to perform I/O
>    that spans a chunk boundary.  Modifications are needed so that it can
>    take a request and break it up into 1 or more per-disk requests.

In 2.4 it cannot, but arguable doesn't need to.  However I have a
fairly straight-forward patch which supports raid0 request splitting.
In 2.6, this should work properly already.

> 
> - Metadata abstraction:  We intend to support multiple on-disk metadata
>    formats, along with the 'native MD' format.  To do this, specific
>    knowledge of MD on-disk structures must be abstracted out of the core
>    and personalities modules.

In 2.4, this would be a massive amount of work and I don't recommend
it.
In 2.6, most of this is already done - the knowledge about superblock
format is very localised.  I would like to extend this so that a
loadable module can add a new format.  Patches welcome.

Note that the kernel does need to know about the format of the
superblock.
DM can manage without knowing as it's superblock is read mostly and
the very few updates (for reconfiguration) are managed by userspace.
For raid1 and raid5 (which DM doesn't support), we need to update the
superblock on errors and I think that is best done in the kernel.


> 
> - DDF Metadata support: Future products will use the 'DDF' on-disk
>    metadata scheme.  These products will be bootable by the BIOS, but
>    must have DDF support in the OS.  This will plug into the abstraction
>    mentioned above.

I'm looking forward to seeing the specs for DDF (but isn't it pretty
dump to develop a standard in a closed forum).  If DDF turns out to
have real value I would he happy to have support for it in linux/md.

NeilBrown
