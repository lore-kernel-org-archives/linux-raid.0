From: "Filippo Carletti" <filippo.carletti@gmail.com>
Subject: RAID1 resync and read errors (loop)
Date: Fri, 26 Oct 2007 12:03:10 +0200
Message-ID: <dc4d04cc0710260303y2ffa13fatdd428b8df6be8a6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a way to control an array resync process?
In particular, is it possible to skip read errors?

My setup:
LVM2 Phisical Volume over a two disks MD RAID1 array
Logical Volumes didn't span whole PV, some PE free at the end of disks

What happened:
disk1 broke
I installed new disk1
and started sync from disk2 to disk1
but at 99.9% disk2 gave some read errors and the sync process started
again, over and over

I didn't notice errors on disk2 because they were in unallocated PEs
at the end of the disk.
The MD device spans the whole disk, while the LVs don't.

I'd like to complete sync ignoring read errors, then replace disk2.

I think this is a not-so-uncommon situation, leaving some PEs free for
future expansion is a good idea and errors go undetected until you
"use" those free areas.

Thanks.

-- 
Ciao,
Filippo
