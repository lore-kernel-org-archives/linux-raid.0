From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: slow sequential read on partitioned raid6
Date: Wed, 17 Mar 2010 19:40:16 -0700
Message-ID: <4877c76c1003171940y5bc70260mac7784452b2d4d7c@mail.gmail.com>
References: <4B9FD689.8060700@abcpages.com>
	 <20100317092219.35393819@notabene.brown>
	 <4BA0114D.9050405@abcpages.com>
	 <1268783497.3781.14.camel@localhost.localdomain>
	 <4BA09167.9080709@abcpages.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA09167.9080709@abcpages.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolae Mihalache <mache@abcpages.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 17, 2010 at 1:23 AM, Nicolae Mihalache <mache@abcpages.com> wrote:
> I created a second 100GB partition on all the disks and then made a
> normal /dev/md1 raid6 array out of them, and the results I get:
> bacula:~# dd if=/dev/zero of=/mnt1/test-file bs=1M count=10000
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 72.6303 s, 144 MB/s
>
> bacula:~# dd if=/mnt1/test-file of=/dev/null bs=1M count=10000
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 29.1241 s, 360 MB/s
>
> I really believe it's something with the partitioned array.
> /proc/devices shows:
>
> Block devices:
>  ...
>  9 md
>  ...
> 253 mdp
>
>
> All the md_d1 partitions have major number 253. I don't know if this
> means something but maybe there is a bug in the mdp driver (or whatever
> is called).
>
> nicolae
> Daniel Reurich wrote:
>> On Wed, 2010-03-17 at 00:16 +0100, Nicolae Mihalache wrote:
>>
>>> On 03/16/2010 11:22 PM, Neil Brown wrote:
>>>
>>>> On Tue, 16 Mar 2010 20:05:45 +0100
>>>> Nicolae Mihalache <mache@abcpages.com> wrote:
>>>>
>>>>
>>>>> Hello,
>>>>>
>>>>> I have created a partitioned raid6 array over 6x1TB SATA disks using the
>>>>> command (from memory): mdadm --create --auto=mdp --level=6
>>>>> --raid-devices /dev/md_d1 /dev/sd[b-g].
>>>>>
>>>>> When I run a sequential read test using
>>>>> dd if=/dev/md_d1p1 of=/dev/null bs=1M
>>>>> I get low read speeds of around 80MB/s but only when the partition is
>>>>> mounted.
>>>>>
>>>>> If I unmount, the speed is around 350MB/s. The filesystems I tried are
>>>>> ext3 and xfs.
>>>>>
>>>>>
>>>> Thanks for reporting this.
>>>>
>>>> I just did some testing and I get the reverse!!
>>>>
>>>> When a filesystem is mounted I get 135MB/s.  When it isn't mounted
>>>> I get 64MB/s.
>>>>
>>>> I cannot think what could cause this.  I will have to explore.
>>>> Can you please double check you results and confirm that it definitely
>>>> is  faster then unmounted.
>>>>
>>>>
>>> I'm positive that it's slow when mounted, that's how I discovered the
>>> problem. See below (I recreated the array over 1/10 of the original
>>> disks to be able to test easier).
>>> In fact the highest speed I get when accessing directly the entire disk
>>> even when one partition is mounted.
>>>
>>>
>>> bacula:~# cat /proc/mdstat
>>> Personalities : [raid1] [raid6] [raid5] [raid4]
>>> md_d1 : active raid6 sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>>>       390668288 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>>
>>> md2 : active raid1 sdi1[0] sdj1[1]
>>>       1462750272 blocks [2/2] [UU]
>>>
>>> unused devices: <none>
>>>
>>> bacula:~# parted  /dev/md_d1
>>> GNU Parted 1.8.8
>>> Using /dev/md_d1
>>> Welcome to GNU Parted! Type 'help' to view a list of commands.
>>> (parted) print
>>> Model: Unknown (unknown)
>>> Disk /dev/md_d1: 400GB
>>> Sector size (logical/physical): 512B/512B
>>> Partition Table: gpt
>>>
>>> Number  Start   End     Size    File system  Name     Flags
>>>  1      17.4kB  50.0GB  50.0GB  ext3         primary
>>>
>>> (parted) quit
>>>
>>> bacula:~# umount /dev/md_d1p1
>>> umount: /dev/md_d1p1: not mounted
>>>
>>> bacula:~# dd if=/dev/md_d1p1 of=/dev/null bs=1M count=10000
>>> 10000+0 records in
>>> 10000+0 records out
>>> 10485760000 bytes (10 GB) copied, 37.4938 s, 280 MB/s
>>>
>>> bacula:~# mount /dev/md_d1p1 /mnt
>>>
>>> bacula:~# dd if=/dev/md_d1p1 of=/dev/null bs=1M count=10000
>>> 10000+0 records in
>>> 10000+0 records out
>>> 10485760000 bytes (10 GB) copied, 132.894 s, 78.9 MB/s
>>>
>>> bacula:~# dd if=/dev/md_d1 of=/dev/null bs=1M count=10000
>>> 10000+0 records in
>>> 10000+0 records out
>>> 10485760000 bytes (10 GB) copied, 28.222 s, 372 MB/s
>>>
>>
>> Why are you trying directly from the block devices when they contain a
>> mounted filesystem?  Surely the fs layer would be holding a locks on the
>> block device causing it to slow down raw layer access.
>>
>> Might I suggest you should be reading files that are located within the
>> mounted filesystem.
>>
>> I suggest you try this in the mounted filesystem:
>>
>> dd if=/dev/zero of=/mnt/test-file bs=1M count=10000
>> dd if=/mnt/test-file of=/dev/null bs=1M
>> rm /mnt/test-file
>>
>> I hope this helps.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

First off, why not use a hard disk benchmark utility (their names
escape me aside from Bonnie++) which has these issues worked out?

Second, if you absolutely must try to do a benchmark with basic tools
(that buffer and use cache) try this:

dd if=/dev/zero bs=1M count=10000 | tr '\0' 't' > testfile
dd if=testfile of=/dev/null bs=1M

You may note that you'll be writing a file with Ts instead of a file
with 0's; my method should not be detected as sparse, where as the
case with zeros probably will be detected as sparse and simply not
stored.

If in doubt you can check the size of the file on disk with ls -ls
If I'm reading the output correctly the left most column (size on
disk) is in kilobyte units, even on a 4kb cluster EXT4 filesystem.
