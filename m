From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: how to use mkfs.ext3 "stride=" on LVM on RAID correctly?
Date: Thu, 28 Feb 2008 10:38:09 +0100
Message-ID: <47C68101.4020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, LKML <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

Lately, I had a serious performance problem on a 1.2 TB ext3 filesystem 
placed on LVM, which was placed on Linux RAID-5.

Luckily, it was possible to alleviate much of this problem by removing 
internal bitmap from RAID-5 and by using anticipatory IO scheduler.


As suggested earlier by Theodore Tso in "very poor ext3 write 
performance on big filesystems" thread on linux-fsdevel list, I should 
have used "mke2fs -E stride option to make sure all of the bitmaps
don't get concentrated on one hard drive spindle".


Although the fine mkfs.ext3 manual gives some basic information on how 
to do it if you place the whole filesystem on a RAID array, it is not 
clear to me how it should be done correctly if I want to create a ext3 
filesystem on LVM on RAID-5.

Any helpful hints?


-- 
Tomasz Chmielewski
http://wpkg.org
