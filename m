From: Scott Long <scott_long@adaptec.com>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 11:03:40 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400432FC.6050209@adaptec.com>
References: <20040113102433.GK8418@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040113102433.GK8418@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree wrote:
> On 2004-01-12T20:41:54,
>    Scott Long <scott_long@adaptec.com> said:
> 
> Hi Scott, this is good to see!
> 
> 
>>- partition support for md devices:  MD does not support the concept of
>>  fdisk partitions; the only way to approximate this right now is by
>>  creating multiple arrays on the same media.  Fixing this is required
>>  for not only feature-completeness, but to allow our BIOS to recognise
>>  the partitions on an array and properly boot them as it would boot a
>>  normal disk.
> 
> 
> I'm not too excited about this, because Device Mapping on top of md is
> much more flexible, but I see that users want it, and it should be
> pretty easy to add.
> 

The biggest issue here is that a real fdisk table needs to exist on the
array in order for our BIOS to recognise it as a boot device.  While
Device Mapper can probably do a good job at creating logical storage
extends out of a single md device, it doesn't get us any closer to being
able to boot off of an MD array.

> 
>>- generic device arrival notification mechanism:  This is needed to
>>  support device hot-plug, and allow arrays to be automatically
>>  configured regardless of when the md module is loaded or initialized.
>>  RedHat EL3 has a scaled down version of this already, but it is
>>  specific to MD and only works if MD is statically compiled into the
>>  kernel.  A general mechanism will benefit MD as well as any other
>>  storage system that wants hot-arrival notices.
> 
> 
> Yes. Is anything missing from the 2.6 & hotplug & udev solution which
> you require?
> 

I'll admit that I'm not as familiar with 2.6 as I should be.  Does a
disk arrival mechanism already exist?

> 
>>- RAID-0 fixes:  The MD RAID-0 personality is unable to perform I/O
>>  that spans a chunk boundary.  Modifications are needed so that it can
>>  take a request and break it up into 1 or more per-disk requests.
> 
> 
> Agreed.
> 
> 
>>- Metadata abstraction:  We intend to support multiple on-disk metadata
>>  formats, along with the 'native MD' format.  To do this, specific
>>  knowledge of MD on-disk structures must be abstracted out of the core
>>  and personalities modules.
> 
> 
> This can get difficult, of course, and needs to be implemented in a way
> which doesn't slow us down too much.
> 

Normal I/O doesn't touch the metadata.  Only during error recovery and
configuration would this be touched.  Instead of the core and 
personality modules directly manipulating the metadata, a set of
metadata-specific function pointers will be called through to handle
changing the on-disk metadata.  So, no significant operational overhead
is introduced.

> 
>>- DDF Metadata support: Future products will use the 'DDF' on-disk
>>  metadata scheme.  These products will be bootable by the BIOS, but
>>  must have DDF support in the OS.  This will plug into the abstraction
>>  mentioned above.
> 
> 
> OK. How does the DDF metadata differ from the current md data? Is it
> merely the layout, or are there functional differences?
> 

I'm not sure if the DDF spec has been officially published yet.  It
defines a set of data structures and their location on the disk that
allows disk to be uniquely identified, logical extents to be grouped
into arrays, recording of disk and array state, and event logging.
It is completely different from the metadata that is used for classic
MD.  However, it is still compatible with the high-level striping and
mirroring operations of MD.

> In particular, I'm wondering whether partitions using the new activity
> logging features of md will still be bootable, or whether the boot
> partitions need to be 'md classic'.

Our products will only recognise and boot off of DDF arrays.  They have
no concept of classic MD metadata.

The goal of the abstraction is to allow new metadata personalities to be
plugged in and 'Just Work', while not inhibiting the choice of using
whatever metadata is most suitable for existing arrays.  If you need to
boot off of a DDF-aware controller, but use classic MD for secondary
arrays, that will work.

> 
> 
>>bit due to the radical changes in the disk/block layer in 2.6.  The 2.4
>>version works quite well, while the 2.6 version is fairly fresh. 
> 
> 
> I'd be reluctant doing any of the work for 2.4, but this is of course
> upto you.

This work was originally started on 2.4.  With the closing of 2.4 and
release of 2.6, we are porting are work forward.  It would be nice to
integrate the changes into 2.4 also, but we recognise the need for 2.4
to remain as stable as possible.

Scott

