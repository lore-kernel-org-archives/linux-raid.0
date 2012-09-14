From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Recovering from the kernel bug, Neil?
Date: Fri, 14 Sep 2012 12:07:29 +0200
Message-ID: <505301E1.10707@schinagl.nl>
References: <5030F07F.7000303@schinagl.nl> <504CFA7B.7090606@schinagl.nl> <20120910090829.19100cdf@notabene.brown> <504DA85C.6080000@schinagl.nl> <20120911161622.0b0fcf8c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120911161622.0b0fcf8c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I've spent the last few days trying several things to recover the 
array. Assumption is the mother right?

I had 3 arrays, /, /usr and /opt. I did some basic research at the 
various raid levels, and for some reason decided that f2 was good for /, 
and o2 for /usr. In that same trend I thought o2 was good for /opt as 
well. I was wrong. I was so sure I made it o2, that I ruled out the 
possibility it being f2. I did try various offsets, but never f2 with 
missing /dev/sdb6. I think i even tried f2 in the passed, but on sda6 
where i may have broke things.

Short story short, it turns out it was 128k chunks, Far2 offset. The 
data actually is accessible from a dd-ed image looped to mdadm and that 
mounted. I will now recreate my md2 array, and copy the data over.

Thank you for all advice and help in the past and again. You are an 
amazing dev and a good person.

Oliver



I left the below because I typed a lot and it could be potentially still 
be usefull to someone :p This has been an interesting en-devour using 
hexdump to investigate a raid array and I learned a lot from it.

On 09/11/12 08:16, NeilBrown wrote:
> On Mon, 10 Sep 2012 10:44:12 +0200 Oliver Schinagl<oliver+list@schinagl.nl>
> wrote:
>
>> On 09/10/12 01:08, NeilBrown wrote:
>>> On Sun, 09 Sep 2012 22:22:19 +0200 Oliver Schinagl<oliver+list@schinagl.nl>
>>> wrote:
>>>
>>>> Since I had no reply as of yet, I wonder if I would arbitrarly change
>>>> the data at offset 0x1100 to something that _might_ be right could I
>>>> horribly break something?
>>>
>>> I doubt it would do any good.
>>> I think that editing the metadata by 'hand' is not likely to be a useful
>>> approach.  You really want to get 'mdadm --create' to recreate the array with
>>> the correct details.  It should be possible to do this, though a little bit
>>> of hacking or careful selection of mdadm version might be required.
>>>
>>> What exactly do you know about the array?   When you use mdadm to --create
>>> the array, what details does it get wrong?
>> I tried and believe it doesn't know what the order is of the array. E.g.
>> A1 B1 or B1 A1, basically.
>
> So did you try both orders of the devices and  neither worked?
Correct, but have re-tried again over the days. I am now guessing that I 
must have gotten the dimensions of the array wrong? E.g. not o2, but f2? 
Not 64k, but 128 or 256k? I suppose it won't hurt trying different sizes?

Here's what I did. dd the entire partition to a file (takes long, I 
somehow only get 45mb/s using BS=64k, partition is 160gb.

>
> But you didn't even try to answer my question: "what do you know about the
> array".
I am sorry for not properly describing the array, my mistake. (I have in 
the far past actually :p)

> I think it is raid10 - correct?
Yes, Raid10, I _thought_ it was o2, 128k chunks.

> 2 devices?
Yes, 2 devices only.

> You say someting about 'offset' below so may you chose the 'o2' layout - is
> that correct?
O2 from what I remember.

> Do you know anything about chunk size?
I am almost certain it was 128k, but in strong doubt now.

>
> It does look like there is an ext4 superblock 1M into the device, so that
> suggests a 'data_offset' of 1Meg.
I used the older version of mdadm, the one that didn't have the 4k and 
128M diffferentiation. Using the v1.2 metadata, puts my raid superblock 
at 4k I belive, and after that, at 1M, the ext4 begins.

data_offset also says 2048 with mdadm --examine, which I belive is 1M.

> What data offset do you get when you try to --create the array?
With mdadm v3.2.3, 2048.

>
>>                            After that no filesystem is found, nothing. I
>> did make a dump of the partition ('only' 160gb or so) so I have some
>> room to experiment. Going through the file/disk with hexedit I do see
>> all the data, seemingly intact, as described below. I did tune the mdadm
>> version to the one your recommended back then;
>> mdadm - v3.2.3 - 23rd December 2011
>>
>> I'm just mad at myself for having destroyed the first half of the array
>> (the one that is in proper order) by using the wrong version of mdadm
>> and destroying the first 128mb of my disk. The first 128mb of data isn't
>> that important I don't think, but it of course did contain all the
>> information ext4 needs to mount the disk :S
>
> Why do you think that you destroyed 128mb of your disk?  Creating an array
> with the 'wrong' data offset should at most destroy 4K, probably less.  It
> just writes out the super-block, nothing else.
>
> NeilBrown
Because I made the silly assumtion, that mdadm would clear the first 
128M as that's where the start of the array would be.

