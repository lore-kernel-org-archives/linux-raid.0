From: Nat Makarevitch <nat@makarevitch.org>
Subject: RAID10 far (f2) read throughput on random and sequential / read-ahead
Date: Fri, 22 Feb 2008 04:14:05 +0000 (UTC)
Message-ID: <loom.20080222T035556-308@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

'md' performs wonderfully. Thanks to every contributor!

I pitted it against a 3ware 9650 and 'md' won on nearly every account (albeit on
RAID5 for sequential I/O the 3ware is a distant winner):
http://www.makarevitch.org/rant/raid/#3wmd

On RAID10 f2 a small read-ahead reduces the throughput on sequential read, but
even a low value (768 for the whole 'md' block device, 0 for the underlying
spindles) enables very good sequential read performance (300 MB/s on 6 low-end
Hitachi 500 GB spindles).

What baffles me is that, on a 1.4TB array served by a box having 12 GB RAM (low
cache-hit ratio), the random access performance remains stable and high (450
IOPS with 48 threads, 20% writes - 10% fsync'ed), even with a fairly high
read-ahead (16k). How comes?!

