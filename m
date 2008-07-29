From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Adding a bitmap, v 0.90 superblocks
Date: Tue, 29 Jul 2008 14:44:16 -0400
Message-ID: <20080729184416.GA7655@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to add an internal bitmap to my RAID1 array.  It uses
v 0.90 superblocks.

Reading the man page, I believe I do this with:

"mdadm --grow --bitmap=internal /dev/mdX"

correct?

How do I know how much space is available on the superblock when mdadm
will perform it's computation "to make best use of available space"?
I'm curious because perhaps I should change to 1.x superblocks in the
future (for non-bootable arrays).

Regards,
Richard
