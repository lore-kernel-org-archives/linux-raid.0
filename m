From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sat, 20 Apr 2013 15:44:20 +0200
Message-ID: <51729BB4.7010308@schinagl.nl>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <20130418143805.GA6558@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418143805.GA6558@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/18/13 16:38, Robin Hill wrote:
> On Thu Apr 18, 2013 at 03:17:15PM +0200, Ben Bucksch wrote:
>
>> To re-summarize (for full info, see first post of thread):
>> * There are 2 RAID5 arrays in the machine, each have 8 disks.
>> * I upgraded Ubuntu 10.04 to 12.04.
>> * After reboot, both arrays had each ejected one disk.
>>     The ejected disks are working fine (at least now).
>> * During the resync mandated by above ejection,
>>      one other drive failed, this one fatally with a real hardware failure.
>> * The second array resynced fine, further proving that the
>>      disks ejected during upgrade were working.
>> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
>>     1 disk with hardware failure, and 1 disk that was ejected, but is
>> working.
>> * The latter is currently marked "spare" by md and has an event count
>>     (only) 2 events lower than the other 6 disks.
>> * My task is to get the latter disk back online *with* its data, without
>> resync.
>>
>> I desperately need help, please.
>>
>> Based on suggestions here by Oliver and on forums, I did (and the result
>> is):
>>
>>> # mdadm --stop /dev/md0
>>> mdadm: stopped /dev/md0
>>> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
>>> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
>>> mdadm: Not enough devices to start the array.
>>> # cat /proc/mdstat
>>> md0 : inactive sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>>>        5860574976 blocks
>>> (Note that sdl is not even listed)
>>> # mdadm --re-add /dev/md0 /dev/sdl
>>> mdadm: re-added /dev/sdl
>>> # cat /proc/mdstat
>>> md0 : inactive sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>>>        6837337472 blocks
>>>
> That won't work here as sdl was being rebuilt at the time of the
> failure. md therefore 'knows' that it doesn't have the correct data on
> and can't be used to assemble the array (I think the array position of
> the disk is only written to the metadata when recovery completes).
>
>>> Now, sdl is listed, but as spare. I need it to be treated not as
>>> spare, but as good drive with correct data (well, almost, 2 events off
>>> only). How do I do that?
>>>
> I can see two options here:
>
> - Image the known faulty disk to a new one and then use that to force
>    assemble the array (with the possibility of some data loss, depending
>    on how much can be read from the faulty disk).
IF you have an extra spare disk, this probably is the best idea then. 
The event count might not even be off at all.

Use ddrescue though, check the options and possibilities, going start -> 
end and end -> start Let is try very often. You get the idea.

You could use the spare disk for this, but that removes any option in 
trying to recover using that. (Hex editing the superblock, possible but 
not easy). IF you have enough room on the other array, you can always dd 
if=/dev/spare of=file_on_array

Also, make a backup of your superblock!! dd if=/dev/sd* 
of=sd*.superblock size=<superblocksize> count=1

> - Modify the metadata on sdl so that it shows as being a valid member of
>    the array. This will require either manual editing of the superblock,
>    or rerunning the "mdadm --create" command with the correct mdadm
>    version (so data offsets match), disk order and parameters (chunk
>    size, etc). If done correctly then there should be no data loss
>    (providing that sdl, when re-added to the array, used the same data
>    offset as it originally had), but get anything wrong any you'll be
>    even further up the creek.
>
> Personally I'd look into option one first. Despite the probability of
> some data loss, I think it's a lower risk option overall.
I agree, best option would be that

oliver
>
> Cheers,
>      Robin
>

