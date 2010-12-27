From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Mon, 27 Dec 2010 21:35:48 +0100
Message-ID: <201012272135.48528.laurent.pinchart@ideasonboard.com>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com> <20101228072945.2141ac13@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101228072945.2141ac13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thank you for your answer.

On Monday 27 December 2010 21:29:45 Neil Brown wrote:
> On Mon, 27 Dec 2010 16:18:08 +0100 Laurent Pinchart wrote:
> > Hi everybody,
> > 
> > I've been struggling with a software RAID issue for several days now.
> > Before sending the computer back to the vendor and asking for real RAID
> > support, I'd like to try my luck here.
> 
> By "real RAID" I assume you mean "proprietary closed-source raid that is
> sold to you in an ROM" :-)

Fair enough :-)

> > The system as an Intel Matrix Storage SATA controller and two 250GB disks
> > on which I want to use a RAID1.
> > 
> > I've been able to create the array properly from a Gentoo installation CD
> > (this might be a detail, but it might also influence homehost values, so
> > I thought I'd mention it) with the metadata stored in IMSM format.
> > 
> > Assembling the array automatically from the installation CD works.
> > 
> > livecd ~ # mdadm --assemble --scan
> > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > mdadm: Started /dev/md/vol0_0 with 2 devices
> > 
> > livecd ~ # cat /proc/mdstat
> > Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> > md126 : active (auto-read-only) raid1 sda[1] sdb[0]
> > 
> >       244195328 blocks super external:/md127/0 [2/2] [UU]
> > 
> > md127 : inactive sdb[1](S) sda[0](S)
> > 
> >       4514 blocks super external:imsm
> > 
> > unused devices: <none>
> > 
> > livecd ~ # cat /proc/partitions
> > major minor  #blocks  name
> > 
> >    7        0      94664 loop0
> >    8        0  244198584 sda
> >    8       16  244198584 sdb
> >    8       32     998400 sdc
> >    8       33     998368 sdc1
> >    9      126  244195328 md126
> >  
> >  259        0    5242882 md126p1
> >  259        1    5242884 md126p2
> >  259        2  233709560 md126p3
> > 
> > So far, so good.
> > 
> > I've then created an mdadm.conf file with mdadm -E --scan
> > 
> > livecd ~ # mdadm -E --scan
> > ARRAY metadata=imsm UUID=480da1d0:8150f280:7dd8425d:bec99c46
> > ARRAY /dev/md/vol0 container=480da1d0:8150f280:7dd8425d:bec99c46 member=0
> > UUID=17e28225:34f7c425:eb78aece:05c29a40
> > 
> > livecd ~ # mdadm --assemble --scan
> > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > mdadm: Started /dev/md/vol0 with 2 devices
> > 
> > livecd ~ # cat /proc/mdstat
> > Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> > md126 : active (auto-read-only) raid1 sda[1] sdb[0]
> > 
> >       244195328 blocks super external:/md127/0 [2/2] [UU]
> > 
> > md127 : inactive sdb[1](S) sda[0](S)
> > 
> >       4514 blocks super external:imsm
> > 
> > unused devices: <none>
> > 
> > livecd ~ # cat /proc/partitions
> > major minor  #blocks  name
> > 
> >    7        0      94664 loop0
> >    8        0  244198584 sda
> >    8       16  244198584 sdb
> >    8       32     998400 sdc
> >    8       33     998368 sdc1
> >    9      126  244195328 md126
> >  
> >  259        0    5242882 md126p1
> >  259        1    5242884 md126p2
> >  259        2  233709560 md126p3
> > 
> > Still good so far. The /dev/md/vol0_0 device is now called /dev/md/vol0.
> > 
> > Copying the mdadm.conf file to initramfs and rebooting, the array is
> > correctly assemble with mdadm --assemble --scan
> > 
> > livecd ~ # mdadm --assemble --scan
> > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > mdadm: Started /dev/md/vol0 with 2 devices
> > 
> > livecd ~ # cat /proc/mdstat
> > Personalities : [raid1]
> > md126 : active (read-only) raid1 sda[1] sdb[0]
> > 
> >       244195328 blocks super external:/md127/0 [2/2] [UU]
> > 
> > md127 : inactive sdb[1](S) sda[0](S)
> > 
> >       4514 blocks super external:imsm
> > 
> > unused devices: <none>
> > 
> > However, no partitions are detected.
> > 
> > livecd ~ # cat /proc/partitions
> > major minor  #blocks  name
> > 
> >    8        0  244198584 sda
> >    8       16  244198584 sdb
> >    8       32     998400 sdc
> >    8       33     998368 sdc1
> >    9      126  244195328 md126
> > 
> > If I remove the /etc/mdadm.conf file from the initramfs image, the volume
> > is detected as vol0_0 instead of vol0 and the partitions are correctly
> > detected.
> > 
> > I don't understand what's going on there, and how I could fix it. Help
> > would be greatly appreciated.
> 
> That is very strange....
> It might help if you could provide the complete boot logs so I can see
> everything that happened leading up to the partitions not being there.  It
> would help me see if they were never created, or created then removed.
> 
> The command
>    blockdev --rereadpt /dev/md/vol0
> should re-detect the partitions for you, so you could try doing something
> with that as a temporary fix.
> 
> mdadm does sometime remove partitions, but only on things that it is about
> to include in an array, so it shouldn't ever remove the partitions
> on /dev/md/vol0.
> 
> So something odd is happening, and more logs are needed to guess what.

I'll try to get more logs. In the meantime I've found something weird. If I 
run mdadm --assemble --scan twice in a row, the partitions are correctly 
created the second time.

The next problem will be that the array is created in read-only mode. mdadm --
readwrite /dev/md126 doesn't help there, but echo active > 
/sys/class/block/md126/md/array_state does.

I forgot to mention that I'm running 2.6.36.5 with mdadm 3.1.4.

-- 
Regards,

Laurent Pinchart
