From: "NeilBrown" <neilb@suse.de>
Subject: Re: Resize Raid5 devices
Date: Sun, 21 Jun 2009 07:26:32 +1000 (EST)
Message-ID: <2a8e1e3ff2ac1abf41673992b3b24c47.squirrel@neil.brown.name>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de>
    <87tz2e7xqt.fsf@frosties.localdomain>
    <4CB2808F-EB88-458A-9D2B-22E31A97EB4F@bj-ig.de>
    <19002.61619.121746.923481@notabene.brown>
    <F1460A31-578A-4F80-8209-C56B47FBA367@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F1460A31-578A-4F80-8209-C56B47FBA367@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ralf =?iso-8859-1?Q?M=FCller?= <ralf@bj-ig.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, June 21, 2009 12:21 am, Ralf M=FCller wrote:
>
> Am 19.06.2009 um 03:58 schrieb Neil Brown:
>>>> When you added it back the event counter would differ and the
>>>> disk needs to be resynced completly. A bitmap would help limiting
>>>> this
>>>> to the parts that have changed. Add an internal bitmap before you
>>>> remove the next disk.
>>>
>>> There is an internal write intent bitmap at the array:
>>> DatenGrab:/media # cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4] [raid1]
>>> md3 : active raid5 sdf1[3] sdi1[0] sdj1[4] sdh1[1]
>>>      3457099008 blocks super 1.2 level 5, 256k chunk, algorithm 2
>>> [4/4] [UUUU]
>>>      bitmap: 0/275 pages [0KB], 2048KB chunk
>>>
>>> Do you have an idea why this bitmap has been ignored?
>>
>> Probably a kernel bug.  There have been a couple of fixes relating t=
o
>> this since 2.6.25.  Hopefully it is all working in 2.6.30...
>>
>> The bug that you hit was probably the one fixed by
>>  commit a0da84f35b25875870270d16b6eccda4884d61a7
>> which is in 2.6.27.
>
> Just for your information: I updated to OpenSuSE 11.1
> (kernel 2.6.27.23-0.1) and tried to remove, grow, re-add the other
> devices. For the first disk it worked - re-add took nearly no time
> because of the bitmap. For the second disk - it did not work: complet=
e
> resync triggered. No idea why. It has been the same sequence of
> commands on the same kind of device. There were no filesystem write
> operations on the raid while updating.

Thanks for keeping us informed.
The was another bug related to this that was fixed much more recently -
in 2.6.30 I think.
commit d0a4bb492772ce5c4bdfba3744a99ed6f6fb238f

I think it was a lot harder to hit, but maybe you hit it.

>
> I will wait for the resync to complete, offline the array, grow the
> last device and reassemble with "--update=3Ddevicesize". Would there
> have been a way to update the recorded device-size of the member
> devices online? If the fail/grow/re-add cycle would have worked, I
> still would have superblocks with the old size - right?

With a recent kernel, you can write "0" (or some other size
in sectors) to /sys/block/mdX/md/dev-YYY/size, and it will update the
device size online.  That functionality appeared in 2.6.26 so
OpenSUSE 11.1 should have it.

Yes - after fail/grow/re-add, the size recored in the metadata is
unchanged.  You need to increase the size on each device as described
above or with --update=3Ddevicesize during assemble, then update the
size of the array using "mdadm --grow --size=3Dmax /dev/mdX".

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
