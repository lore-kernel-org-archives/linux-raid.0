From: Michael Muratet <muratetm@gmail.com>
Subject: Add disks and convert level 0 to level 5
Date: Wed, 10 Sep 2014 11:15:24 -0500
Message-ID: <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
References: <loom.20140831T143354-68@post.gmane.org> <20140901083137.4772c8c5@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140901083137.4772c8c5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a two-disk RAID0 system that is working splendidly, thanks to the list for the help.

I managed to get my hands on more identical disks and since I have the disks and because I'm adding precious data, I'd like to add two more disks and grow to RAID5.

I have partitioned the two new drives to type 'fd', /dev/sde and /dev/sdf

I believe the command to accomplish the change is this:

mdadm /dev/md0 --grow --level=5 --add /dev/sde /dev/sdf

Following the old adage "measure twice, cut once", is this syntax correct? Is there any danger of data loss in such a conversion?

Thanks

Mike