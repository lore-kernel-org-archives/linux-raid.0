From: Markus Falb <markus.falb@fasel.at>
Subject: md raid with lvm lv member
Date: Sat, 25 Aug 2012 12:53:41 +0200
Message-ID: <7EB03F37-8E7F-4855-A80F-ED10D2D61905@fasel.at>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I would like to ask a question about what kind of block devices one can use with md raid. Until now I only used Linux raid autodetect partitions as raid members.

I have a machine with 2 disks in a md raid 1

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13      104391   fd  Linux raid autodetect
/dev/sda2              14      182401  1465031610   fd  Linux raid autodetect

/dev/sda2 is a lvm physical volume and contains one volume group with plenty of unused space.

Now I got a SSD and I want to raid 1 the SSD with the existing rotating hard disks.
I think with --write-mostly this should give me SSD like read performance.

However, shrinking the lvm physical volume seems a little scary to me and I would like to avoid that. My idea was to put a Linux raid autodetect partition on the SSD together with a equally sized LVM logical volume. Would it work? Is it stupid? ( kind of I guess, the layering would be: partition - raid 1 of 2 harddisks - lvm - raid 1 with ssd and one lv - filesystem). I wondered about auto detection and performance.  And, would this setup be reliable?

Another variant of my idea was to pass through the ssd to the virtual machine (kvm) and do the raid 1 with ssd and virtual disk inside the guest.
--
Kind Regards, Markus Falb

