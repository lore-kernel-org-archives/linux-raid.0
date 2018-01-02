From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Tue, 2 Jan 2018 16:30:51 -0600
Message-ID: <CAAMCDedUNDhBQXiGgQbkhZRKfkAN4jWPakP25MiERA9-fae1Ew@mail.gmail.com>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name> <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
 <87r2r8dk80.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r2r8dk80.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: RQM <rqm@protonmail.com>, "linux-raid\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The brute force way to find the file is find all files and cat to
/dev/null checking for a bad return code on the cat command.

Last time I did it, that was easier, and unless the filesystem is
really really big should finish in a day or 2.    debugfs was not easy
to understand and/or work with, and overall the brute force method
took less of my time to implement.   if find/cat does not find it that
would indicate the error is in the free space or the filesystem data.

On Tue, Jan 2, 2018 at 3:27 PM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Jan 02 2018, RQM wrote:
>
>> Hello,
>>
>> thanks for the quick and helpful responses! Answers inline:
>>
>> > Step one is confirm that it is easy to reproduce.
>>> Does
>>> dd if=/dev/md0 bs=4K skip=1598030208 count=1 of=/dev/null
>>>
>>> trigger the message reliably?
>>> To check that "4K" is the correct blocksize, run
>>> blockdev --getbsz /dev/md0
>>>
>>> use whatever number if gives as 'bs='.
>>
>>
>> blockdev does indeed report a blocksize of 4096, and the dd line does reliably trigger
>> dd: error reading '/dev/md0': Input/output error
>> and the same line in dmesg as before.
>>
>>> Once you can reproduce with minimal IO, do
>>> echo file:raid5.c +p > /sys/kernel/debug/dynamic_debug/control
>>>repeat experiment
>>>
>>>echo file:raid5.c -p > /sys/kernel/debug/dynamic_debug/control
>>>
>>> and report the messages that appear in 'dmesg'.
>>
>> I had to replace the colon with a space in those two lines (otherwise I would get "bash: echo: write error: Invalid argument"), but after that, this is what I got in dmesg:
>> https://paste.ubuntu.com/26305369/
>
> [Tue Jan  2 11:14:47 2018] locked=0 uptodate=0 to_read=1 to_write=0 failed=2 failed_num=3,2
>
> So for this stripe. Two devices appear to be failed: 3 and 2.
> As the two devices clearly are thought to be working there must be a bad
> block recorded.
>
>>
>>> Also report "mdadm -E" of each member device, and kernel version (though
>>> I see that is in the serverfault report :  4.9.30-2+deb9u5).
>>
>> mdadm -E says: https://paste.ubuntu.com/26305379/
>
> I needed "mdadm -E" the components of the array, so the partitions
> rather than the whole devices. e.g. /dev/sdb1, not /dev/sdb.
>
> This will show a non-empty bad block list on at least two devices.
>
> You can remove the bad block by over-writing it.
>   dd if=/dev/zero of=/dev/md0 bs=4K seek=1598030208 count=1
> though that might corrupt some file containing the block.
>
> (note "seek" seeks in the output file, "skip" skips over the input
> file).
>
> How did the bad block get there?
> A possible scenario is:
>  - A device fails and is removed from array
>  - read error occurs on another device.  Rather than failing the whole
>    device, md records that block as bad.
>  - failed device is replaced (or found to be a cabling problem) and
>    recovered.  Due to the bad block the stripe cannot be recovered,
>    so a bad block is recorded in the new device.
>
> If the read error was really a cabling problem, then the original data
> might still be there.  If it is, you could recover it and write it back
> to the array rather then writing from /dev/zero.
> Finding out which file the failed block is part of is probably possible,
> but not necessarily easy.  If you want to try, the first step is
> reporting what filesystem is on md0.  If it is ext4, then debugfs can
> help.  If something else - I don't know.
>
> NeilBrown
>
>
>
>> The kernel has been updated between the serverfault post and my first mail to this list to 4.9.65-3+deb9u1. No changes since.
>>
>>>
>>> Then run
>>> blktrace /dev/md0 /dev/sd[acdef]
>>> in one window while reproducing the error again in another window.
>>> Then interrupt the blktrace.  This will produce several blocktrace*
>>> files.  create a tar.gz of these and put them somewhere that I can get
>>> them - hopefully they won't be too big.
>>
>> I had to adjust the last blktrace argument to /dev/sd[b-f] since after the last reboot the names of the drives have changed, but here's the output:
>> https://filebin.ca/3mnjUz1OIXqm/blktrace-out.tar.gz
>> I also included the blktrace terminal output in there.
>>
>> Thank you so much for the effort! Please let me know if you need anything.
