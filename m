From: Neil Brown <neilb@suse.de>
Subject: Re: Partitions not recognized when auto-assembling array in
 initramfs
Date: Tue, 28 Dec 2010 08:04:08 +1100
Message-ID: <20101228080408.2d8ecada@notabene.brown>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com>
	<20101228072945.2141ac13@notabene.brown>
	<201012272135.48528.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012272135.48528.laurent.pinchart@ideasonboard.com>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Dec 2010 21:35:48 +0100 Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:


> > So something odd is happening, and more logs are needed to guess what.
> 
> I'll try to get more logs. In the meantime I've found something weird. If I 
> run mdadm --assemble --scan twice in a row, the partitions are correctly 
> created the second time.
> 
> The next problem will be that the array is created in read-only mode. mdadm --
> readwrite /dev/md126 doesn't help there, but echo active > 
> /sys/class/block/md126/md/array_state does.

The array is read-only because 'mdmon' is not running.  When mdadm assembles
the array it starts mdmon to monitor the array.  This is needed when the
array uses a metadata format that the kernel doesn't understand.
It is mdmon's job to switch the array to read-write

I cannot think why mdmon is not being started, unless maybe it doesn't exist
on the initramfs - it should be in /sbin.

The logs you sent show that the partitions aren't getting detected at all, so
it isn't the case that they get detected and then removed.

I don't remember exactly what triggers the partition detection.  Maybe just
opening the array device...
It is entirely possible that once you get the mdmon issue sorted out, the
other will disappear.

You could try

  mdmon md126 &

and see if that makes the array read/write and creates the partitions.
Also check with ps to confirm that mdmon isn't running.

NeilBrown


> 
> I forgot to mention that I'm running 2.6.36.5 with mdadm 3.1.4.
> 

