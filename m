From: Thomas Horsten <thomas@horsten.com>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 20:19:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310132019.23119.thomas@horsten.com>
References: <200310131921.45824.thomas@horsten.com> <3F8AEF91.5080706@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8AEF91.5080706@backtobasicsmgmt.com>
Content-Disposition: inline
To: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 October 2003 19:31, Kevin P. Fleming wrote:

> Thomas Horsten wrote:
> > Now, the problem is that these BIOS based software RAID's all use whole
> > disks as opposed to individual partitions like the Linux MD driver.
>
> Would it not make more sense to leverage the device-mapper and just
> create a new personality or two for it? It can already be configured
> to use whole disk devices if the user needs to.

In the light of the desired functionality of this driver, I don't think this 
will work (see below also). The main aims is to make it transparent to the 
user (this is the whole point of BIOS based RAID's). The array should present 
itself as a normal, whole disk style block device inside Linux at boot time 
(if compiled in), so that LILO etc. can be used transparently. Remember the 
user has set up the RAID outside Linux (using the BIOS utility), and is thus 
likely to expect it to be autodetected and autoconfigured. So it should be 
"partitionable" - the whole reason that the BIOS RAID was implemented. The 
RAID should appear as one logical disk to ensure consistency between Linux 
and other OS's that use the array.

> > My idea was to either reserve a new major for "md_wholedisk" mode and
> > split it into drive,partition blocks of 16/32 inodes each, like the
> > gendisk driver supports, or alternatively split the existing major with,
> > say, the first 64 minors for normal style MD devs and the upper part
> > split like I suggested above (I'm not sure if this would work with
> > gendisk though).
>
> This sounds very complicated, although what I'm going to suggest is
> not really less complicated :-)

Well, let's save the simple solutions for the simple problems :-)

> > Another way of doing it would be to create a separate native MD RAID for
> > each partition on the BIOS RAID, but this has the major drawback that the
> > user wouldn't be able to repartition the device.
>
> That's going to be the biggest problem, that you have to support
> partitioning of the RAID array, as opposed to its components. No
> matter what underlying method you choose to implement it, the kernel
> currently does not support partitioning of MD devices (or
> device-mapper devices, for that matter). That means that without a
> significant amount of work, you'd be limited to using userspace
> partition-reading tools that then talk to device-mapper to create
> "logical" devices that are parts of the RAID array. This is what many
> people want the kernel to move towards anyway, so maybe this is a
> reasonable method.

Yes and that's why I propose splitting the MD driver into either two majors, 
where one uses the partitioning support (register_disk in genhd), or using 
the partitioning support for the upper part of the existing minor space. The 
support is there in gendisk, it's just a matter of calling register_disk 
after setting up the right information in the struct. The RAID code would 
need some tweaking but I think it would be workable - I think :-)

> > 3) The foreign RAID driver creates mddev_s based on its detection. If
> > necessary, the foreign RAID driver can also create its own personalities
> > (like the special type of RAID0 that Highpoint devices use, that supports
> > having a RAID0 where all disks are not of equal size, without wasting
> > space).
>
> I think that for 2.6 (well, now 2.7 and then backported to 2.6), you
> should seriously consider using the udev/hotplug/etc. framework that's
> being worked on. Here's a (very basic) overview:

I agree it should be considered but again I don't think it's appropriate - I 
don't want to rely on userspace tools for this type of RAID, since the 
"userspace tools" were already provided by the manufacturer in the form of 
the BIOS configuration utility. This is where the user creates the RAID set, 
and since it's a BIOS drive, again I would prefer the kernel to autodetect it 
completely and let the user see it as he would a "normal" block device.

> I know this is radically different than what you are proposing, but
> it's the plan for many people to move this direction for 2.7. It
> removes policy problems from the kernel, it supports unlimited layers
> of partitioning/RAID/etc., and the user can control the order that
> things get done (looking for partitions first vs. RAID superblocks
> first, etc.).

Using the hotplug interface for the resulting "wholedisk" array would 
certainly be a possibility, and I think this is worth looking into especially 
in the module version of the driver. But I still propose the "partitionable 
gendisk" way for initial detection, since it will make it much simpler to 
install on these types of RAID.

Regards,

Thomas

