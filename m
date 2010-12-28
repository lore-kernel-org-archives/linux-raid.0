From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Tue, 28 Dec 2010 12:50:20 +0100
Message-ID: <201012281250.20838.laurent.pinchart@ideasonboard.com>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com> <201012272235.45824.laurent.pinchart@ideasonboard.com> <20101228170542.2d55944e@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101228170542.2d55944e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tuesday 28 December 2010 07:05:42 Neil Brown wrote:
> On Mon, 27 Dec 2010 22:35:45 +0100 Laurent Pinchart wrote:
> > On Monday 27 December 2010 22:04:08 Neil Brown wrote:
> > > On Mon, 27 Dec 2010 21:35:48 +0100 Laurent Pinchart wrote:
> > > > > So something odd is happening, and more logs are needed to guess
> > > > > what.
> > > > 
> > > > I'll try to get more logs. In the meantime I've found something
> > > > weird. If I run mdadm --assemble --scan twice in a row, the
> > > > partitions are correctly created the second time.
> > > > 
> > > > The next problem will be that the array is created in read-only mode.
> > > > mdadm -- readwrite /dev/md126 doesn't help there, but echo active >
> > > > /sys/class/block/md126/md/array_state does.
> > > 
> > > The array is read-only because 'mdmon' is not running.  When mdadm
> > > assembles the array it starts mdmon to monitor the array.  This is
> > > needed when the array uses a metadata format that the kernel doesn't
> > > understand. It is mdmon's job to switch the array to read-write
> > > 
> > > I cannot think why mdmon is not being started, unless maybe it doesn't
> > > exist on the initramfs - it should be in /sbin.
> > 
> > Bingo! That solved part of the problem. Adding mdmon to initramfs now
> > switches the array to read-write. Partitions detection still doesn't
> > work though.
> 
> Good!
> 
> > > The logs you sent show that the partitions aren't getting detected at
> > > all, so it isn't the case that they get detected and then removed.
> > > 
> > > I don't remember exactly what triggers the partition detection.  Maybe
> > > just opening the array device...
> > > It is entirely possible that once you get the mdmon issue sorted out,
> > > the other will disappear.
> > > 
> > > You could try
> > > 
> > >   mdmon md126 &
> > > 
> > > and see if that makes the array read/write and creates the partitions.
> > > Also check with ps to confirm that mdmon isn't running.
> > 
> > After adding mdmon to the initramfs image, the md126 array is correctly
> > switched to active. ps reports that mdmon is running of md127 (the
> > container), but not md126.
> > 
> > The partitions are still not created. If I run mdmon md126, I get
> > 
> > mdmon: md126 is not a container - cannot monitor
> 
> It should have been 'md127' - md127 is the container, md126 is the array
> inside the container.
> 
> But now that mdmon is on the initramfs, this shouldn't be needed.
> 
> > And the partitions are then created. Does that sound familiar ?
> 
> I guess it is simply anything that accesses /dev/md126 will cause the
> partition detection to happen.  Usually udev comes along and pokes an md
> device as soon as it is created and that should be enough for the
> partitions to appear.  Do you have udev running??
> 
> Maybe I need to get mdadm to open/close the array once it is assembled so
> as to trigger partition detection.
> 
> If you are using udev, then something strange is happening.
> 
> If you aren't using udev, then you need to have something open /dev/md/vol0
> after mdadm assembles it and before you try to mount it.

I'm using mdev, the embedded udev replacement from busybox. I suppose it 
doesn't open the array.

Would it make sense to have mdadm open the array after assembling it, or is 
that udev's job only ?

-- 
Regards,

Laurent Pinchart
