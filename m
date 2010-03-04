From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Removing drives
Date: Wed, 03 Mar 2010 20:19:11 -0700
Message-ID: <4B8F26AF.7080308@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some time back I started setting up a couple of vdr computers with raid. 
The one with 3 500gb drives, I setup 2 raid 1 partitions with 1 spare fo 
boot and swap and used the rest of the 3 drives for a raid5 array. I had 
problems getting it to boot, and it was advised to change the raid 1 
arrays to 3 mirror which I did. Bu I got busy with other things and 
never tried to switch it to boot from the arrays. Since then I aquired a 
4th drive same size and model. I want to change md0/1 back to 2 drive 
mirrors and change md2 from raid5 to raid1 freeing up a drive which I 
then want use to with the new drive to create another raid1 array. 
Before I can install the new drive, I need to get it booting from md0 so 
I can remove the old ide drive.

I figure I need to shrink md0 and md1 and then fail the 3rd drive in 
each of those 2 arrays before changing them to 2 drive arrays? I find 
lots of stuff about adding drives, but not much about removing the 
drives or how to change them back to 2 drive arrays.

Once md0 and md1 are back to 2 drives and it's booting, then I'll 
install and format the new drive and copy the contents of md2 over. Then 
I need to remake md2 as a 2 drive raid1. Then copy the data back and 
i'll have 2 drives to make md3.
