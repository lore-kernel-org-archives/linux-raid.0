From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Looking for the best way to do this
Date: Wed, 22 Jun 2011 20:20:08 -0500
Message-ID: <87.53.03893.7C4920E4@cdptpa-omtalb.mail.rr.com>
References: <4E00DF31.2020406@gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E00DF31.2020406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'maurice' <mhilarius@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of maurice
> Sent: Tuesday, June 21, 2011 1:13 PM
> To: linux-raid@vger.kernel.org
> Subject: Looking for the best way to do this
> 
> Good day, and thanks in advance for any ideas and advice.
> 
> I am working on a server.
> The server is normally in a remote location, not outside accessible by
> network,
> and there is no easy method to do backups on it.
> It is running Fedora 14
> 
> It has 2 hard drives at present, and there are 5 partitions  on each.
>  From this we have 3 RAID1 md devices.
> These are for /boot, /data and /

	Presumably the fourth partition is swap, and the fifth is...?

> I wish to add a 3rd disk, for enhancing the safety of the data.
> There is no space to add a 4th disk.
> 
> Things I thought of doing include:
> Add 3rd disk to make a 3 disk RAID1

	That's the easiest and most robust.

> Make a RAID10, missing one disk.

	No, I don't think I would do that.  If you need more storage, you
could fail one drive, create a 3 drive RAID5 array with one missing, copy
the data over from the remaining RAID1 member, and then make the remaining
RAID1 drive into the third member for the RAID5 array.  This is a bit less
robust than the 3 member RAID1 array, but gives you twice the storage.  If
you don't need the extra storage, go for the 3 member RAID1.  Whatever you
do, make an off-site backup of (at a minimum) /data.

> Which do you think is the better means to enhance data safety / chances
> of surviving a hardware problem?
> One of the above, or an other configuration?
> 
> And, assuming I want to preserve the existing data, what is the best way
> to do this?

	Like I said, make your backup, and then either add a 3rd member to
the RAID1 array or else fail 1 of the drives, create a RAID5 array with one
missing member from the new drive and the failed drive, copy the data from
the remaining live RAID1 drive to the RAID5 array, shut down the RAID1
array, and add the drive to the RAID5 array.  Since this system is going to
be bootable, you probably need to use 0.90 metadata for the /boot array.
The rest can be 1.x.

