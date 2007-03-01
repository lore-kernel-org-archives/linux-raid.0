From: Bill Davidsen <davidsen@tmr.com>
Subject: RAID0 to RAID5 upgrade
Date: Thu, 01 Mar 2007 18:12:32 -0500
Message-ID: <45E75DE0.6060900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have three drives, with some various partitions, currently set up like 
this.

  drive0    drive1    drive2

   hdb1      hdi1      hdk1
   \_________RAID1________/

   hdb2      hdi2      hdk2
  unused     \___RAID0____/
   200GB       100GB x 2

             hdi3      hdk3
             \___unused___/
                100GB x 2

What I want to have is 3 x 200 = 400GB RAID5.

I would like to avoid copying 200GB of data to another machine and back 
if I can do the conversion. Since mdadm does handle --level= with grow, 
I assume I have to create another RAID0 from hd[ik]3, copy the data 
there, delete the array using hd[ik]2, create a new RAID5 to use 
hd[bik]2, copy the data from the temporary array to the new RAID5 array, 
delete the hd[ik]3 partitions, grow the hd[bik]2 partitions, grow the 
array, and if I didn't miss a step be done :-(

Is there a better way? Copy over a network or restore are going to be 
very slow.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

