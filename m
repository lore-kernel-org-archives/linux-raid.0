From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Fri, 15 Nov 2013 09:51:32 +0100
Message-ID: <5285E094.2050607@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm> <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com> <52848D5C.7020701@shiftmail.org> <002201cee126$5c390290$14ab07b0$@lucidpixels.com> <5284F5B2.3040307@shiftmail.org> <007301cee15e$178969e0$469c3da0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <007301cee15e$178969e0$469c3da0$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/11/2013 18:22, Justin Piszcz wrote:
>
> -----Original Message-----
> From: joystick [mailto:joystick@shiftmail.org]
> Sent: Thursday, November 14, 2013 11:09 AM
> To: Justin Piszcz
> Cc: 'Bernd Schubert'; 'linux-raid'
> Subject: Re: 3.12: raid-1 mismatch_cnt question
>
> [ .. ]
>
>>> At the end of the procedure (like now, if you didn't resync or repair in
>>> the meanwhile) is mismatch_cnt still so high?
> After a reboot, I ran the check and yes it was still high.
>
> [ .. ]
>
>>> no, not that one...
>>> it would be helpful to know the kernel version that *creates*
>>> mismatches, the one that you have running normally on the live system.
> Version: 3.12.0 (and typically always use the latest)

ok

> That's the "bugged" one, supposing this is really a bug (until we find
> where the mismatches are, it's difficult to say wether this is a data
> loss or not)
>
>>> Maybe the mismatched are located ext4 metadata areas which are not files
>>> and so can't be seen with md5sums... That would still be as much
>>> worrisome, unless some expert of ext4 can tell that it's ok (it can be
>>> OK if the region with mismatches is an old metadata area, currently
>>> unused; the mechanism that can create harmless mismatches in this case
>>> has been described by Neil)
> If that is what is occurring, is it possible to exclude them from mismatch_cnt?

not possible unfortunately.

But your mismatch_cnt is exceptionally high, which is unlikely to come 
from the described mechanism. Other people usually have zero even after 
months of operation, e.g. I have zero


> [ .. ]
>
> - First confirm that mismatch_cnt is still high..
> It was 0 after reboot.

Above you wrote that after the procedure you rebooted then did a check 
and it was still high. Can you guess when did it repair?


> [ .. ]
>
>
> - Then if this does not disrupt your system operation too much, i would
> suggest to fill 95% of free space with a zeroes file like you did in
> earlier tests. Otherwise for a mismatch happening in non-file area we
> won't be sure of what kind of area is that. Maybe recompute mismatch_cnt
> after this.
>
> Create file up to 95% utilization on /root:
> /dev/root       219G  205G   12G  95% /
>
> Re-check:
> # echo check > /sys/devices/virtual/block/md1/md/sync_action
> # cat /sys/devices/virtual/block/md1/md/mismatch_cnt
> 27520

?????
You mean that mismatch_cnt was zero, then you created a big file full of 
zeroes and after that mismatch_cnt jumped to 27520 ??
I believe this should not happen, especially not with the harmless 
mechanism explained by Neil, and this narrows the bug quite a lot.
If you confirm I understood correctly, can you retry such thing a couple 
of times? Delete zeroes file, repair RAID so that mismatch_cnt goes to 
zero, check to confirm that mismatch_cnt is zero, create a file full of 
zeroes, check again... did mismatch_cnt jump to a high value?

If reproducing the bug is so easy, you might want to try earlier kernels 
such as the 3.0.101 and re-test with that .
If earlier kernels do not have such bug it becomes relatively easy to 
find when was it introduced. Maybe without even knowing where are the 
mismatches located.


> then, copypasting the procedure with some modifications:
> ----
> ... to determine the location of mismatches (...)
> Unfortunately I don't think MD tells you the location of mismatches
> directly. Do you want to try the following:
> /sys/block/md1/md/sync_min and /sys/block/md1/md/sync_max should allow
> you to narrow the region of the next check.
> Set them, then perform check, then cat mismatch_cnt.
> Narrow progressively sync_min and sync_max so that you identify the most
> dense areas of mismatches, or a few single blocks that mismatch.
> When you have identified some regions or isolated blocks, invoke "sync"
> from bash and then check again the same region a couple of times so to
> be sure that it stays mismatched and it's not just a transient situation.
> Then try with debugfs (in readonly mode can be used with fs mounted):
> there should be an option to get the inode number from a block number of
> the device... I hope that block numbers are not offset by MD... I think
> it's icheck and after that you might need "find -inum <inode_number>"
> launched on the same filesystem to find the corresponding filename from
> the inode number. That should be the file that contains the mismatch.
> [ .. ]
> When I do this, the speed of check thereafter is very slow:
>
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>        233381376 blocks [2/2] [UU]
>        [>....................]  check =  0.0% (4500/233381376) finish=80387.9min speed=48K/sec (55 days)
>
> The speed continues to decrease when the sync_min is set to 1000 and sync_max is 9000 (this won't work).

Are you running the "find" simultaneously with "check" ?
Check priority is rather low so I understand why it would slow down if 
you are also doing "find". Otherwise... seems like it's another bug.


