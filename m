From: Ferenc-Jan <ferenc@avz.xs4all.nl>
Subject: create raid5 with missing disk; not possible?
Date: Fri, 14 Jan 2005 21:35:02 +0100
Message-ID: <41E82CF6.2080203@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I tried to create a raid5 set with 3 partitions and one missing device:

mdadm -C /dev/md1 -R -l5 -n4 /dev/hda3 /dev/hdc3 /dev/hdd3 missing

Later I want to add the fourth device with mdadm /dev/md1 -a /dev/hdb3. 
But this becomes a spare and I always end up with the missing drive in 
sync, mdadm -D /dev/md1:

<snip>
3       0        0        0      sync

I want to do this so I can use hdb to transfer data from an harddisk to 
the raid5 set. Maybe this is only possible with Raid 1 sets?

cheers

Ferenc
