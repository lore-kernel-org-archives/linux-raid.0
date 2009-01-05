From: "hank peng" <pengxihan@gmail.com>
Subject: Are there some alignment settings when creating filesystem on RAID5 array which can improve performance?
Date: Mon, 5 Jan 2009 09:07:36 +0800
Message-ID: <389deec70901041707l1613a8e8jb6a6a3fbba57ea91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, everybody:
I have a machine and centos 5.2 installed on it. I have created a
RAID5 array with five SATA disks, then I create LVM on this array.
#pvcreate /dev/md0
#vgcreate myvg /dev/md0
#lvcreate -n mylv myvg
As you see, I want to use XFS or ReiserFS on "mylv" volume. I wonder
if there are some alignment settings when creating such file systems
so that a better R/W performance can be achieved. Thx in advance.


-- 
The simplest is not all best but the best is surely the simplest!
