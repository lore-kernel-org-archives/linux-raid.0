From: Anthony Wright <anthony@overnetdata.com>
Subject: Re: Panic doing BLKDISCARD on a raid 5 array on linux 3.17.3
Date: Thu, 18 Dec 2014 10:21:50 +0000
Message-ID: <5492AABE.4050508@overnetdata.com>
References: <5491704D.1080709@overnetdata.com> <20141218162858.47310158@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141218162858.47310158@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/12/2014 05:28, NeilBrown wrote:
> On Wed, 17 Dec 2014 12:00:13 +0000 Anthony Wright <anthony@overnetdata.com>
> wrote:
>
>> I've hit a panic bug on stock linux 3.17.3 (which includes the recent
>> commit on BLKDISCARD in md/raid5.c) running in Dom0 under Xen 4.1.0 that
>> I've isolated to a BLKDISCARD system call within mkfs.ext3 and only
>> happens on a raid 5 array (it doesn't happen on a raid 1 array).
>>
>> The system it happens on is remote and I don't have physical access to
>> it, but the system administrator there is fairly helpful. We're in the
>> process of commissioning the system which needs to be done tomorrow
>> (thursday), so I've only got 24 hours in which I can run any tests you
>> may want. If necessary I can arrange remote access, but it's a little
>> complex.
>>
>> We have 3 512GB SSDs on the system, all with a GPT partition table and
>> the same partition layout. All the partitions have optimal alignment
>> according to parted. One of the partitions on each SSD is assembled into
>> a raid 1 array, another partition is assembled into a raid 5 array. Each
>> array is the used as the only physical volume in a LVM volume group. I
>> then create a logical volume on each array and format the logical volume
>> with mkfs.ext3. I ran mkfs.ext3 in verbose mode and also ran strace on
>> it in a separate session (though it was over a network) so it's possible
>> I lost the last few packets of data.
>>
>> /dev/Test/Test - 400MB LV on raid 1
>> /dev/Master/Test - 400MB LV on raid 5
>>
>> A) mkfs.ext3 -E nodiscard -v /dev/Test/Test - succeeds
>> B) mkfs.ext3 -v /dev/Test/Test - succeeds
>> C) mkfs.ext3 -E nodiscard -v /dev/Master/Test - succeeds
>> D) mkfs.ext3 -v /dev/Master/Test - panics
>>
>> mkfs.ext3 output from (B)
>> -------------------------
>> mke2fs 1.42.9 (28-Dec-2013)
>> fs_types for mke2fs.conf resolution: 'ext3', 'small'
>> Discarding device blocks: done                           Discard
>> succeeded and will return 0s - skipping inode table wipe
>> Filesystem label=
>> OS type: Linux
>> Block size=1024 (log=0)
>> Fragment size=1024 (log=0)
>> Stride=4 blocks, Stripe width=4 blocks
>> 51200 inodes, 204800 blocks
>> 10240 blocks (5.00%) reserved for the super user
>> First data block=1
>> Maximum filesystem blocks=67371008
>> 25 block groups
>> 8192 blocks per group, 8192 fragments per group
>> 2048 inodes per group
>> Superblock backups stored on blocks:
>>     8193, 24577, 40961, 57345, 73729
>>
>> Allocating group tables: done                           Writing inode
>> tables: done                           Creating journal (4096 blocks): done
>> Writing superblocks and filesystem accounting information: done
>>
>> strace output from (B) around the BLKDISCARD
>> --------------------------------------------
>> gettimeofday({1418806647, 890754}, NULL) = 0
>> gettimeofday({1418806647, 890814}, NULL) = 0
>> ioctl(3, BLKDISCARD, {0, 3000000010})   = 0
>> write(1, "Discarding device blocks: ", 26) = 26
>> write(1, "  1024/204800", 13)           = 13
>> write(1, "\10\10\10\10\10\10\10\10\10\10\10\10\10", 13) = 13
>> ioctl(3, BLKDISCARD, {100000, 3000000010}) = 0
>> write(1, "             ", 13)           = 13
>> write(1, "\10\10\10\10\10\10\10\10\10\10\10\10\10", 13) = 13
>> write(1, "done                            "..., 33) = 33
>> write(1, "Discard succeeded and will retur"..., 65) = 65
>>
>> mkfs.ext3 output from (D)
>> -------------------------
>> mke2fs 1.42.9 (28-Dec-2013)
>> fs_types for mke2fs.conf resolution: 'ext3', 'small'
>> <Panic>
>>
>> strace output from (D) around the BLKDISCARD
>> --------------------------------------------
>> gettimeofday({1418809706, 244197}, NULL) = 0
>> gettimeofday({1418809706, 244259}, NULL) = 0
>> ioctl(3, BLKDISCARD, {0, 3000000010}
>> <Panic>
>>
>> I have a photograph of the panic output from a previous session which
>> includes raid5d and blk_finish_plug in the stack trace, unfortunately I
>> don't have the top part of the panic and vger won't accept the
>> attachment. I also have a photograph of the console output from the
>> crash at (D), but in this case it outputs to the console every 180 seconds:
>>
>> INFO: rcu_sched self-detected stall on CPU { 1}
>> sending NMI to all CPUs:
>> xen: vector 0x2 is not implemented
>>
>> thanks,
>>
>> Anthony Wright
> Presumably you have deliberately enabled DISCARD support by setting the
>   raid456.devices_handle_discard_safely
>
> modules parameters?  Otherwise the DISCARD should be a no-op.
I haven't touched the raid456.devices_handle_discard_safely setting, I
only learnt about it when I discovered your patch while I investigated
the crash. I'm presuming it's the default value, but if there's a way to
confirm that please let me know.
> It is very hard to deduce anything without the full Oops.  Do you have access
> to another machine on the same subnet?  If so you could enable netconsole and
> capture the full oops from the other machines (all console messages are sent
> via UDP at a very low level).
I've got netconsole working, but it doesn't always panic and it takes a
while to get the system reset. Below is the output I got from the most
recent crash:

[63207.177400] BUG: unable to handle kernel paging request at
0000001e00008000

Anthony.
