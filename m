From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Can't expand linear RAID on top of 2 x RAID1
Date: Fri, 22 Jun 2012 20:41:33 +1000
Message-ID: <4FE44BDD.302@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have expanded my system over time, I started with 2 x 2TB drives in
RAID1 (md2)

I then added 2 x 750GB drives, configured as RAID1 (md1)
Then created a third raid (md3) as linear with the md2 + md1

Finally, I've upgraded the 2 x 750G to 2 x 1TB drives (one at a time).

I then did a mdadm --grow to expand the RAID1 from 750G to 1TB

The problem I am having is that I can't expand the linear (md3) array to
grow the extra 250G of space.

Could anyone suggest how I might be able to get the extra 250G of space
to become available?

keep:~# cat /proc/mdstat
Personalities : [raid1] [linear]
md3 : active linear md2[0] md1[1]
      2686081193 blocks super 1.2 0k rounding
     
md1 : active (auto-read-only) raid1 sdb1[2] sdd1[3]
      976758977 blocks super 1.2 [2/2] [UU]
     
md2 : active (auto-read-only) raid1 sda1[0] sdc1[2]
      1953510841 blocks super 1.2 [2/2] [UU]
     
unused devices: <none>

keep:~# mdadm --grow /dev/md3 --size=max
mdadm: component size of /dev/md3 has been set to 0K

There is nothing logged for dmesg after the above command, no change to
/proc/mdstat.

I have tried a reboot with no change either.

Thanks for any assistance, I'd really appreciate it.

Regards,
Adam
