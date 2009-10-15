From: aristizb@ualberta.ca
Subject: Re: dirty chunks on bitmap not clearing (RAID1)
Date: Thu, 15 Oct 2009 09:15:40 -0600
Message-ID: <20091015091540.198453j0u7mwl9s8@webmail.ualberta.ca>
References: <20091014163943.15177bety75a30g0@webmail.ualberta.ca>
	<70ff6a9cafb264616612d53002d9bd63.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ff6a9cafb264616612d53002d9bd63.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil.

I am using mdadm 2.6.3 and the kernel is Ubuntu 2.6.24-24.


Quoting NeilBrown <neilb@suse.de>:

> On Thu, October 15, 2009 9:39 am, aristizb@ualberta.ca wrote:
>> Hello,
>>
>> I have a RAID1 with 2 LVM disks and I am running into a strange
>> situation where having the 2 disks connected to the array the bitmap
>> never clears the dirty chunks.
>
> That shouldn't happen...
> What versions of mdadm and the Linux kernel are you using?
>
> NeilBrown
>
>>
>> I am assuming also that when a RAID1 is in write-through mode, the
>> bitmap  indicates that all the data has made it to all the disks if
>> there are no dirty chunks using mdadm --examine-bitmap.
>>
>> The output of cat /proc/mdstat is:
>>
>> md2060 : active raid1 dm-5[1] dm-6[0]
>>        2252736 blocks [2/2] [UU]
>>        bitmap: 1/275 pages [12KB], 4KB chunk, file: /tmp/md2060bm
>>
>>
>> The output of mdadm --examine-bitmap /tmp/md2060bm is:
>>
>> Filename : md2060bm
>>             Magic : 6d746962
>>           Version : 4
>>              UUID : ad5fb74c:bb1c654a:087b2595:8a5d04a9
>>            Events : 12
>>    Events Cleared : 12
>>             State : OK
>>         Chunksize : 4 KB
>>            Daemon : 5s flush period
>>        Write Mode : Normal
>>         Sync Size : 2252736 (2.15 GiB 2.31 GB)
>>            Bitmap : 563184 bits (chunks), 3 dirty (0.0%)
>>
>>
>> Having the array under no IO, I waited 30 minutes but the dirty data
>> never gets clear from the bitmap, so I presume  the disks are not in
>> sync; but after I ran a block by block comparison of the two devices I
>> found that they are equal.
>>
>> The superblocks and the external bitmap tell me that all the events
>> are cleared, so I am confused on why the bitmap never goes to 0 dirty
>> chunks.
>>
>> How can I tell if the disks are in sync?
>>
>>
>> Thank you in advance for any help.
>>
>>
>> --
>> Juan Aristizabal
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

