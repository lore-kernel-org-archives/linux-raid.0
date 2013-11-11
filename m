From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Mon, 11 Nov 2013 04:26:37 -0500
Message-ID: <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <527F7FF5.3000002@shiftmail.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'joystick' <joystick@shiftmail.org>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----
From: joystick [mailto:joystick@shiftmail.org] 
Sent: Sunday, November 10, 2013 7:46 AM
To: Justin Piszcz
Cc: 'linux-raid'
Subject: Re: 3.12: raid-1 mismatch_cnt question

[ .. ]

> You mean that you *repaired* the mismatches, then waited without 
> rebooting, then repeated the check and there were again mismatches?

Yes.

[ .. ]

( # dd if=/dev/zero of=emptyfile bs=1M count=62464; now perform the check
for mismatches with emptyfile still on the filesystem. Delete only
afterwards; This should keep Trim effects mostly out of the game; # echo
check > /sys/devices/virtual/block/md1/md/sync_action; # rm emptyfile )

Had 103GB free, so:

$ dd if=/dev/zero of=emptyfile bs=1M count=100000 (4.8GB free after)
100000+0 records in
100000+0 records out
104857600000 bytes (105 GB) copied, 193.335 s, 542 MB/s

echo check > /sys/devices/virtual/block/md1/md/sync_action

cat /sys/devices/virtual/block/md1/md/mismatch_cnt
32640

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

[ .. ]

One answer is missing: has it got deterministic read data after trim?
# hdparm -I /dev/sdX | grep TRIM
does it contain something like " * Deterministic read data after TRIM" ?

[ .. ]

Yes.

# hdparm -I /dev/sdb|grep "TRIM"
           *    Data Set Management TRIM supported (limit 1 block)
           *    Deterministic read data after TRIM
# hdparm -I /dev/sdc|grep "TRIM"
           *    Data Set Management TRIM supported (limit 1 block)
           *    Deterministic read data after TRIM

I would not trust this 100% anyways; the new test I suggested for point 
2 above should be more reliable.

[ .. ]

Ok.

Justin.


