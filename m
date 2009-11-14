From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Help - Urgent!!!
Date: Sat, 14 Nov 2009 15:45:02 -0600
Message-ID: <20091114214504754.VURJ5263@cdptpa-omta04.mail.rr.com>
References: <19197.1188.481294.873723@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19197.1188.481294.873723@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, 'Debian mdadm maintainers' <pkg-mdadm-devel@lists.alioth.debian.org>
List-Id: linux-raid.ids

> > 	Should I stop the arraya nd re-assemble it with -vvv?
> >
> > 	Also, what about my question about the bitmap?  Should I delete it,
> despite
> > the fact mdadm says there isn't one, or should I attempt to add it
> again, or
> > should I wait until I do the checkarrray?
> >
> 
> There is nothing to delete.  Just try to add it again.
> Though I would really like to know why it hangs.  If that happens
> again, see if alt-sysrq-T shows anything useful.

	Well, it hasn't hung again, but now that I can catch my breath I can
provide a little detail.  As I mentioned before, the original hang occurred
when I first issued:

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65535`

	Mdadm complained about the bitmap chunk being an incorrect size.  I
don't know if it actually created a bitmap anyway using the default size, or
what, but I assumed the error meant the bitmap was not created.  Going on
this assumption, I immediately issued the command again, changing only the
bitmap chunk size:

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65536`

	That's when it hung.  I tried stopping the array, but I couldn't
umount the file system because it was dirty.  Any commands to mdadm - even
informational ones and even 

`cat /proc/mdadm`

	would cause the xterm to hang.  Even a shutdown would not work.  I
had to shut down  the server with the power switch.

	When the system booted, mdadm would not assemble the array.  I think
Neil has figured out why.  Subsequent attempts to assemble the array also
failed, at least in part because /dev/md0 had been created without the array
being active.  I deleted /dev/md0, but subsequent failed assembly attempts
again created the file.  Finally I deleted the file once again and then
assembled using

`mdadm -A /dev/sd[a-j]`

	and it worked, although the array was marked as dirty, and the first
attempt to access it caused a resync.  When the resync was done, I fixed the
"homehost" issue Neil had spotted and corrected /etc/mdadm/mdadm.conf to
show all 10 drives.  Finally, I added back the bitmap, and now everything
seems fine.  I rebooted the server, and it comes up with all 10 drives in an
assembled array with an internal bitmap.

