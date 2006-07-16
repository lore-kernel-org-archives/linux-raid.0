From: Sevrin Robstad <quackyo@start.no>
Subject: trying to "brute-force" my RAID 5...
Date: Mon, 17 Jul 2006 00:02:21 +0200
Message-ID: <44BAB76D.9070809@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have written some posts about this before... My 6 disk RAID 5 broke 
down because of hardware failure. When I tried to get it up'n'running again
I did a --create without any missing disk, which made it rebuild. I have 
also lost all information about how the old RAID was set up..

I got a friend of mine to make a list of all the 6^6 combinations of dev 
1 2 3 4 5 missing, and set it up this way :

"mdadm --create -n 6 -l 5  dev1 2 3 4 5 missing ; fdisk -l /dev/md0 ; 
mdadm --stop /dev/md0" .
But a "cat logfile | grep Linux" of the output of this script tells me 
that on no of these combination does it find a valid "type 83" partition.

shouldn't this work ???

Sevrin
