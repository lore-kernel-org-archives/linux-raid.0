From: Ram Ramesh <rramesh2400@gmail.com>
Subject: What is the correct way of making image copy of a member disk in
 md array?
Date: Sat, 08 Nov 2014 19:44:20 -0600
Message-ID: <545EC6F4.7010007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a situation with one of my disks in /dev/md0. It does not play 
well in initial hardware detection after bootup. It works very reliably 
once it is detected. So I like to keep its image ready should it 
actually fail. If I add a spare to md0, this flaky disk gets kicked out 
immediately and I do not want that to happen.

  Following is a possible solution

 1. Add the new disk as spare (call it sdX).
 2. echo want_replacement on the flaky drive (call it sdY)
 3. When the copy completes and flaky drive becomes spare repeat the
    process in the opposite direction
 4. Remove  the new disk from md0 when it becomes spare.

Specifically, my questions are

 1. Is it possible to -re-add sdX after step 4?
 2. Is there a recommended/better solution for making image other than
    the one given above? If not,
 3. Can I skip steps 3 & 4 and simply re-add the flaky drive after step2
    completes ? I mean mdadm --remove sdX and --re-add sdY.
 4. If above step works, will there be a problem when I reboot with both
    sdX and sdY present?
 5. If a reboot is a no-no, is there another method available to keep
    the new disk (sdX) plugged in without being part of md0? I mean not
    even as a spare.

The reason for all this jumping through the hoops is that I want to keep 
only one spare across multiple md devices across multiple machines. I 
want it to be ready for the most likely job this spare will be needed 
(based on my hunch).

Kernel: Linux xxxxx 3.14-0.bpo.2-amd64 #1 SMP Debian 3.14.13-2~bpo70+1 
(2014-07-31) x86_64 GNU/Linux
mdadm: mdadm - v3.2.5 - 18th May 2012

Ramesh
