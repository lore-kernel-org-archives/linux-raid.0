From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Booting from a raid1 device ?
Date: Thu, 30 Oct 2003 10:22:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B207E1349@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael,

I think we agree, but do remember that the 'lifetime of the disk' is the
real question here, and the whole reason we are doing mirroring anyway.
When the disk fails and is swapped out with a replacement, the MBR also
has to be rewritten then, and we want that to be as automatic as
possible.

Andy

-----Original Message-----
From: Michael Tokarev [mailto:mjt@tls.msk.ru] 
Sent: Thursday, October 30, 2003 9:27 AM
To: Cress, Andrew R
Cc: donj@asaca.com; linux-raid@vger.kernel.org
Subject: Re: Booting from a raid1 device ?


[...snip...]

> You have to also have a working MBR on the redundant disk as well, or
> you'll never get to the loader if the first disk really fails.
Usually
> it is the loader's responsibility to set up (or at least verify) the
> MBR.  

Well.. not really.  Sure, working MBR should be on all disks involved.
But it is necessary to set it up only once on every disk, and forgot
about it.  "Standard" MBR that comes with MS-DOS, or any other similar
MBR code will work, and there's no reason to touch it during the whole
lifetime of the disk.

[...snip...]
