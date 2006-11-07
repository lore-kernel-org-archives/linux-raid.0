From: David <lists@edeca.net>
Subject: Checksums wrong on one disk of mirror
Date: Tue, 07 Nov 2006 10:04:56 +0000
Message-ID: <20061107100456.v64wcs1zi80kcccc@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently installed a server with mirrored disks using software RAID.  
Everything was working fine for a few days until a normal reboot (not  
the first).  Now the machine will not boot because it appears the  
superblock is wrong on some of the RAID devices on the first disk.

The rough layout of the disks (sda and sdb):

  sdx1 (md0) - /
  sdx2 (md1) - /var
  sdx3 (md2) - /usr
  extended partition with swap
  sdx6 (md3) - /opt

The exact error is:

  "invalid superblock checksum on sda3
  sda3 has invalid sb, not importing!"

Booting into a live CD, mdadm -E /dev/sdaX shows that the checksum is  
not what would be expected for sda1,2,3 but is fine for sda6. All of  
the checksums on drive sdb are correct.

The state is "clean" for all partitions, working 2, active 2 and  
failed 0. The table for sdb1,2,3 shows that the first device has been  
removed and is no longer an active mirror.

What is the best way to proceed here? Can I somehow sync from the  
second disk, which appears to have the correct checksums? Is there an  
easy way to fix this that wont involve loosing the data?

Thanks.
