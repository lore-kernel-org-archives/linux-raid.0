From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 11:31:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8AEF91.5080706@backtobasicsmgmt.com>
References: <200310131921.45824.thomas@horsten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310131921.45824.thomas@horsten.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Horsten wrote:

> Now, the problem is that these BIOS based software RAID's all use whole disks 
> as opposed to individual partitions like the Linux MD driver.

Would it not make more sense to leverage the device-mapper and just 
create a new personality or two for it? It can already be configured 
to use whole disk devices if the user needs to.

> 
> My idea was to either reserve a new major for "md_wholedisk" mode and split it 
> into drive,partition blocks of 16/32 inodes each, like the gendisk driver 
> supports, or alternatively split the existing major with, say, the first 64 
> minors for normal style MD devs and the upper part split like I suggested 
> above (I'm not sure if this would work with gendisk though).

This sounds very complicated, although what I'm going to suggest is 
not really less complicated :-)

> 
> Another way of doing it would be to create a separate native MD RAID for each 
> partition on the BIOS RAID, but this has the major drawback that the user 
> wouldn't be able to repartition the device.

That's going to be the biggest problem, that you have to support 
partitioning of the RAID array, as opposed to its components. No 
matter what underlying method you choose to implement it, the kernel 
currently does not support partitioning of MD devices (or 
device-mapper devices, for that matter). That means that without a 
significant amount of work, you'd be limited to using userspace 
partition-reading tools that then talk to device-mapper to create 
"logical" devices that are parts of the RAID array. This is what many 
people want the kernel to move towards anyway, so maybe this is a 
reasonable method.

> 3) The foreign RAID driver creates mddev_s based on its detection. If 
> necessary, the foreign RAID driver can also create its own personalities 
> (like the special type of RAID0 that Highpoint devices use, that supports 
> having a RAID0 where all disks are not of equal size, without wasting space).
> 

I think that for 2.6 (well, now 2.7 and then backported to 2.6), you 
should seriously consider using the udev/hotplug/etc. framework that's 
being worked on. Here's a (very basic) overview:

- a hotplug event occurs that signals that a block device has been 
found (raw, whole hard drive at this point)
- /sbin/hotplug (or some script that it invokes) uses a userspace tool 
to look at the device to see if it contains a Medley RAID superblock; 
if so, it records that information somewhere (pending the arrival of 
the other pieces of the array)
- second hotplug event happens (for second raw, whole hard drive)
- again, Medley RAID superblock on device is found, this time a 
complete set of superblocks is known about, so the userspace tool 
passes that information to device-mapper, telling it to create a new 
block device composed of these two devices, using your new (or an 
existing) device-mapper personality
- this causes yet another hotplug event, this time because the RAID 
block device appeared
- device is scanned looking for Medley RAID superblock (in case it's 
RAID0 inside a RAID1)... if none is found, device is scanned for 
understandable partition table, if one is found, device-mapper is used 
to create logical devices out of those partitions

I know this is radically different than what you are proposing, but 
it's the plan for many people to move this direction for 2.7. It 
removes policy problems from the kernel, it supports unlimited layers 
of partitioning/RAID/etc., and the user can control the order that 
things get done (looking for partitions first vs. RAID superblocks 
first, etc.).

