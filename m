From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: Questions: understanding fail/remove steps from RAID1
Date: Sat, 12 Feb 2005 14:11:07 -0800
Message-ID: <420E7EFB.4000303@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been experiencing as-yet-undiagnosed kernel panics on a server
with two RAID1 arrays. (x86_64; 2.6.10 FC3 kernel; Promise SATA with
Seagate drives.)

After a recent panic and reboot, the two RAID1 arrays dropped their
member partitions from a certain drive (sdb).

Based on previous experience with simulated failures, I had expected
the devices to still be listed by name as part of the array, but as
failed/faulty. Instead, they were not listed in either /proc/mdstat
or 'mdadm --detail' output.

Were my expectations wrong -- is this by design?

Looking over /var/log/messages, there's no clear indication of a
specific time or reason the sdb partitions were dropped from the array.

Are raid array events logged somewhere else?

Thanks for any insights,

- Gordon
