From: Marc MERLIN <marc@merlins.org>
Subject: Can reading a raid drive trigger all the other drives in that set?
Date: Tue, 28 Jun 2011 09:22:05 -0700
Message-ID: <20110628162205.GG20420@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have ext4 over lvm2 on a sw raid5 with 2.6.39.1

In order to save power I have my drives spin down.

When I access my filesystem mount point, I get hangs of 30sec or a bit more
as each and every drive are woken up serially.

Is there any chance to put a patch in the block layer so that when it gets a
read on a block after a certain timeout, it just does one dummy read on all
the other droves in parallel so that all the drives have a chance to spin
back up at the same time and not serially?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
