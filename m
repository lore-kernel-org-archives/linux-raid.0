From: Farkas Levente <lfarkas@bnap.hu>
Subject: how to which to bigger disk (md can do it?)
Date: Sun, 16 Nov 2003 12:03:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FB75992.3020608@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
we've got a server with 3ware 7500-8 and 8 pieces of 120 GB maxtor hd 
and software raid-5. the 1TB disk is running out of the space so we 
decided to switch to 200 GB hard disks. unfortunately there is only one 
day (saturday) when we can turn off the machine. how we can do it in the 
fastest way?:
- put the 8 disk to another server and run rsync through two gigabit 
ethernet card. but it can takes more than a day to sync about 800GB.
- switch the disks one-by-one in the current server and leave linux's 
software raid to sync the data. in this case we only have to stop the 
system a few mintues per day and takes 8 days, but continous operation. 
does it possible? after I put all new hard disk the totel capacity will 
be (8-1)*200 GB or it will remain (8-1)*120 GB? since during the disk 
switch the total space is the smallest hd's*(n-1), but what happens when 
I put the last 200GB disk?
- dd (or somehow imageing) the one 120GB disk content to one 200 GB 
disk. if they are on the same ide bus (or better on the same 3ware 
controller) the cloning is much faster. can I do a
dd if=/dev/sda1 of=/dev/sdb1
if they are different size and after the dd the second will be 200 GB 
raid component?
- rsync between two local disk?
any other or better solution?
thanks in advance.
yours.

-- 
   Levente                               "Si vis pacem para bellum!"


