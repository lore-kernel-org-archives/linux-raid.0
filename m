From: Matthieu Patou <mat@matws.net>
Subject: Random IO with md raid
Date: Sat, 05 Dec 2009 01:31:22 +0300
Message-ID: <4B198DBA.5000906@matws.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm reviewing one new server with a 3ware 9690 controller where I've got 
a couple of sata drives connected.

In order to see how software raid behave in comparaison with a the raid 
controller I setup 3 volume:

* 1 raid 1 volume of 2 1TB hard drive
* 2 single volume of 1 TB hard drive each

I assemble the 2 single volume in a raid 1 volume

Both are formatted in XFS mounted noatime and nobarrier.

Sequentials reads and writes are quite similar between software raid and 
3ware raid.

But when it comes to random writes and random reads I find something 
strange.

The memory is 1G so I made iozone use 2G file with 4k block

On 3ware (in operation by second)
Random read:  193
Random write: 1232

On md
Random read:  178
Random write: 361

First I am bit worried that I can manage to get such good random result 
with the 3ware card I guess I am seeing some cache effect (there is 256 
MB on the card)
Also I'm surprised that the software raid is not able to take advantage 
of this cache effect in the same proportion (1 to 4).

I've been searching internet for tips on raid tunning but it turns out 
it's mostly for sequential access (ie. like readahead).

Does anyone has an any idea ?

Matthieu.
