From: Anton Altaparmakov <aia21@cantab.net>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Wed, 20 Nov 2002 10:03:26 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.SOL.3.96.1021120095120.2764A-100000@libra.cus.cam.ac.uk>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
Reply-To: Anton Altaparmakov <aia21@cantab.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Wed, 20 Nov 2002, Neil Brown wrote:
> I (and others) would like to define a new (version 1) format that
> resolves the problems in the current (0.90.0) format.
> 
> The code in 2.5.lastest has all the superblock handling factored out so
> that defining a new format is very straight forward.
> 
> I would like to propose a new layout, and to receive comment on it..

If you are making a new layout anyway, I would suggest to actually add the
complete information about each disk which is in the array into the raid
superblock of each disk in the array. In that way if a disk blows up, you
can just replace the disk use some to be written (?) utility to write the
correct superblock to the new disk and add it to the array which then
reconstructs the disk. Preferably all of this happens without ever
rebooting given a hotplug ide/scsi controller. (-;

From a quick read of the layout it doesn't seem to be possible to do the
above trivially (or certainly not without help of /etc/raidtab), but
perhaps I missed something...

Also, autoassembly would be greatly helped if the superblock contained the
uuid for each of the devices contained in the array. It is then trivial to
unplug all raid devices and move them around on the controller and it
would still just work. Again I may be missing something and that is
already possible to do trivially.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cantab.net> (replace at with @)
Linux NTFS maintainer / IRC: #ntfs on irc.freenode.net
WWW: http://linux-ntfs.sf.net/ & http://www-stu.christs.cam.ac.uk/~aia21/



