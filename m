From: Wolfgang Denk <wd@denx.de>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Tue, 28 Dec 2010 20:00:04 +0100
Message-ID: <20101228190004.D0C084F0@gemini.denx.de>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com> <201012272235.45824.laurent.pinchart@ideasonboard.com> <20101228170542.2d55944e@notabene.brown> <201012281250.20838.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <201012281250.20838.laurent.pinchart@ideasonboard.com>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Laurent Pinchart,

In message <201012281250.20838.laurent.pinchart@ideasonboard.com> you wrote:
> 
> > If you are using udev, then something strange is happening.
> > 
> > If you aren't using udev, then you need to have something open /dev/md/vol0
> > after mdadm assembles it and before you try to mount it.
> 
> I'm using mdev, the embedded udev replacement from busybox. I suppose it 
> doesn't open the array.
> 
> Would it make sense to have mdadm open the array after assembling it, or is 
> that udev's job only ?

You may want to read the comments for this Fedora bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=597300

It appears that in my case the problem was caused by the drives being
used in a different setup before.  I just today found how I could work
around this issue in the Fedora ramdisk setup - maybe you use
something similar.

Now that I know what I have to look for I also understand why another
array has similar issues: here I see

	# blkid -o udev -p /dev/sdd
	ID_FS_TYPE=hpt45x_raid_member
	ID_FS_USAGE=raid

for one of the disks.  Does anybody know how to get rid of such
signatures as the "hpt45x_raid_member" here (without disturbin any
other data on the drive) ?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"It is easier to port a shell than a shell script."      - Larry Wall
