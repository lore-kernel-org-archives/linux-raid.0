From: Matt E <mgeusenet@yahoo.com>
Subject: Raid 5, Not Detected At Startup
Date: Tue, 8 Jul 2003 14:48:06 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030708214806.48193.qmail@web20421.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All!

I've created a RAID-5 Array on my system, and it isn't
detected at startup.  Reading the software RAID HOWTO
I see that I have to specify a partion type to get
auto detection to work.

However, I never made partitions on the disk, I just
used mdadm to allocate the whole disc (hde,hde,etc.)
for the RAID array.

Hence, there is no partition table on the disk, and I
can't change the partition type.

I thought about removing one disk from the array,
creating a single partion, setting it to be the
correct type, then hot adding it to the array, allow
the array to sync, stop the array and the repeat the
process for the other 3 disks, which would give me
partiton types on all 4

Will this work with out blowing away my data?  Is
there a better way to do it?  

I realize that mdadm --assemble --scan will build the
array, but I'd like it to be detected at boot, without
mucking around with init scripts.

Cheers! 

__________________________________
Do you Yahoo!?
SBC Yahoo! DSL - Now only $29.95 per month!
http://sbc.yahoo.com
