From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Fwd: Re: Two Questions about Linux MD
Date: Sat, 19 Jul 2014 10:52:20 +0200
Message-ID: <53CA31C4.2020705@megasoft.be>
References: <53CA304E.4040908@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CA304E.4040908@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



See answser below:

Ps. You added extra spaces on the bit line ? Why did you do this ?
You should be using monospace fonts / fixed-with for mailing lists.

Killian De Volder

On 19-07-14 05:15, Henry Cai wrote:
> 1> The first question, as the wiki:
> https://raid.wiki.kernel.org/index.php/Initial_Array_Creation
>
> There has the sentence, "For raid5 there is an optimisation: mdadm
> takes one of the disks and marks it as 'spare' ", what I want to know
> is the optimisation for what? The result of the optimisation is that
> when initial create, the RAID5 is do recovery not resync.
>
> And in the mdadm man
> page:http://www.linuxmanpages.com/man8/mdadm.8.php, also has an option
> --force, describe as follow: "Normally mdadm will not allow creation
> of an array with only one device, and will try to create a raid5 array
> with one missing drive (as this makes the initial resync work faster).
> With --force, mdadm will not try to be so clever. "
Don't know how this is faster, sorry, maybe someone else on the mailing
list know.
> 2> The second question, I understand how the write intent bitmap work.
> But I donot know how it solve the follow problem. With your example:
>
> Write indent map for 512K disk using 64K chunks
>
> Bit 1: Synchronized
> Bit 0: Not synced
>
> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | Bit   | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
>
> And, if there are 4 data disks, and 1 parity disk for RAID5, total
> with 5 disks: D1 D2 D3 D4 P.
>
> when write the disk D1's Chunk 1, and the D1 disk power connector
> flies off, and write fail, so the bitmap as follow:
> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | Bit   | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
>
> Before the disk D1 power on, another disk Chunk2 write fail for the
> same reason, how to address this scene? Or the RAID will not
> writeable? Now, the bitmap as follow:
>
> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | Bit   | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
If you lose 2 disk out of a raid5 it's game over, unless you can reuse
a disk to get (some of) the data back.
(Note: bad blocks don't have to result in a disk fail.)
It will most certainly become not writeable, and readable to.
Since now you are missing 1 out of 4 chunks in this example.
> When the D1 come back, it will find there are 2 Chunks need
> reconstruct, so will the read the data from D2 D3 D3 and P, and do
> xor, and write the result to D2?
It will write it to D1 (typo on your end probably).
But given this question you might first want to look into
how raid works before asking specific linux-raid questions ?
> Another situation is when the system power cut down abnormally when
> write Chunk1 Chunk2, the bitmap as follow:
> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
> | Bit   | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
>
> When system boot, will do resync for Chunk1 and Chunk2?
Yes, the state of the machine (reboot or not) is not important for
linux-raid, it checks in what state the _raid_ is and acts on that.

If you reboot during a resync, bitmaps can be helpfully.
Without a bitmap, linux-raid doesn't know where it was with the sync and would
have to start over from scratch.

> Last, if bitmap save on all disks, how to keep the bitmap consistent?
> How to address the situation that the bitmaps are different when read
> from the disks after system boot?
If linux-raid has troubles keeping the bitmap consistent,
I'd be a lot more concerned about your data :)
Also they probably use some tricks with write barriers, and flushes
and other data to figure out which ones to use.

That's for someone smarter on the list.
>
> Henry
>
> 2014-07-18 23:30 GMT+08:00 Killian De Volder <killian.de.volder@megasoft.be>:
>> I) Can you give the complete mdadm command used to create it ?
>> Normally it should create a RAID5 without spares. (unless instructed otherwise/you passed the wrong options)
>> Also giving us the output of mdadm --detail /dev/mdXXX could help
>>
>> II) ***Disclaimer*** following information below might not be accurate, but such a system could work.
>> If it's incorrect it should help you understand when someone corrects me.
>>
>> mdadm --examine /dev/sdXX shows me "Internal Bitmap : 8 sectors from superblock"
>> This would indicate there is a bitmap on each drive (although I'm not sure, theoretically you could RAID it, but why increase complexity).
>>
>> However the RAID only need 1 write indent map.
>> But in the worst case scenario only 1 disk is left, so a copy is maintained on each drive.
>>
>> Example:
>> Write indent map for 512K disk using 64K chunks
>>
>> Bit 1: Synchronized
>> Bit 0: Not synced
>>
>> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
>> | Bit   | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
>>
>> When you write in Chunk 1, the bit is set to 0.
>> Now assume 1 of the disk power connector flies of, and the write to the chunk fails.
>> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
>> | Bit   | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
>>
>> Meanwhile another write is done to Chunk 2, new bitmap:
>> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
>> | Bit   | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
>>
>> Now when you plug the disk back in it looks for unwritten chunks, and it find 1 and 2, now it nows it can start from this.
>> (Note it reject the bitmap of the disk you plugged back in.)
>>
>> In case you are building a new raid something simular occurs:
>> This would be the start bitmap:
>> | Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
>> | Bit   | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
>>
>> As each chunk is sycned the bit is set to 1:
>> C1234578
>> B0000000 Later it becomes:
>> B1000000 Then later it becomes
>> B1100000 ...
>>
>> So at any point you can reboot, and the raid will know where to continue by looking at the non-sycned bitmaps.
>>
>> Also see the wiki: https://raid.wiki.kernel.org/index.php/Write-intent_bitmap
>>
>> Killian De Volder
>>
>> On 18-07-14 16:21, Henry Cai wrote:
>>> Hi,
>>>
>>> Here, I got two confusing questions about Linux MD:
>>>
>>> I.  Why when initial create RAID5, mdadm marks a physical disk as "spare"?
>>>
>>>     Is this for random write with RMW, or for "sync" speed?
>>>
>>>
>>> II. The write intent bitmap, each disk in RAID with a "write intent
>>> bitmap", or the whole RAID with one "write intent bitmap"?
>>>
>>>     If the whole RAID with one "write intent bitmap", how to know
>>> which disk's data need reconstruct, or just use the data disks'
>>>
>>>    data to calculate the P data, and write to the P disk? If the only
>>> one "write intent bitmap", how to decide which disk to save
>>>
>>>    the "write intent bitmap"?
>>>
>>> And is there has any MD design architecture document?
>>>
>>> Thanks a lot
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



