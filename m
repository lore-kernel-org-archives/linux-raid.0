From: Jeff Hill <jhill@hronline.com>
Subject: Removing a Raid Partition? How-to?
Date: Tue, 14 May 2002 18:05:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
References: <Pine.LNX.4.31L.02.0205141604120.12302-100000@linux2.gl.umb
 c.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.31L.02.0205141604120.12302-100000@linux2.gl.umb
 c.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oddly, it seems I can't change the partitions of a previously formatted 
raid disk.  When I use fdisk to repartition a drive previously formatted 
with the type set to Linux autoraid detect, I reboot only to find the 
autoraid partitions are still there. I have stopped the raid devices, but 
it seems I can't kill the persistent superblock. I tried reformatting with 
mke2fs and of course that failed to do the trick.

It doesn't seem like this should be difficult, but I've spent several hours 
trying this. Any suggestions appreciated.

Regards and thanks for a great program with mdadm.

Jeff Hill

