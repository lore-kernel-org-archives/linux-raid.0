From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Unable to stop array
Date: Sun, 7 Jun 2009 20:37:47 -0500
Message-ID: <20090608013744436.FBVG26412@cdptpa-omta03.mail.rr.com>
References: <953048308fa5f94ed5dfd3f2c37a3767.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <953048308fa5f94ed5dfd3f2c37a3767.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Sunday, June 07, 2009 6:02 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Unable to stop array
> 
> On Mon, June 8, 2009 4:52 am, Leslie Rhorer wrote:
> >
> > I am trying to stop one of my arrays for maintenance, but it won't let
> me.
> > I've un-mounted the filesystem, but I still get the following:
> >
> > mdadm: fail to stop array /dev/md0: Device or resource busy
> >
> > How do I get the array to be free so I can stop it?
> >
> 
> Find out what is keeping it busy.
> This is not always as easy as you might like.
> You could:
> 
>  lsof /dev/md0
>          to see if any process have it open

Nope

>  grep md0 /proc/mounts
>          to see if it is still mounted

Nope

>  grep md0 /proc/swaps
>          to see if it is in used for swap

Nope (this drive never had a swap partition on it)

>  grep md0 /proc/mdstat
>          to see if it is included in some other md array

Nope, just this one.  It returns:

Backup:/etc/gadmin-rsync/scripts# grep md0 /proc/mdstat
md0 : active raid5 sde[7](S) sdf[0] sdd[5](F) sdc[4] sdb[3] sda[2] sdg[1]

>  ls -l /sys/block/md0/holders /sys/block/md0/*/holders
>          to see if dm is using it at all

It shouldn't be:

Backup:/etc/gadmin-rsync/scripts# ls -l /sys/block/md0/holders
/sys/block/md0/*/holders
ls: cannot access /sys/block/md0/*/holders: No such file or directory
/sys/block/md0/holders:
total 0

>  grep loop /proc/partitions
>          to see if there are any loop devices.  If there are,
>          one could conceivable be using it.

Nope.

> I cannot think off hand of anything else that might be using the
> device.

It seems to me this is reproducible whenever the mount is used for an NFS
share.  Even after unmounting the share on the remote system, the umount
command won't release the mount on the local system unless one issues the -l
switch, and then the array still won't stop.

