From: Darryl Barlow <darrylb@iprimus.com.au>
Subject: Initrd, Software Raid and Failure to Mount Root FS
Date: Mon, 22 Sep 2003 08:57:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200309220857.32744.darrylb@iprimus.com.au>
Reply-To: darrylb@iprimus.com.au
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a description of a solved problem which may be of help to others.

I created a raid0 array on md0 intended to boot from a small non-raid boot 
partition.  I copied the contents of my old root partition on hda1 to md0, 
changed fstab and set up lilo to boot off the array, but found that no root 
file system was recognised.

It turned out that the problem was lack of support for software raid in my 
initrd file system.  I compiled and installed my kernel (Debian 2.4.22 using 
make-kpkg) whilst hda1 was the root filesystem.  The problem was easily 
rectified by creating and installing a new initrd.img using mkinitrd but 
specifying the root filesystem as /dev/md0.

It seems that initrd can be a trap for some newcomers to raid.
-- 

