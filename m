From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID-5 using CLOOP devices
Date: Thu, 29 Dec 2005 16:52:32 -0500
Message-ID: <20051229215232.GA27346@lug.udel.edu>
References: <6d5bedd80512271108q6dda3d2ax23b226caba823caa@mail.gmail.com> <20051228023031.GA31926@lug.udel.edu> <6d5bedd80512280521v47711d7ejdf22cb60b7fc3b41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d5bedd80512280521v47711d7ejdf22cb60b7fc3b41@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 28, 2005 at 07:21:08AM -0600, Ewan Grantham wrote:
> The problem is that currently md doesn't think it's talking to a group
> of cloop devices, it thinks it's talking to "real" devices (cbod to be
> exact) that are hosting ext3 partitions.

Well, in a very good sense no block device is anymore "real" than
anything else.  As far as md knows, a block device is a block device.
Whether the actual backing storage is a disk or some software block
device is immaterial.

If your arrays are assembled via UUIDs, things will probably just
work.  If they are assembled via devices, you will probably have to
change the command line to assemble them.

The hitches with software devices are only in making sure that the
devices are active before assembling the array.  So for cloop, you'll
just need to start the devs before assembling your md.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
