From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Sat, 31 Dec 2011 00:17:34 +0100
Message-ID: <4EFE468E.3010007@gmail.com>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com> <4EFD5928.100@fnarfbargle.com> <4085BCC9-B901-4D96-B530-4D580A162D20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4085BCC9-B901-4D96-B530-4D580A162D20@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 30.12.2011 22:04, Michele Codutti napsal(a):
> Hi all, thanks for the tips I'll reply everyone in one aggregated message:
>> Just a thought, but do you have the "XP mode" jumper removed on all drives?
> Yes.
> 
>> Instead of doing a monster sequential write to find my disk speed, I
>> generally find it more useful to add conv=fdatasync to a dd so that
>> the dirty buffers are utilized as they are in most real-world working
>> environments, but I don't get a result until the test is on-disk.
> Done, same results (40 MB/s)
> 
>>>> My only suggestion would be to experiment with various partitioning,
>>>
>>>
>>> Poster already said they're not partitioned.
>>
>> Correct. using partitioning allows you to adjust the alignment, so for
>> example if the MD superblock at the front moves the start of the
>> exported MD device out of alignment with the base disks, you could
>> compensate for it by starting your partition on the correct offset.
> Done. I've created one big partition using parted with "-a optimal".
> The partition layout is (fdisk friendly output):
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00077f06
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1            2048  3907028991  1953513472   fd  Linux raid autodetect
> Redone the test with the "conv=fdatasync" option as above: same results.
> 
>> My only suggestion would be to experiment with various partitioning,
>> starting the first partition at 2048s or various points to see if you
>> can find a placement that aligns the partitions properly. I'm sure
>> there's an explanation, but I'm not in the mood to put on my thinking
>> hat to figure it out at the moment. May also be worth using a
>> different superblock version, as 1.2 is 4k from the start of the
>> drives, which might be messing with alignment (although I would expect
>> it on all arrays), worth trying the .9 which goes to the end of the
>> device.
> I've tried all the superblock versions 0, 0.9, 1, 1.1 and 1.2. Same results.
> 
>> No, those drives generally DON'T report 4k to the OS, even though they
>> are. If they were, there'd be fewer problems. They lie and say 512b
>> sectors for compatibility.
> Yes they are dirty liars. It's the same also for the EADS series not only for the EARS ones.
> 
>> My recommendation would be to look into the stripe-cache settings and check
>> iostat -x 5 output. What is most likely happening is that when writing to
>> the raid5, it's reading some (to calculate parity most likely) and not just
>> writing. iostat will confirm if this is indeed the case.
> Could you explain how I could look into the stripe-cache settings?
> This is one of many similar outputs from iostat -x 5 from the initial rebuilding phase:
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00   13.29    0.00    0.00   86.71
> Device: rrqm/s  wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz await r_await w_await svctm %util
> sda    6585.60    0.00 4439.20    0.00 44099.20     0.00    19.87     6.14  1.38    1.38    0.00  0.09 39.28
> sdb    6280.40    0.00 4746.60    0.00 44108.00     0.00    18.59     5.20  1.10    1.10    0.00  0.07 35.04
> sdc       0.00 9895.40    0.00 1120.80     0.00 44152.80    78.79    12.03 10.73    0.00   10.73  0.82 92.32
> I also build a RAID6 (with one drive missing): same results.
> 
>> There must be some misalignment somewhere :(
> Yes, it's the same behavior.
> 
>> Do all drives really report as 4K to the OS - physical_block_size, logical_block_size under
>> /sys/block/sdX/queue/ ??
> No they lie about the block size as you can see also in the fdisk output above.
> 
>> NB: how does it perform with partitions starting at sector 2048 (check
>> all disks with fdisk -lu /dev/sdX).
> They perform the same.
> 
> Any other suggestion?
> 
> I almost forgot: I've also booted OpenSolaris and I've created a zfs pool (aligned with 4k sector) from the same three drives and they perform very well, individually and together. I know that I'm comparing apples and oranges but ... there must be a solution!--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

WTF is the jumper for then ? (on 512B drive)
Does it change somehow:
/sys/block/sdX/queue/physical_block_size
/sys/block/sdX/queue/logical_block_size
/sys/block/sdX/alignment_offset

If osol can handle it (enforcing 4k), it's good sign.. (you used
ashift=12 for the pool, right?)

Z.

