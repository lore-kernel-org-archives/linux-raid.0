From: Dan Egli <dan@eglifamily.dnsalias.net>
Subject: invalud argument when replacing disk of raid 5 set
Date: Fri, 07 Nov 2003 19:17:34 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FAC523E.3050509@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, this may be a smple question, but hear me out. I've looked and 
cannot find the answer anywhere.

I have a machine with a 3 disk raid 5 set. One of the disks has 
developed bad sectors in the parity block (I'm assuming it is in the 
block because badblocks /dev/hdb shows bad areas, badblocks /dev/md0 
does not), which causes it to randomly get kicked out of the set. I got 
a drive to replace it with today. It's not the exact same model, but 
it's the same physical dimentions (C/H/S & capasity are identical). It's 
just a little faster than the others, with a little more cache on the 
drive. But when I repalce the bad drive with the good drive, I get 
invalid arguments when trying to bring up the array. I don't get it. 
There is a perfectly valid linux partition on the drive, /dev/hdb1 which 
meeds the same specs as /dev/hdc1 and /dev/hdd1, but replacing hdb with 
a drive showing no bad blocks won't work.

Help?


The existing drives are IBM DTLA-305020 drives, and my replacemt is a 
DTLA-307020. Both show their physical dimentions as:

Capasity: 20.5GB
CHS: 16383/16/63

--- Dan





