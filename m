From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Automatic drive partitioning
Date: Sat, 8 Oct 2005 17:58:50 +0200
Message-ID: <200510081758.50918.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

is there a tool that can copy a partition table from one drive
and adapt it for another drive?

In an ideal world both source and destination drive share the same geometry.
The partition table could easily be copied using sfdisk.

But let's assume the geometry mismatches (RAID1 configuration
using drives from different brands). The destination partitions
have to be computed to match the source drive as close as possible.

What's this all for you might ask?
If one disc in a RAID1 array (without a preconfigured hot spare) fails,
I want to plug in a replacement disc and the rest should be handled
by some automatic system (partition the drive, hot-add it afterwards).

So, is there a tool that can copy and adapt partition tables?

Cheers,
Thomas
