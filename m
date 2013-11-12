From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 10:30:37 +0100
Message-ID: <5281F53D.4060703@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/11/2013 19:52, Justin Piszcz wrote:

>> 4- Linux or SSD bug on trim, such as trimming wrong offsets killing live
>> data
>> 5- MD does not lock regions during check so returns erroneous mismatches for
>> areas being written. This would be harmless but your mismatches number seems
>> to high to me for this.
> I wonder if this could be it.

It's not, your reboot test confirmed it's not, when you did this:


> Ran a check > sync_action and re-checked the mismatch_cnt:
>
>   cat /sys/devices/virtual/block/md1/md/mismatch_cnt
>   68352

this should have been zero if it was the case



>> I would suggest to investigate further. One idea is to find which files are
>> affected....
> I took a slightly different approach, hopefully this will provide the
> information you are looking for:

Actually no, and you "fixed" it so you cannot do any further test until 
the number of mismatches grows again


> Rebooted to a system rescue cd:
>
> Did not mount the filesystem, before a check:
>
>    cat /sys/devices/virtual/block/md1/md/mismatch_cnt
>    256
>
> Ran a check > sync_action and re-checked the mismatch_cnt:
>
>    cat /sys/devices/virtual/block/md1/md/mismatch_cnt
>    68352
>
> Ran a repair > sync_action
>    68352 (expected, need to re-run check):
>
> Ran a check > sync_action
>    0
>
> It appears when there a files moving around / being written to it can
> throw off the mismatch_cnt?

Maybe, and it shouldn't happen. This is a serious bug somewhere, it 
corrupts data, we need to find it.

> As the FS above was not mounted, it
> repaired ok?

No, you just copied over one disk to the other. This does not mean 
"fixed" in the filesystem sense. Data is still corrupted, just the two 
legs of the RAID are now corrupted identically one to the other.

Wait so that mismatches grow again a couple of thousands, then I suggest 
you really do what I wrote in my previous email.
If you can afford to bring the system offline then it's really easy 
because you can find all mismatching files in one shot

- wait for mismatch_cnt reach 2000 at least (the more, the better), then 
reboot machine with a livecd
- mount RAID
- mount the filesystem readonly
- (very important or it will resync) activate bitmap for raid1, 
preferably with small chunksize
- fail 1 drive so to degrade raid1
- drop caches with blockdev --flushbufs on the md device such as 
/dev/md2, on the two underlying partitions such as /dev/sd[ab]2, and 
maybe even on the two disk holding then such as /dev/sd[ab] (I'm not 
really sure what is the minimum needed) ; and also echo 3 > 
/proc/sys/vm/drop_caches
- recursive md5sum for all files of the filesystem (something like find 
-type f -print0 | xargs -0 md5sum (untested)) > redirect stdout to a 
file on another filesystem
- reattach drive with --re-add, let it resync the differences using the 
bitmap (there shouldn't be any, should complete immediately)
- fail the other drive
- drop all caches again
- again find | md5sum , redirected to another file on another filesystem
- reattach drive with --re-add

now analyze differences between md5sums. Those are the files which are 
different in the two legs of the RAID, and they shouldn't be (aka 
corruption).
Find preferably humanly readable text files which are sequentially 
written, such as log files. It is more difficult to understand what's 
wrong for files changed in the middle such as database files, or binary 
files.

Copy those files out, to another filesystem.
You need to, again:
- fail 1 drive so to degrade raid1
- drop caches as described above
- copy all files out, to a directory in another filesystem
- reattach drive with --re-add
- fail the other drive
- drop all caches again
- copy all files out again to another directory of another filesystem
- reattach drive with --re-add

At this point you can restart machine to production.

Inspect the two versions of such files... If you can tell us something 
about which files got corrupted and what you exactly see in the 
corruption point (you can use hexdump to see binary chars), we could 
make some further guesses.

Regards
J.

