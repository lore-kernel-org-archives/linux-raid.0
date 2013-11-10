From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Sun, 10 Nov 2013 13:45:41 +0100
Message-ID: <527F7FF5.3000002@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/11/2013 23:49, Justin Piszcz wrote:
> From: joystick [mailto:joystick@shiftmail.org]
>
> [ .. ]
>
> Hi,
>
>> 1) It might be Grub writing state data to one device only during boot. IF the machine was rebooted at least once prior to check.
> The checks (multiple) had occurred after the reboot, last uptime (was ~40+ days)-- also using LILO here with the checks running once a week.

You mean that you *repaired* the mismatches, then waited without 
rebooting, then repeated the check and there were again mismatches?


>> 2) Earlier discussions on this list suggested that it might be a write buffer becoming invalid during write because a temporary file being written has been deleted in the meantime and the buffer reused with different content even if the buffer was still in-flight for the write. If this is true, the region with mismatches would belong to unallocated space on the filesystem so would be harmless. To confirm this, one in your situation should write zeroes to a new file so to fill the filesystem, then remove the file, just prior to the check or repair
>>
>> dd if=/dev/zero of=emptyfile bs=1M ; rm emptyfile ; echo check > .........
>>
>> this should result in zero or near-zero (see next point) mismatches. I think nobody has tried this before so if you can try this that would be great.
> Baseline (had run a repair 9+ hours earlier btw):
> # echo "Before: " $(cat /sys/block/md{0,1}/md/mismatch_cnt)
> Before:  0 7552
>
> # dd if=/dev/zero of=emptyfile bs=1M
> dd: error writing 'emptyfile': No space left on device
> 66180+0 records in
> 66179+0 records out
> 69394198528 bytes (69 GB) copied, 127.136 s, 546 MB/s
>
> # rm emptyfile
>
> # echo check > /sys/devices/virtual/block/md0/md/sync_action
> # echo check > /sys/devices/virtual/block/md1/md/sync_action
> # # .. waiting until check done ..
>
> # echo "After: " $(cat /sys/block/md{0,1}/md/mismatch_cnt)
> After:  0 6016


Still mismatches after zero filling the filesystem.
This is important. This partially supports and partially undermines the 
main theory that was previously supported by people in this list, the 
one of empty space which I mentioned in my previous post.
Supports: the count has reduced from 7552 to 6016 so it seems the 
supposed mechanism actually happens sometimes.
Undermines (*): there are still 6016 mismatches, apparently belonging 
(*) to existing files.

(*) unless explanation is due to Trim, i.e. point 5 below

Since you have discard enabled on md1 mount options, I would suggest one 
more test:
Compute space left on md1 filesystem, e.g. 64.6 GiB (69394198528 bytes, 
watch out: not 69 GB) in example above.
Keep a reasonable margin for your activities, e.g. 3 GB
Fill the remainder, e.g. 61*1024 MB  (if I computed correctly)

# dd if=/dev/zero of=emptyfile bs=1M count=62464

now perform the check for mismatches with emptyfile still on the filesystem. Delete only afterwards.
This should keep Trim effects mostly out of the game.

# echo check > /sys/devices/virtual/block/md1/md/sync_action
# rm emptyfile

>> ...
>> 4) Theories above do not explain why you see an improvement dropping
> caches. This is very interesting. How do you exactly drop the caches?
>
> In short:
> 1.   sync
> 2.   echo 1 > /proc/sys/vm/drop_caches
> 3.   sync
> 4.   echo check > sync_action
> [ .. ]
> 5.  if mismatch_cnt > 0
> 6.  repeat 1-3 above
> 7.  echo repair > sync_action

The only reason I can think of, for which dropping in this way might 
help, is if Trim-med areas return nonzero upon read for such SSD. In 
that case the cache and the device return different values upon read.

I think the kernel should drop the cache of trimmed areas. Probably this 
is not implemented yet. Can anybody confirm?


>> 5) I have an additional theory for SSDs: do you have TRIMs enabled in mount options, or do you perform periodic TRIMs? If yes, note that the  SSD might return whatever from the sectors being TRIMmed, and hence the mismatch. See this:
>>
>> http://serverfault.com/questions/530652/background-discard-on-swap-partitions-on-linux-ssd
>>
>> do you have trim option enabled? do your SSDs have deterministic read data after trim?
> I have TRIM (discard) enabled for the / (root) only and only use MDRAID-1
> for the /boot and / (root) filesystems, I have a 3rd SSD dedicated to swap.
>
> (/dev/sdb, /dev/sdc):
> /dev/md0        /boot            ext3    defaults                   0  0
> /dev/md1        /                ext4    defaults,discard           0  0
>
> (/dev/sdd)
> /dev/sdd1       none             swap    sw                          0  0

One answer is missing: has it got deterministic read data after trim?

# hdparm -I /dev/sdX | grep TRIM

does it contain something like " * Deterministic read data after TRIM" ?

I would not trust this 100% anyways; the new test I suggested for point 
2 above should be more reliable.

Regards
J.


