From: "Stephen C. Woods" <scw@seas.ucla.edu>
Subject: system hangs when failing a disk
Date: Thu, 27 Mar 2003 11:02:36 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200303271902.LAA30464@foothill.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   We're working on setting up a largish raid array, but the problem
also occurs with a small (3 disk raid 5) array.

   If a disk is failed under a heavy I/O load, where heavy can be
recreated by untaring a couple of large tarballs from and onto the
array, there is about a 2/3 chance that the entire array will freeze.
This freeze occurs with forcing a failure by unpluging (hot plugable SCA
disks) a disk, and also when the disk is failed with mdadm.

   When this happens the system becomes pretty much unresponsive (as in
it pings but you can't rsh in,  console login sometimes works and
sometimes doesn't but if you peek at /proc/<anything raidish> that dies
too.

  2.4.18-19.8.0 (Redhat 8.0)

   Any hints (other than "don't fail disks under heavy load.")?

-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
