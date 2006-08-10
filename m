From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: RAID-10 and 4 HDDs - how many HDDs can break without loosing data?
Date: Thu, 10 Aug 2006 10:49:37 +0200
Message-ID: <44DAF321.7090204@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to set up RAID-10 on 4 400 GB drives, on a not-so powerful 
machine (600 MHz ARM, Thecus n4100) - to have a total of 800 GB storage, 
with some protection against a drive failure.

As the machine is not very powerful, I don't want to use RAID-5 nor RAID-6.


Previously, I would use RAID-0 on top of two RAID-1s:

     ----RAID0----
     |           |
   RAID1       RAID1
  |    |       |    |
HDD1 HDD2   HDD3 HDD4


With RAID-0 on top of RAID-1, with 4 drives, I would achieve:
- 100% chance of recovery if any single, one disk fails,
- 50% chance of recovery if any two disks fail.


Now with RAID-10 in the Linux kernel, what are my chances of recovering 
from a single and two disk failure?

        RAID10
  ------------------
  |    |      |    |
HDD1 HDD2  HDD3 HDD4

Is it also 100% if one disk fails, and 50% if two disks fail?

Or perhaps, with 4 drives, RAID-10 can survive any 2 disks failure?


-- 
Tomasz Chmielewski
http://wpkg.org
