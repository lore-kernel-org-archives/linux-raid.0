From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Sun, 4 Oct 2009 23:59:41 -0500
Message-ID: <20091005045942600.WUNS18886@cdptpa-omta02.mail.rr.com>
References: <275143.15844.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <275143.15844.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I didn't use LVM, and don't trust layering of any technology.  My two-
> drive array was set up much as he recommended it: md1 - / (including
> /boot), md2 - swap, md3 - /home.  I am against any further fracturing of
> partitions, as modern disk drives have lots of space, and lots of parts
> becomes unmaintainable.

	Actually, I think for your situation, LVM might be a reasonable
solution.  Regardless, I don't particularly recommend using any partitions
at all.  I don't.  All of my arrays are on raw disks, and all of my file
systems use the entire unpartitioned array.  Again, there can be good
reasons for partitioning disks, but in your case I don't see any advantages.

> I will say that this system appears to be a performance problem for me, as
> I run MythTV on / and have my videos in /home.  When Myth is scanning to
> eliminate commercials it must frantically sweep between / and /home, and
> overall system performance is impacted.  I am working on putting / on a
> dedicated high-performance 2.5" drive and keeping my videos on the array
> as they're much too large to back up.

	You've said that before, but it is specious, as you are potentially
using more space to mirror them on a RAID array than you would by
implementing a backup array.  You don't have a separate backup, but they are
using more space on your proposed system than they would be with my proposal
for you.  I also rather expect in the long run it may be more of a
management hassle for you.  It's your decision, of course.

> What I know is that 'offset' will boot and fail over.  I don't know if
> 'far' will.  I also know that .90 will boot and fail over.  I don't know
> whether 1.x will.  When building the array I tried to use 1.2 (as I
> thought it was newest/best) but there was a bitch at the beginning of boot
> and it wouldn't boot (for other reasons) so I reverted to .90.  When I do
> it again I will likely use 1.0, given what I've recently learned here.

	Are you aware the .90 superblock limits the array to 28 devices,
total, and the individual device size cannot exceed 2T?  This is probably
not an issue for you right now, but in the not-so-distant future it could
easily become so.  3T drives are supposed to come out quite soon, and
easting up drives on each array the way you are using RAID10, 28 may start
looking like a small number before too many months have passed.  If you
insist on booting from the array, I suggest you look very carefully into the
superblock structure.  1.0 and 1.2 may serve you better than 1.1, depending
on exactly what you want to do and how you plan to do it.

	You also need to make sure the filesystem supports your needs in the
future.

> I am still confused about the benefits of far vs offset.  Keld (the
> developer) says that although offset is newer, it's not necessarily better
> than far, only more compatible.  I have not found any rigorous performance
> comparisons of far vs offset.
> 
> I am shocked to read that RAID10 is not expandable.  I will want to add
> disks in the future. I will want to add space, but not partitions.  Does
> this mean I'll have to completely rebuild the array?  Once your data gets
> to a certain size it becomes unmanageable to rebuild the array.

	Well, there's more than one way to skin a cat, of course, but
growing a RAID10 array through rebuilding is definitely a bit of a fiddle.
I know Neil was looking at including RAID reshaping on RAID10 arrays, but I
don't think it has been implemented.  Currently I think adding a drive is
only available on RAID 1, 4, 5, and 6, or at least so the man page says for
my copy of mdadm, which is 2.6.7.2.

	For this and other reasons, I really think you would be better
served in your situation to employ independent arrays, either RAID5, RAID6,
or LVM,  in the house and in the garage.  Of course you could then include
the two arrays in a RAID0 volume with write mostly.  Again, it's your
choice.
	

