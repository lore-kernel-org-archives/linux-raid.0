From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: md questions [forwarded from already sent mail]
Date: Sat, 24 Jan 2004 13:23:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401241823.i0OINOi27341@dns1.watkins-home.com>
References: <200401242023.45079.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401242023.45079.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From "mdadm --detail /dev/md2":
Persistence : Superblock is persistent

From "sfdisk -d /dev/sdc":
/dev/sdc1 : start=       63, size= 35535717, Id=fd, bootable

Maybe it's because RedHat uses modules for the RAID5?
Don't know, but once I caused the drive names to change the arrays would not
start.  The error messages stated the stuff like "sdc is now sdd".  I don't
recall the exact message.  But I do know mdadm worked fine once I configured
the file mdadm.conf.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maarten van den Berg
Sent: Saturday, January 24, 2004 2:24 PM
To: linux-raid@vger.kernel.org
Subject: Re: md questions [forwarded from already sent mail]

On Saturday 24 January 2004 17:27, Guy wrote:
> >All of the above ;-) No seriously, it sounds like a problem with the
> >hardware
> >somewhere along the line. Can you test the array on the OLD motherboard,
> > by
> >
> >just plugging everything in ?  Also, if you're using persistent
> > superblocks
> >
> >and type=0xFD, messing with the order in which the drives are attached /
> >recognized should not matter. It is confusing, but the array should
> >nonetheless assemble itself perfectly. At least in my experience.
> >
> >Maarten
>
> RedHat used mkraid and raidstart.  I have problems starting my arrays. 
> Even by hand using raidstart, but mdadm has no problems.  The problem is

Read my lines above about "persistent superblock" and type=FD again.
If you had used that you would _not_have_ to start the array since the
kernel 
will do this automatically for you. I'm sure this is really extensively 
documented so I wonder how you could have missed that.
I any case, if you leave it up to the kernel you won't have to worry about 
drive order, it is automatically recognized.  Whether you use mkraid or
mdadm 
has nothing to do with it, albeit the latter is better.

> related to the drive order.  It seems raidstart "knows" which disks are in
> the array.  If their names change, game over.  I upgraded the firmware on
a
> SCSI card, now the order that the system "sees" the SCSI cards has
changed,
> so the disk names are different.  Someone tell RedHat to use mdadm!!

Again, this has nothing to do with it. Read up on what I said about type=FD 
and persistent superblocks.

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


