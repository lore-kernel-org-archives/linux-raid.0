From: Wakko Warner <wakko@animx.eu.org>
Subject: Badblocks and degraded array.
Date: Wed, 25 Mar 2015 19:14:00 -0400
Message-ID: <20150325231400.GA9242@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Firstly, I'm not in need of assistance, just looking for information.

I had a system with 4x 500gb disks in raid 5.  One drive (slot 2) was
kicked.  I removed and reseated the drive (which is OK).  During rebuild, it
hit a bad block on another drive (slot 1) which it kicked.  Is it possible
that if there's no redundancy to not kick a drive if it has a bad block?

In the end, my solution was to create a dm target using linear and zero as
needed (zero where the bad block was) then a snapshot target ontop of that
since there was no possibility to write to that section that was a zero
target.  I had LVM on top of the raid and my /usr was the one in the bad
block.  Fortunately, no files were in that bad block.  I dumped the usr
volume elsewhere, removed all the mappings (md, dm, and lvm), assembled the
array again and dumped the volume back which corrected the bad sector.  All
this was done using another installation.

This system will be retired anyway so the data isn't really useful.  But
having the experience is.

On a side note, it seems that everytime I encounter a bad sector on a drive,
it's always 8 sectors.  Does anyone know if hard drives have been 4k
sectored longer than AF drives?  This disk is 512 physical according to
fdisk.  I've even noticed this on IDE drives.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
