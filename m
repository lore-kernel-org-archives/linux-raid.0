From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Mon, 27 Dec 2010 22:35:45 +0100
Message-ID: <201012272235.45824.laurent.pinchart@ideasonboard.com>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com> <201012272135.48528.laurent.pinchart@ideasonboard.com> <20101228080408.2d8ecada@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101228080408.2d8ecada@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Monday 27 December 2010 22:04:08 Neil Brown wrote:
> On Mon, 27 Dec 2010 21:35:48 +0100 Laurent Pinchart wrote:
> > > So something odd is happening, and more logs are needed to guess what.
> > 
> > I'll try to get more logs. In the meantime I've found something weird. If
> > I run mdadm --assemble --scan twice in a row, the partitions are
> > correctly created the second time.
> > 
> > The next problem will be that the array is created in read-only mode.
> > mdadm -- readwrite /dev/md126 doesn't help there, but echo active >
> > /sys/class/block/md126/md/array_state does.
> 
> The array is read-only because 'mdmon' is not running.  When mdadm
> assembles the array it starts mdmon to monitor the array.  This is needed
> when the array uses a metadata format that the kernel doesn't understand.
> It is mdmon's job to switch the array to read-write
> 
> I cannot think why mdmon is not being started, unless maybe it doesn't
> exist on the initramfs - it should be in /sbin.

Bingo! That solved part of the problem. Adding mdmon to initramfs now switches 
the array to read-write. Partitions detection still doesn't work though.

> The logs you sent show that the partitions aren't getting detected at all,
> so it isn't the case that they get detected and then removed.
> 
> I don't remember exactly what triggers the partition detection.  Maybe just
> opening the array device...
> It is entirely possible that once you get the mdmon issue sorted out, the
> other will disappear.
> 
> You could try
> 
>   mdmon md126 &
> 
> and see if that makes the array read/write and creates the partitions.
> Also check with ps to confirm that mdmon isn't running.

After adding mdmon to the initramfs image, the md126 array is correctly 
switched to active. ps reports that mdmon is running of md127 (the container), 
but not md126.

The partitions are still not created. If I run mdmon md126, I get

mdmon: md126 is not a container - cannot monitor

And the partitions are then created. Does that sound familiar ?

-- 
Regards,

Laurent Pinchart
