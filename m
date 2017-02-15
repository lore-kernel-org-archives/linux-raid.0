From: "G.raud" <graud@gmx.com>
Subject: mdadm: how to move superblock 1.0 on reduced components
Date: Thu, 16 Feb 2017 00:41:14 +0100
Message-ID: <20170215234114.GL28234@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I cannot find information about this topic on the web.

Reducing the size of the components of an md array keeps the superblock
1.0 at the same position (which avoids data corruption and maybe is
required for md to find it).  However how can one then reduce the size
of the underlying device without losing the superblock?

In an array with redundancy re-addind reduced components one after the
other is a rather safe solution, I suppose, but it is time consuming.
Would it be possible to update the superblock version by doing that,
either by mixing different superblock versions by giving --metadata with
--add or by modifying the partitions defining the re-added components so
that the new devices start at the right offset for a superblock 1.2 (and
later using the following solution, re-creating the array with the
original partitions and a 1.2 superblock at the right offset with
--data-offset)?

Re-creating all components after a reduction of the underlying devices
seems possible by using --assume-clean.  What to look for to avoid data
loss?

mdadm already supports enlarging a 1.0 component, which requires moving
the superblock, so the code to reduce one would probably not require
much efforts.  Could it be added in the future?

I would like to attempt to move the superblocks 1.0 manually, but I lack
some information:

1) Should the reserved space before the superblock be moved along?

2) Is there metadata inside a superblock 1.0 to update after the move
   (that another program would not correct automatically)?

3) How is the superblock detected?  Is there only one position possible
   for a given chunk size on a given component size?  Should the
   remaining (padding) sectors of the underlying device be zeroed?

Thanks
