From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 12:45:42 +0100
Message-ID: <4D5D0A66.80608@texsoft.it>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217105815.GA24580@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/17/2011 11:58 AM, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 17, 2011 at 11:45:35AM +0100, David Brown wrote:
>> On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
>>> On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
>>>> On 17/02/11 00:01, NeilBrown wrote:
>>>>> On Wed, 16 Feb 2011 23:34:43 +0100 David Brown<david.brown@hesbyn=
ett.no>
>>>>> wrote:
>>>>>
>>>>>> I thought there was some mechanism for block devices to report b=
ad
>>>>>> blocks back to the file system, and that file systems tracked ba=
d block
>>>>>> lists.  Modern drives automatically relocate bad blocks (at leas=
t, they
>>>>>> do if they can), but there was a time when they did not and it w=
as up to
>>>>>> the file system to track these.  Whether that still applies to m=
odern
>>>>>> file systems, I do not know - they only file system I have studi=
ed in
>>>>>> low-level detail is FAT16.
>>>>> When the block device reports an error the filesystem can certain=
ly
>>>>> record
>>>>> that information in a bad-block list, and possibly does.
>>>>>
>>>>> However I thought you were suggesting a situation where the block=
 device
>>>>> could succeed with the request, but knew that area of the device =
was of
>>>>> low
>>>>> quality.
>>>> I guess that is what I was trying to suggest, though not very clea=
rly.
>>>>
>>>>> e.g. IO to a block on a stripe which had one 'bad block'.  The IO=
 should
>>>>> succeed, but the data isn't as safe as elsewhere.  It would be ni=
ce if we
>>>>> could tell the filesystem that fact, and if it could make use of =
it. But
>>>>> we
>>>>> currently cannot.   We can say "success" or "failure", but we can=
not say
>>>>> "success, but you might not be so lucky next time".
>>>>>
>>>> Do filesystems re-try reads when there is a failure?  Could you re=
turn
>>>> fail on one read, then success on a re-read, which could be interp=
reted
>>>> as "dying, but not yet dead" by the file system?
>>> This should not be a file system feature. The file system is built =
upon
>>> the raid, and in mirrorred raid types like raid1 and raid10, and al=
so
>>> other raid types, you cannot be sure which specific drive and secto=
r the
>>> data was read from - it could be one out of many (typically two) pl=
aces.
>>> So the bad blocks of a raid is a feature of the raid and its indivi=
dual
>>> drives, not the file system. If it was a property of the file syste=
m,
>>> then the fs should be aware of the underlying raid topology, and kn=
ow if
>>> this was a parity block or data block of raid5 or raid6, or which
>>> mirror instance of a raid1/10 type which  was involved.
>>>
>> Thanks for the explanation.
>>
>> I guess my worry is that if md layer has tracked a bad block on a di=
sk,
>> then that stripe will be in a degraded mode.  It's great that it wil=
l
>> still work, and it's great that the bad block list means that it is
>> /only/ that stripe that is degraded - not the whole raid.
> I am proposing that the stripe not be degraded, using a recovery area=
 for bad
> blocks on the disk, that goes together with the metadata area.
>
>> But I'm hoping there can be some sort of relocation somewhere
>> (ultimately it doesn't matter if it is handled by the file system, o=
r by
>> md for the whole stripe, or by md for just that disk block, or by th=
e
>> disk itself), so that you can get raid protection again for that str=
ipe.
> I think we agree in hoping:-)

IMHO the point is that this feature (Bad Block Log) is a GREAT feature=20
as it just helps in keeping track of the health status of the underlyin=
g=20
disks, and helps A LOT in recovering data from the array when a=20
unrecoverable read error occurs (now the full array goes offline). Then=
=20
something must be done proactively to repair the situation, as it means=
=20
that a disk of the array has problems and should be replaced. So, first=
=20
it's worth to make a backup of the still alive array (getting some read=
=20
error when the bad blocks/stripes are encountered [maybe using ddrescue=
=20
or similar]), then replace the disk, and reconstruct the array; after=20
that a fsck on the filesystem may repair the situation.

You may argue that the unrecoverable read error come from just very few=
=20
sector of the disk, and it's not worth to replace it (personally I woul=
d=20
replace also on very few ones), as there are still many reserverd=20
sectors for relocation on the disk. Then a simple solution would just b=
e=20
to zero-write the bad blocks in the Bad Block Log (the data is gone=20
already): if the write succedes (disk uses reserved sectors for=20
relocation), the blocks are removed from the log (now they are ok); the=
n=20
fsck (hopefully) may repair the filesystem. At this point there are no=20
more md read erros, maybe just filesystem errors (the array is clean,=20
the filesystem may be not, but notice that nothing can be done to avoid=
=20
filesystem problems, as there has been a data loss; only fsck may help)=
=2E

Regards

--=20
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
