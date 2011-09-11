From: Bill Davidsen <davidsen@tmr.com>
Subject: Speeding inode access
Date: Sun, 11 Sep 2011 13:41:49 -0400
Message-ID: <4E6CF2DD.6000307@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have an unusual application which modifies multi-MB parts of large 
files and requires atime enabled for audit info. I am currently using 
ext4 with the journal on SSD. The data io spread over the array members 
nicely, but the inode io doesn't. Any thoughts on getting the inodes 
inode io faster?

My thought is to create a raid0 with a small chunk size over multiple 
drives, the existing raid6 with a large chunk size, and then concatenate 
them so the inodes are at the start in the fast portion. I can increase 
the number of inodes to take up the whole "fast" part and keep data in 
the large chunk portion. I am not crazy about using some brand-new type 
-f file system, but I'll listen to suggestions.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



