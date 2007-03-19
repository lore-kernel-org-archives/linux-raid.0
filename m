From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Raid1 replaced with raid10?
Date: Tue, 20 Mar 2007 00:25:19 +0100
Message-ID: <45FF1BDF.6060304@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just tried an idea I got after fiddling with raid10 and to my dismay 
it worked as I thought it will. I used two small partitions on separate 
disks to create a raid1 array. Then I did dd if=/dev/md2 of=/dev/null. I 
got only one of the disks reading. Nothing unexpected. Then I created a 
raid10 array on the same two partitions with the options -l10 -n2 -pf2. 
The same dd executed at twice the speed, reading _simultaneously_ from 
both drives. I did some bonnie++ benchmarking - same result - raid1 
reads only from a single disk raid10 from both. Write performance is 
worse (about 10% slower) with raid10, but you get twice the read speed.
In this light the obvious question is: can raid10 be used as a drop-in 
replacement for raid1 or there is a caveat with having the amount of 
disks equal the amount of chunk copies?

Peter
