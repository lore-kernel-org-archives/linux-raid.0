From: Robin Bowes <robin-gmane@robinbowes.com>
Subject: error opening /dev/md2: No such file or directory
Date: Thu, 02 Dec 2004 18:03:45 +0000
Message-ID: <conlcb$14p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I suspect this is not an mdadm problem but I am hoping someone can point 
me in the right direction...

I was running Fedora Core 2 and upgraded to Fedora Core 3 but am having 
problems following the upgrade (it won't boot due to some kernel 
issues). So, I thought I'd try a fresh install.

I'm tring to create a RAID1 array from a couple of spare 1.5GB 
partitions onto which I can put the fresh O/S install.

I used this command:

# mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdc1 missing
mdadm: error opening /dev/md2: No such file or directory

I've used "missing" since the other spare partition is on /dev/sdf which 
is being RMA'd at the moment - guess what make it is :)

The new FC3 system is running udev with which I'm not familiar.

How can I create the /dev/md2 device?

Thanks,

R.

