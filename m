From: Alexander Junghans <alexander@leukefeld.com>
Subject: Raid 5 Superblock redundant?
Date: Mon, 09 Sep 2002 14:26:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D7C9369.7010802@leukefeld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
first of all thanks for the Raidsupport in the Kernel : -> using it for 
Years!

I have a general question about the implementation Raid 5. It happents 
me twice that one of a 3 Disk Raid 5 faild.
After new installing the faild drive the system has to read the complete 
2 disks to rebuild the 3.
But there will be also a bad block, so the system will kick the 2. Disk 
and the Raid will fail.

Now the Question:

If I would give you 3 Blocks of a Raid 5 same Position differend Disk 
could you tell me which is worg?

A + B +C = Data
Simpy fake A
(A) + B + C =Data
Without knowing the superblock that a has failed.

The idea behind this ist to make a raid 5 readable with some faid Blocks 
on any drive with the fact that
no more than 1 Block on each "slide" is down.
Block 1 A   + B + C = O.k.
Block 2 (A) +B + C = O.k.
...
Block 8 A + (B) + C = O.k.
-------------------------------
All Data O.K.

I would love to have a mode of Raid 5 where no drive is kicked and all 
data are O.K, just for saving the Data.
Would this tecnially possible?

Thanks.

