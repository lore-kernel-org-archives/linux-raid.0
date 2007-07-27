From: Max Amanshauser <linux-raid@lambdalifting.org>
Subject: Homehost suddenly changed on some components
Date: Fri, 27 Jul 2007 20:49:23 +0200
Message-ID: <A2BCA40B-B212-4ECD-BEE1-29C50A7A13ED@lambdalifting.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

After growing my RAID-5 from 8 to 10 devices, everything worked  
smoothly for a day. Then I rebooted into another kernel, still with  
the old mdadm.conf. The array did not assemble correctly, so I fixed  
mdadm.conf by correcting the number of devices. After rebooting once  
again four components had a different UUID, the homehost part is  
different. I am not aware that the machine's hostname has ever changed.

Six devices look like this: http://phpfi.com/252263
Four devices look like this: http://phpfi.com/252264

Since then assembling fails. Only six devices are added.

It's worth mentioning that the four rogue devices all are on the same  
controller, which worked flawlessly for two years.
lspci output: http://phpfi.com/252755


I am most concerned with repairing the UUID so the array assembles  
again. I tried several tricks with mdadm's --assemble --update flag,  
but to no avail. Everything I tried aborted with:

mdadm: superblock on /dev/hde1 doesn't match others - assembly aborted


Tried both mdadm v2.6.2 and v2.5.6. The system is an Ubuntu Feisty  
Server, growing was done with a custom 2.6.22 kernel, stock kernel is  
2.6.20.

Current mdadm.conf: http://phpfi.com/252752
Old one only differs in number of devices for md0.

-- 
Regards,
Max Amanshauser.


