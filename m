From: Richard Scobie <richard@sauce.co.nz>
Subject: Observations of a failing disk
Date: Tue, 28 Nov 2006 11:25:37 +1300
Message-ID: <456B65E1.20204@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a machine running Fedora 5, kernel 2.6.17-1.2187_FC5smp, with a 
pair of software RAID 1 arrays (WD 500GB RE2), RAID 0'ed together. Every 
14 days, one of the arrays has a "repair", (echo repair > 
/sys/block/mdX/md/sync_action),  run on it, to hopefully pick up and fix 
dead sectors.

Over the weekend smartd emailed to say that there were "10 Currently 
unreadable (pending) sectors" on /dev/sdc1.

mdstat showed this drive was still active in the array and this was the 
case after smartd notified 4 hours later that there were now 20 pending 
sectors.

After running a repair on the array, (confirmed by following resync 
progress in mdstat), smartd was reporting 21 pending sectors.

Thinking I had nothing to lose, I failed and removed the drive and ran a

dd if=/dev/zero of=/dev/sdc1 bs=1048576

and as can be seen from the periodic smartd reports while this was 
running, these sectors were fixed and smartctl -a now shows 0 pending 
sectors.

Nov 28 08:07:30 bozo smartd[3066]: Device: /dev/sdc, 21 Currently 
unreadable (pending) sectors
Nov 28 08:37:31 bozo smartd[3066]: Device: /dev/sdc, 11 Currently 
unreadable (pending) sectors
Nov 28 09:07:31 bozo smartd[3066]: Device: /dev/sdc, 1 Currently 
unreadable (pending) sectors
Nov 28 09:37:31 bozo smartd[3066]: Device: /dev/sdc, 1 Currently 
unreadable (pending) sectors
Nov 28 10:07:31 bozo smartd[3066]: Device: /dev/sdc, 1 Currently 
unreadable (pending) sectors

Curiously, the Reallocated_Sector_Ct only shows 2 instead of the 21 I 
would have expected.

Anyway, my biggest concern is why

echo repair > /sys/block/md5/md/sync_action

appeared to have no effect at all, when I understand that it should 
re-write unreadable sectors?

Regards,

Richard
