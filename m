From: "Peter Sangas" <pete@wnsdev.com>
Subject: 2 disk RAID1 need to replace a disk logging errors (use replace?)
Date: Wed, 8 Nov 2017 10:39:22 -0800
Message-ID: <004c01d358c0$e5ea50a0$b1bef1e0$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 2 disk RAID1 and one of the disks is logging errors.  Array is still redundant.  I read the Wiki, this lists postings and the mdadm man page and I believe it’s advised to perform a “–-replace” rather than a “fail/remove” in order to preserve redundancy but would be happy if someone can confirm before I do it.

To replace sdb with a sdc I run the following for each mdx???


mdadm /dev/md0 --add /dev/sdc1 --replace /dev/sdb1 --with /dev/sdc1


--------------------

mdadm - v3.3 - 3rd September 2013


cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 


md1 : active raid1 sda2[0] sdb2[2]
      14640128 blocks super 1.2 [2/2] [UU]
      
md0 : active raid1 sda1[0] sdb1[2]
      19514368 blocks super 1.2 [2/2] [UU]
      
md2 : active raid1 sdb3[2] sda3[0]
      454074368 blocks super 1.2 [2/2] [UU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

Thanks,
Pete


