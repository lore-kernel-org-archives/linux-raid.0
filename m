From: Chris Pearson <pearson.christopher.j@gmail.com>
Subject: Re: dirty chunks on bitmap not clearing (RAID1)
Date: Wed, 31 Aug 2011 13:23:01 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1108311313550.27546@ubuntu>
References: <CAGtzr3fC8bWLa4A5eRRgjHCtgfENdx4jtaKNb53dD7NX61nf7g@mail.gmail.com> <20110831173842.44ab5b03@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110831173842.44ab5b03@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm happy to apply a patch to whichever kernel you like, but the blocks have since cleared, so I will try and reproduce it first.

On Wed, 31 Aug 2011, NeilBrown wrote:

>Date: Wed, 31 Aug 2011 17:38:42 +1000
>From: NeilBrown <neilb@suse.de>
>To: Chris Pearson <kermit4@gmail.com>
>Cc: linux-raid@vger.kernel.org
>Subject: Re: dirty chunks on bitmap not clearing (RAID1)
>
>On Mon, 29 Aug 2011 11:30:56 -0500 Chris Pearson <kermit4@gmail.com> wrote:
>
>> I have the same problem.  3 chunks are always dirty.
>> 
>> I'm using 2.6.38-8-generic and mdadm - v3.1.4 - 31st August 2010
>> 
>> If that's not normal, then maybe what I've done differently is that I
>> created the array, raid 1, with one live and one missing disk, then
>> added the second one later after writing a lot of data.
>> 
>> Also, though probably not the cause, I continued writing data while it
>> was syncing, and a couple times during the syncing, both drives
>> stopped responding and I had to power off.
>> 
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md127 : active raid1 sdd1[0] sdc1[2]
>>       1904568184 blocks super 1.2 [2/2] [UU]
>>       bitmap: 3/15 pages [12KB], 65536KB chunk
>> 
>> unused devices: <none>
>> 
>> # mdadm -X /dev/sd[dc]1
>>         Filename : /dev/sdc1
>>            Magic : 6d746962
>>          Version : 4
>>             UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74e
>>           Events : 40013
>>   Events Cleared : 40013
>>            State : OK
>>        Chunksize : 64 MB
>>           Daemon : 5s flush period
>>       Write Mode : Allow write behind, max 256
>>        Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
>>           Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
>>         Filename : /dev/sdd1
>>            Magic : 6d746962
>>          Version : 4
>>             UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74e
>>           Events : 40013
>>   Events Cleared : 40013
>>            State : OK
>>        Chunksize : 64 MB
>>           Daemon : 5s flush period
>>       Write Mode : Allow write behind, max 256
>>        Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
>>           Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
>
>I cannot see how this would be happening.  If any bits are set, then they
>will be cleared after 5 seconds, and then 5 seconds later the block holding
>the bits will be written out so that they will appear on disk to be cleared.
>
>I assume that if you write to the array, the 'dirty' count increases, but
>always goes back to three?
>
>And if you stop the array and start it again, the '3' stays there?
>
>If I sent you a patch to add some tracing information would you be able to
>compile a new kernel with that patch applied and see what it says?
>
>Thanks,
>
>NeilBrown
>
>
>> 
>> 
>> Quoting NeilBrown <neilb@suse.de>:
>> 
>> > On Thu, October 15, 2009 9:39 am, aristizb@ualberta.ca wrote:
>> >> Hello,
>> >>
>> >> I have a RAID1 with 2 LVM disks and I am running into a strange
>> >> situation where having the 2 disks connected to the array the bitmap
>> >> never clears the dirty chunks.
>> >
>> > That shouldn't happen...
>> > What versions of mdadm and the Linux kernel are you using?
>> >
>> > NeilBrown
>> >
>> >>
>> >> I am assuming also that when a RAID1 is in write-through mode, the
>> >> bitmap  indicates that all the data has made it to all the disks if
>> >> there are no dirty chunks using mdadm --examine-bitmap.
>> >>
>> >> The output of cat /proc/mdstat is:
>> >>
>> >> md2060 : active raid1 dm-5[1] dm-6[0]
>> >>        2252736 blocks [2/2] [UU]
>> >>        bitmap: 1/275 pages [12KB], 4KB chunk, file: /tmp/md2060bm
>> >>
>> >>
>> >> The output of mdadm --examine-bitmap /tmp/md2060bm is:
>> >>
>> >> Filename : md2060bm
>> >>             Magic : 6d746962
>> >>           Version : 4
>> >>              UUID : ad5fb74c:bb1c654a:087b2595:8a5d04a9
>> >>            Events : 12
>> >>    Events Cleared : 12
>> >>             State : OK
>> >>         Chunksize : 4 KB
>> >>            Daemon : 5s flush period
>> >>        Write Mode : Normal
>> >>         Sync Size : 2252736 (2.15 GiB 2.31 GB)
>> >>            Bitmap : 563184 bits (chunks), 3 dirty (0.0%)
>> >>
>> >>
>> >> Having the array under no IO, I waited 30 minutes but the dirty data
>> >> never gets clear from the bitmap, so I presume  the disks are not in
>> >> sync; but after I ran a block by block comparison of the two devices I
>> >> found that they are equal.
>> >>
>> >> The superblocks and the external bitmap tell me that all the events
>> >> are cleared, so I am confused on why the bitmap never goes to 0 dirty
>> >> chunks.
>> >>
>> >> How can I tell if the disks are in sync?
>> >>
>> >>
>> >> Thank you in advance for any help
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
