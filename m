From: Daniel Brockhaus <joker@astonia.com>
Subject: Soft-/Hardware RAID Performance
Date: Wed, 19 Feb 2003 20:56:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20030219202741.027d3ec0@195.90.31.33>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I need to build a server for an application that does lots of small writes 
and some small reads. So far I've build the hardware side of the server, 
using an Adaptec 2100S RAID controller and five Fujitsu MAM3184MP. My 
original intention was to build a RAID 10 array (RAID0 on two mirror sets 
of two disks each with one spare). But performance was very poor with this 
setup. I used a custom benchmark which reads and writes 4K blocks in random 
locations in a 2GB file (this is very close to the actual application):

Test results for :

Cheap IDE drive: 50 writes/s, 105 reads/s.
MAM3184MP: 195 writes/s, 425 reads/s.

This is as expected. But:

Hardware RAID10 array: 115 writes/s, 405 reads/s.

Which is way slower than a single drive. Now the testing began:

Hardware RAID1: 145 writes/s, 420 reads/s.
Software RAID1: 180 writes/s, 450 reads/s.
Software RAID10: 190 writes/s, 475 reads/s.

Since write performance is more important than read performance, a single 
drive is still faster than any configuration using two or four drives I've 
tried. So the question is: Are there any tunable parameters which might 
increase performance? In theory, read performance on a two-disk RAID1 array 
should be almost twice as high as on a single disk while write performance 
should (almost) stay the same, and a two-disk RAID0 array should double 
both, read and write performance. So the whole RAID10 array should be able 
to manage 350 writes/s and 1600 reads/s. What am I missing?

Performance issues aside. If I go for the software RAID10: How can I 
configure the system to use the fifth drive as hot spare for both RAID1 
arrays? Is it save to add the same drive to both arrays (haven't tried it 
yet)? And would you say that software RAID is stable enough to use in a 
production system?

Thanks a lot,
Daniel Brockhaus 

