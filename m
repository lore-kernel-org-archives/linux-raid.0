From: Adam Luter <luterac@bellsouth.net>
Subject: Re: Filesystem did not grow with my RAID 5 array
Date: Tue, 22 Oct 2002 09:46:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021022144657.GD25163@smeagol>
References: <200210221632.09276.jonas.nickel@tu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210221632.09276.jonas.nickel@tu-berlin.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You need to use a e2fs resize program in addition to the raid reconf
program.  The latter only changed the size of the device (i.e.
/dev/md0), and the former will change the size of the filesystem -on-
the device to fill the new size.

-Gryn (Adam Luter)

On Tue, Oct 22, 2002 at 04:32:09PM +0200, Jonas Nickel wrote:
> Hello,
> 
> I used raidreconf to expand a RAID 5 array with three disks (no spares) to one 
> with four disks (no spares). The tool seemed to work fine, a check with 
> 
> e2fsck -f /dev/md0 
> 
> showed no errors. However, a 
> 
> df  .
> 
> in the directory of the array still shows the old size. Did I miss anything 
> obvious and how do I expand the filesystem to the whole array?
> 
> Thanks in  advance,
> 
> Jonas Nickel
