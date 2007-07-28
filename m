From: "jeff stern" <jas.61803+lr@gmail.com>
Subject: Re: how to deal with continuously getting more errors?
Date: Fri, 27 Jul 2007 20:55:14 -0700
Message-ID: <98d279bf0707272055x66fd34aai43710236a67e7da5@mail.gmail.com>
References: <98d279bf0707141115m14308e64s50f6517b2e1aef5c@mail.gmail.com>
	 <18078.41187.752326.634975@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18078.41187.752326.634975@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks for responding, justin and neil.. and for your suggestions.

well, i tried neil's suggestion.. see my info, below.. i'd be grateful
for any suggestions. thank you.

On 7/18/07, Neil Brown <neilb@suse.de> wrote:
> On Saturday July 14, jas.61803+lr@gmail.com wrote:
> >
> > EXTENDED DESCRIPTION OF PROBLEM
> >
> > i first noticed this problem when i downloaded the fedora core 7 .iso,
> > and did a checksum on it, and it didn't match. with a little more
> > investigating, i found that i could make a copy of any large file on
> > disk, and its copy would sometimes match, sometimes not.
> >
> > here is a typical session:
> > ------------------------------------------------------------------------------------------
> > $ cp F-7-i386-DVD.iso F.iso
> > $ cmp F-7-i386-DVD.iso F.iso
> > F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> > $ cmp F-7-i386-DVD.iso F.iso
> > $ cmp F-7-i386-DVD.iso F.iso
> > F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> > $ cmp F-7-i386-DVD.iso F.iso
> > F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> > $ cmp F-7-i386-DVD.iso F.iso
> > F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> > $ _
> > ------------------------------------------------------------------------------------------
>
> This clearly indicates a hardware problem.
> You tried in /tmp and didn't get this sort of result, so it probably
> isn't RAM/CPU.
> Next step is to break the raid1, mount each drive as a separate
> filesystem and do the same test on each filesystem.
> If one works and the other fails, then it must be something specific
> to the faulty device.  If they are on the same controller, it must be
> drive or cable, so swap cables and try again.
> If they are on different controllers, try swapping controllers too.

well, i got the wierdest behavior. i did break the raid1 system into 2
drives. again, no instructions i could find in the HOWTO on how to do
this, so i just tried commenting out the line in /etc/fstab for the
/dev/md0 raid drive, and rebooting..

however, attempting to manually mount each drive separately gave me an
error saying wrong partition type. so i had to use /sbin/fdisk to
manually change the partition's system id from 'fd' (linux software
raid) to '83' (linux ext2/3) on each of /dev/sde1 and /dev/sdf1.. then
i could mount them.

once i mounted each drive, i tried cp'ing a large file (again,
F-7-i386-DVD.iso) and then cmp'ing the new one to the original 5
times. i did this whole cycle 5 times. guess what? ***0*** errors.
perfect cmp's. and i did this on BOTH drives. no problems at all when
they are mounted separately.

so what could THIS mean? they don't work together in raid but they do
separately? how could this be?

> If both filesystems show the same problem, it must be something
> common, maybe the controller.  Try to find an alternate controller to
> test with.  Narrow it down to the faulty component, and replace it.
>
> >
> >
> > furthermore, i discovered that there was a way to fix them (i.e.,
> > "sync" the drives). however, this fixing procedure came with a caveat.
> >  this caveat was something that i should have realized the importance
> > of in the first place: that a RAID 1 system with only two drives is
> > going to have a problem when repairing. the problem is that when
> > sync'ing the drives, whenever a mismatch is found, a decision must be
> > made as to which drive has the correct data: drive 1 or drive 2? and
> > that apparently, it's just a toss-up, and the repair program just
> > picks randomly.
> >
> > "WHAAAAT????????????"
> >
> > yeap. so, it's really better to either go with RAID 5, or to have a
> > RAID 1 system with 3 or more disks.
> >
> This is not true at all.
> If the difference is due to the drive subsystem returning bad data
> (rather than indicating a read error), then no RAID system is safe.
> If the difference is due to the kernel writing different data to the
> two drives (as happens sometimes on swap or with memory-mapped files),
> then both copies of the data are equally correct, and there isn't
> really a problem.
>
> NeilBrown
>


-- 
"the difference between driving a car and climbing onto a motorcycle
is the difference between watching TV and actually living your life"
(Dave Karlotski, "Season of the Bike",
http://motorcycleinfo.calsci.com/ and http://the751.tri-pixel.com/)

http://www.youtube.com/watch?v=yeMgEuf30G4
