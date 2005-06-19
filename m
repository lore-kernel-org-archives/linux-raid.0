From: Aaron Botsis <aaron@blight.com>
Subject: raid5 endian question....
Date: Sun, 19 Jun 2005 01:14:29 -0500
Message-ID: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com>
Mime-Version: 1.0 (Apple Message framework v730)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm attempting to move a raid5 array from a big endian ppc machine to  
a little endian x86.
Upon trying to import the array, I get:
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc,  
got fc4e2ba9)

I assume this to be an endianess issue...
Is this a bug? Is just the magic number whacked? or are the  
superblock data structures too?

what's the best way to fix this?

Many thanks in advance.

-Aaron
