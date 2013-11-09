From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Sat, 9 Nov 2013 17:49:43 -0500
Message-ID: <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <527E8B74.70301@shiftmail.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'joystick' <joystick@shiftmail.org>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


From: joystick [mailto:joystick@shiftmail.org] 

[ .. ]

Hi,

> 1) It might be Grub writing state data to one device only during boot. IF
the machine was rebooted at least once prior to check.
The checks (multiple) had occurred after the reboot, last uptime (was ~40+
days)-- also using LILO here with the checks running once a week.

> 2) Earlier discussions on this list suggested that it might be a write
buffer becoming invalid during write because a temporary file being written
> has been deleted in the meantime and the buffer reused with different
content even if the buffer was still in-flight for the write. If this is 
> true, the region with mismatches would belong to unallocated space on the
filesystem so would be harmless. To confirm this, one in your 
> situation should write zeroes to a new file so to fill the filesystem,
then remove the file, just prior to the check or repair
> dd if=/dev/zero of=emptyfile bs=1M ; rm emptyfile ; echo check > .........
> this should result in zero or near-zero (see next point) mismatches. I
think nobody has tried this before so if you can try this that would be 
> great.

Baseline (had run a repair 9+ hours earlier btw):
# echo "Before: " $(cat /sys/block/md{0,1}/md/mismatch_cnt)
Before:  0 7552

# dd if=/dev/zero of=emptyfile bs=1M
dd: error writing 'emptyfile': No space left on device
66180+0 records in
66179+0 records out
69394198528 bytes (69 GB) copied, 127.136 s, 546 MB/s

# rm emptyfile

# echo check > /sys/devices/virtual/block/md0/md/sync_action
# echo check > /sys/devices/virtual/block/md1/md/sync_action
# # .. waiting until check done ..

# echo "After: " $(cat /sys/block/md{0,1}/md/mismatch_cnt)
After:  0 6016

> 3) I'm not sure if a small number of mismatches can arise when check or
repair reads a sector that is being written to. This cannot account for
> the large number you see but could return not exactly zero when you do the
test of previous point.
Agree (there are some processes, logging, etc. to the RAID-1 on occasion but
when I used to use HDDs in a similar configuration, I never saw this level
of mismatches and a repair would usually bring it down to 0 or a very small
number.

> 4) Theories above do not explain why you see an improvement dropping
caches. This is very interesting. How do you exactly drop the caches?

In short:
1.   sync
2.   echo 1 > /proc/sys/vm/drop_caches
3.   sync
4.   echo check > sync_action
[ .. ]
5.  if mismatch_cnt > 0
6.  repeat 1-3 above
7.  echo repair > sync_action

> 5) I have an additional theory for SSDs: do you have TRIMs enabled in
mount options, or do you perform periodic TRIMs? If yes, note that the 
> SSD might return whatever from the sectors being TRIMmed, and hence the
mismatch. See this:
>
http://serverfault.com/questions/530652/background-discard-on-swap-partition
s-on-linux-ssd
> do you have trim option enabled? do your SSDs have deterministic read data
after trim?
I have TRIM (discard) enabled for the / (root) only and only use MDRAID-1
for the /boot and / (root) filesystems, I have a 3rd SSD dedicated to swap.

(/dev/sdb, /dev/sdc):
/dev/md0        /boot            ext3    defaults                   0  0
/dev/md1        /                ext4    defaults,discard           0  0

(/dev/sdd)
/dev/sdd1       none             swap    sw                          0  0

Justin.