In that case, I should be able to see this with a hexdump, correct? At 
0x10000 I see nothing, a little further down, there's some data though. 
So maybe it is not destroyed after all. Will examine.
>
>
>
>>>
>>> NeilBrown
>>>
>>>
>>>>
>>>> oliver
>>>>
>>>> On 08/19/12 15:56, Oliver Schinagl wrote:
>>>>> Hi list,
>>>>>
>>>>> I've once again started to try to repair my broken array. I've tried
>>>>> most things suggested by Neil before (create array in place whilst
>>>>> keeping data etc etc) only breaking it more (having to new of mdadm).
>>>>>
>>>>> So instead, I made a dd of: sda4 and sdb4; sda5 and sdb5, both working
>>>>> raid10 arrays, f2 and o2 layouts. I then compared that to an image of
>>>>> sdb6. Granted, I only used 256mb worth of data.
>>>>>
>>>>> Using https://raid.wiki.kernel.org/index.php/RAID_superblock_formats I
>>>>> compared my broken sdb6 array to the two working and active arrays.
>>>>>
>>>>> I haven't completly finished comparing, since the wiki falls short at
>>>>> the end, which I think is the more important bit concerning my situation.
>>>>>
>>>>> Some info about sdb6:
>>>>>
>>>>> /dev/sdb6:
>>>>> Magic : a92b4efc
>>>>> Version : 1.2
>>>>> Feature Map : 0x0
>>>>> Array UUID : cde37e2e:309beb19:3461f3f3:1ea70694
>>>>> Name : valexia:opt (local to host valexia)
>>>>> Creation Time : Sun Aug 28 17:46:27 2011
>>>>> Raid Level : -unknown-
>>>>> Raid Devices : 0
>>>>>
>>>>> Avail Dev Size : 456165376 (217.52 GiB 233.56 GB)
>>>>> Data Offset : 2048 sectors
>>>>> Super Offset : 8 sectors
>>>>> State : active
>>>>> Device UUID : 7b47e9ab:ea4b27ce:50e12587:9c572944
>>>>>
>>>>> Update Time : Mon May 28 20:53:42 2012
>>>>> Checksum : 32e1e116 - correct
>>>>> Events : 1
>>>>>
>>>>>
>>>>> Device Role : spare
>>>>> Array State : ('A' == active, '.' == missing)
>>>>>
>>>>>
>>>>> Now my questions regarding trying to repair this array are the following:
>>>>>
>>>>> At offset 0x10A0, (metaversion 1.2 accounts for the 0x1000 extra) I
>>>>> found on the wiki:
>>>>>
>>>>> "This is shown as "Array Slot" by the mdadm v2.x "--examine" command
>>>>>
>>>>> Note: This is a 32-bit unsigned integer, but the Device-Roles
>>>>> (Positions-in-Array) Area indexes these values using only 16-bit
>>>>> unsigned integers, and reserves the values 0xFFFF as spare and 0xFFFE as
>>>>> faulty, so only 65,534 devices per array are possible."
>>>>>
>>>>> sda4 and sdb4 list this as 02 00 00 00 and 01 00 00 00. Sounds sensible,
>>>>> although I would have expected 0x0 and 0x1, but I'm sure there's some
>>>>> sensible explanation. sda5 and sdb5 however are slightly different, 03
>>>>> 00 00 00 and 02 00 00 00. It quickly shows that for some coincidental
>>>>> reason, but the 'b' parts have a higher number then the 'a' parts. So a
>>>>> 02 00 00 00 on sdb6 (the broken array) should be okay.
>>>>>
>>>>> Then next, is 'resync_offset' at 0x10D0. I think all devices list it as
>>>>> FF FF FF FF, but the broken device has it at 00 00 00 00. Any impact on
>>>>> this one?
>>>>>
>>>>> Then of course tehre's the 0x10D8 checksum. mdadm currently says it
>>>>> matches, but once I start editing things those probably won't match
>>>>> anymore. Any way around that?
>>>>>
>>>>> Then offset 0x1100 is slightly different for each array. Array sd?5
>>>>> looks like: FE FF FE FF 01 00 00 00
>>>>> Array sd?4 looks similar enough, FE FF 01 00 00 00 FE FF
>>>>>
>>>>> Does this correspond to the 01, 02 and 03 value pairs for 0x10A0?
>>>>>
>>>>> The broken array reads FE FF FE FF FE FF FE, which probably is wrong?
>>>>>
>>>>>
>>>>> As for determining whether the first data block is offset, or 'real', I
>>>>> compared dataoffsets 0x100000 - 0x100520-ish and noticed something that
>>>>> looks like s_volume_name and s_last_mounted of ext4. Thus this should be
>>>>> the 'real' first block. Since sdb6 has something that looks a lot like
>>>>> what's on sdb5, 20 80 00 00 20 80 01 00 20 80 02 etc etc at 0x100000
>>>>> this should be the first offset block, correct?
>>>>>
>>>>>
>>>>> Assuming I can force somehow that mdadm recognizes my disk as part of an
>>>>> array, and no longer a spare, how does mdadm know which of the two parts
>>>>> it is? 'real' or offset? I haven't bumped into anything that would tell
>>>>> mdadm that bit of information. The data seems to all be still very much
>>>>> available, so I still have hope. I did try making a copy of the entire
>>>>> partition, and re-create the array as missing /dev/loop0 (with loop0
>>>>> being the dd-ed copy) but that didn't work.
>>>>>
>>>>> Finally, would it even be possible to 'restore' my first 127mb on sda6,
>>>>> those that the wrong version of mdadm destroyed by reserving 128mb of
>>>>> data instead of the usual 1mb using data from sdb6?
>>>>>
>>>>> Sorry for the long mail, I tried to be complete :)
>>>>>
>>>>> Oliver
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

