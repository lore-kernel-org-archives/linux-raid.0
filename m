From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 20:33:53 +0100
Message-ID: <20050109193353.GB9524@janus>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com> <20050108145228.GB26475@janus> <200501081749.32816.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501081749.32816.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 08, 2005 at 05:49:32PM +0100, maarten wrote:
> 
> > For one second I thought it's a clever trick but gut feeling tells
> > me the odds of losing the entire array won't change (simplified --
> > because the increased complexity creates room for additional errors).
> 
> No.  It is somewhat more complex, true, but no different than making, for 

Got it.

> However, IF during that 
> resync one other drive has a read error, it gets kicked too and the array 
> dies.  The chances of that happening are not very small;

Ouch! never considered this. So, RAID5 will actually decrease reliability
in a significant number of cases because:

-	>1 read errors can cause a total break-down whereas it used
	to cause only a few userland I/O errors, disruptive but not foobar.
-	disk replacement is quite risky. This is totally unexpected to me
	but it should have been obvious: there's no bad block list in MD
	so if we would postpone I/O errors during reconstruction then
	1:	it might cause silent data corruption when I/O error
		unexpectedly disappears.
	2:	we might silently loose redundancy in a number of places.

I think RAID6 but especially RAID1 is safer.

A small side note on disk behavior:
If it becomes possible to do block remapping at any level (MD, DM/LVM,
FS) then we might not want to write to sectors with read errors at all
but just remap the corresponding blocks by software as long as we have
free blocks: save disk-internal spare sectors so the disk firmware can
pre-emptively remap degraded but ECC correctable sectors upon read.

-- 
Frank
