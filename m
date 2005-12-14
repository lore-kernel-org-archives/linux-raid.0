From: "Callahan, Tom" <CallahanT@tessco.com>
Subject: RE: resize2fs failing--how to resize my fs?
Date: Wed, 14 Dec 2005 15:45:19 -0500
Message-ID: <0481A62A3E95A044AC20A1A45899645C06B02F45@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "'mjstumpf@pobox.com'" <mjstumpf@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Was this resize done while the FS was mounted?

Thanks,
Tom Callahan

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Michael Stumpf
Sent: Wednesday, December 14, 2005 3:33 PM
To: linux-raid@vger.kernel.org
Subject: Re: resize2fs failing--how to resize my fs?


Michael Stumpf wrote:

> I get this from the latest stable resize2fs:
>
> [root@foo parted]# resize2fs /dev/my_vol_grp/my_log_vol
> resize2fs 1.38 (30-Jun-2005)
> Resizing the filesystem on /dev/my_vol_grp/my_log_vol to 488390656 
> (4k) blocks.
> Killed
>
> Parted (again, latest stable) tells me the following:
> Using /dev/mapper/my_vol_grp-my_log_vol
> (parted) resize 1 0 
> 100%                                                 No 
> Implementation: This ext2 file system has a rather strange layout!  
> Parted can't resize this (yet).
> (parted)
> Similar results from ext2resize/ext2online.  This is an ordinary ext3 
> fs, living inside an LVM2 that has already been increased to 
> accomodate (used all free extents)..  I've resized it down and up 
> before, though it is possible I am resizing it larger than it has been 
> before (1.8TB).
> Not sure what's up.  Any advice welcome; my research in this has me 
> getting a bit nervous about lvm2 bugs causing loss of data.  While I 
> want a single resilient (via raid 5) volume, I may be willing to ditch 
> a whole layer of software (lvm2) to get some security.


Surprised noone has hit this before.  It turns out that somehow my swap 
space disappeared in a system migration.  This became more obvious as I 
explicitly tried to extend the fs to a lower limit (438390656), where 
resize2fs worked for a while, then informed me that it couldn't allocate 
some memory.

Add 512mb of swap and problem solved.. never used more than ~100mb of 
swap (256mb main memory).

Hope this helps someone.



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
