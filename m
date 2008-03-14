From: "Cody" <cody@mochamail.com>
Subject: Multiple partitions on the same disk
Date: Fri, 14 Mar 2008 15:41:09 -0700
Message-ID: <380-22008351422419859@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

I have an 8-disk raid5 array (each is 500GB SATA).  The first disk
sda1 shows bad sectors (from smartd).  mdadm reports that the array
is fine, but I want to replace or re-add the drive.  Should I replace
it?  It's the oldest drive in the array (the disk is ~3 years old).

Also, can I replace it with a 1TB disk and add it as two partitions
(assuming that 2 partitions of the correct size can be created)?  I
have read of RAID schemes that involves partitioning each disk into
smaller increments, but this seems inherently unsafe to me unless
mdadm understands that two partitions are on the same device and
organizes parity accordingly.

Thank you for all your time and effort, 
Cody

