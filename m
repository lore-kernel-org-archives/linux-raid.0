From: Thomas Horsten <thomas@horsten.com>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 20:25:30 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310132025.30939.thomas@horsten.com>
References: <200310131921.45824.thomas@horsten.com> <20031013190323.GD23916@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031013190323.GD23916@marowsky-bree.de>
Content-Disposition: inline
To: Lars Marowsky-Bree <lmb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 October 2003 20:03, Lars Marowsky-Bree wrote:

> > Now, the problem is that these BIOS based software RAID's all use whole
> > disks as opposed to individual partitions like the Linux MD driver.
>
> Why is that a problem? You can assemble a MD using whole disks instead
> of partition. A block device is a block device is a block device.

The problem is that the block device thus assembled won't have support for 
multiple partitions, for two reasons: the MD driver doesn't align the minor 
to any offset, and it doesn't allocate multiple minors for a RAID so we can 
call register_disk to parse the partition table and create the logical 
partition devices. Both of these are defaults, and it might be possible to 
tweak.

> > Another way of doing it would be to create a separate native MD RAID for
> > each partition on the BIOS RAID, but this has the major drawback that the
> > user wouldn't be able to repartition the device.
>
> Use a volume manager (LVM1, LVM2, EVMS2 ...) on top of the md. Works
> just fine.

If the volume manager can be set up automatically this might just be the 
solution.

> > 1) User selects CONFIG_MD_FOREIGN_SUPERBLOCKS and
> > CONFIG_MD_WHOLEDISK_RAID, along with one oif the BIOS specific drivers
> > like CONFIG_MD_FOREIGN_MEDLEY. Each BIOS driver has its own superblock
> > type.
>
> Autodiscovery is a problem, but I'd prefer to do that in the initrd from
> within userspace. That's much cleaner.

Well due to the nature of BIOS RAID's, the user is likely to expect that it 
will be detected and handled automatically without the need for a separate 
setup (since the machine creates the logical device for them, and this works 
in other OS's that use the BIOS to access the drive).

I agree it would be cleaner to do it in userspace, but autodiscovery is one of 
the major aims of this driver. I would like to support both methods if at all 
possible.

Best regards,

Thomas

