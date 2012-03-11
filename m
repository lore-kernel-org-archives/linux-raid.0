From: Wiliam Colls <william.colls@rogers.com>
Subject: Can't Boot from /dev/md0
Date: Sun, 11 Mar 2012 19:45:01 -0400
Message-ID: <4F5D38FD.4080803@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Ubuntu 10.04 server, patched to date.

This machine is configured to boot from a Raid1 array. The partitions 
are located on /dev/sdb1 and /dev/sdc1, the boot partition is located on 
/dev/sda1. This configuation has worked well for some time, but after a 
recent shutdown for maintenance, which did not involve any of the 
partitions, the machine refuses to boot. The sequence hangs very shortly 
after startup, and eventually errors out with the message /dev/md0 not 
available. and drops into the Busybox shell.

After booting from a live rescue CD, and examining the partitions, they 
are all intact, and clean. They rescue CD was able to assemble the array.

Not sure where to go from here. Any Suggestions will be greatfully received.

William.

PS. I am sure that I read some recent discussion on a very similar 
problem, but I can't find that material now. If anyone has a link, it 
also be greatfully received.

-- 
I know that you believe that you understand what you think I said, but I 
am not sure that you realise that what you heard was not what I meant.
