From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 30 Oct 2012 13:59:39 -0600
Message-ID: <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 30, 2012, at 12:30 PM, Curt Blank <curt@curtronics.com> wrote:
> 
> Right, and without TRIM to tell the SSD which page(s) are invalid the 
> garbage collection will never be able to do that so the garbage 
> collection will be carrying around and preserving invalid page(s) when 
> ever it does do something. Assuming there are invalid pages in the blocks 
> it is acting on. That to me seems inefficient and for that reason says 
> TRIM should be used? 

My understanding is that a modern consumer SSD works by copy-on-write for new or changed blocks, so this need for TRIM is not needed. The SSD is only writing data to "empty" or previously erased cells. The correlation between logical sectors and physical sectors is constantly adjusted, unlike on HDDs where this remapping tends to only occur with persistent write failures to a sector.

Case 1: A file is being overwritten, or modified in some way. The file system knows this file consumes, .e.g LBA's 5000 to 6000, and so it sends a write command to the SSD, in effect "write data to LBA 5000, 1000" ergo write a data stream starting at LBA 5000, for 1000 (contiguous) sectors. Obviously a file system might break up this file into multiple fragments, so this is simplistic.

The SSD doesn't actually do what it's told. It doesn't literally overwrite those LBA's, what it does is dereference them in its lookup. And remaps those LBA's to new empty cells, and writes your data there. Later, it can go back and do garbage college on those dereferenced cells when there are enough of them accumulated.

Case 2: A file is being newly written. The basic thing happens. It's possible the file system requests LBA's never before provisioned, or it requests LBA's from previously deleted files. 

Either way, the SSD writes to empty cells. The case where it needs to write to occupied cells is if it runs out of empty ones, i.e. like David Brown said, in a case where the disk is getting full and poorly provisioned this could occur.

It might also occur in some use cases where large files are being created/modified, destroyed, very frequently, such that the disk can't keep up with garbage collection. Maybe an example of this would be heavy VM usage with consumer SSDs. Why someone would do this I don't know but perhaps that's an example.


> As far as I understand TRIM, among other things, it allows the SSD to 
> combine the invalid pages into a block so the block can be erased thus 
> making the pages ready to be written indiviually and avoiding the 
> read-erase-modify-write of the block when a page changes, i.e. write 
> amplification.

It will do this with or without TRIM. TRIM simply is a mechanism for the file system to inform the SSD of this in advance, in the case of file deletions, where it may be some time before the SSD is informed those blocks are "free" when the file system decides to reuse those sectors.


> Even if it does a read-modify-write to a new block then 
> acks the write and does the erase after in the background it's still 
> overhead in the read-modify-write i.e. read a whole block, modify a page, 
> write a whole block, instead of just being able to write a page.


a.) Neglible.
b.) The file system does RWM at a block/cluster level anyway (typically this is 4KB).


Chris Murphy