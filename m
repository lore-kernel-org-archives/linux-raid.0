From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 01:13:32 +0100
Message-ID: <4D5DB9AC.10106@texsoft.it>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it> <20110217154440.GA24982@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217154440.GA24982@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 17, 2011 at 12:45:42PM +0100, Giovanni Tessore wrote:
>> On 02/17/2011 11:58 AM, Keld J=F8rn Simonsen wrote:
>>> On Thu, Feb 17, 2011 at 11:45:35AM +0100, David Brown wrote:
>>>> On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
>>>>> On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
>>>>>> On 17/02/11 00:01, NeilBrown wrote:
>>>>>>> On Wed, 16 Feb 2011 23:34:43 +0100 David
>>>>>>> Brown<david.brown@hesbynett.no>
>>>>>>> wrote:
>>>>>>>
>>>>>>>> I thought there was some mechanism for block devices to report=
 bad
>>>>>>>> blocks back to the file system, and that file systems tracked =
bad
>>>>>>>> block
>>>>>>>> lists.  Modern drives automatically relocate bad blocks (at le=
ast,
>>>>>>>> they
>>>>>>>> do if they can), but there was a time when they did not and it=
 was up
>>>>>>>> to
>>>>>>>> the file system to track these.  Whether that still applies to=
 modern
>>>>>>>> file systems, I do not know - they only file system I have stu=
died in
>>>>>>>> low-level detail is FAT16.
>>>>>>> When the block device reports an error the filesystem can certa=
inly
>>>>>>> record
>>>>>>> that information in a bad-block list, and possibly does.
>>>>>>>
>>>>>>> However I thought you were suggesting a situation where the blo=
ck
>>>>>>> device
>>>>>>> could succeed with the request, but knew that area of the devic=
e was of
>>>>>>> low
>>>>>>> quality.
>>>>>> I guess that is what I was trying to suggest, though not very cl=
early.
>>>>>>
>>>>>>> e.g. IO to a block on a stripe which had one 'bad block'.  The =
IO
>>>>>>> should
>>>>>>> succeed, but the data isn't as safe as elsewhere.  It would be =
nice if
>>>>>>> we
>>>>>>> could tell the filesystem that fact, and if it could make use o=
f it.
>>>>>>> But
>>>>>>> we
>>>>>>> currently cannot.   We can say "success" or "failure", but we c=
annot
>>>>>>> say
>>>>>>> "success, but you might not be so lucky next time".
>>>>>>>
>>>>>> Do filesystems re-try reads when there is a failure?  Could you =
return
>>>>>> fail on one read, then success on a re-read, which could be inte=
rpreted
>>>>>> as "dying, but not yet dead" by the file system?
>>>>> This should not be a file system feature. The file system is buil=
t upon
>>>>> the raid, and in mirrorred raid types like raid1 and raid10, and =
also
>>>>> other raid types, you cannot be sure which specific drive and sec=
tor the
>>>>> data was read from - it could be one out of many (typically two) =
places.
>>>>> So the bad blocks of a raid is a feature of the raid and its indi=
vidual
>>>>> drives, not the file system. If it was a property of the file sys=
tem,
>>>>> then the fs should be aware of the underlying raid topology, and =
know if
>>>>> this was a parity block or data block of raid5 or raid6, or which
>>>>> mirror instance of a raid1/10 type which  was involved.
>>>>>
>>>> Thanks for the explanation.
>>>>
>>>> I guess my worry is that if md layer has tracked a bad block on a =
disk,
>>>> then that stripe will be in a degraded mode.  It's great that it w=
ill
>>>> still work, and it's great that the bad block list means that it i=
s
>>>> /only/ that stripe that is degraded - not the whole raid.
>>> I am proposing that the stripe not be degraded, using a recovery ar=
ea for
>>> bad
>>> blocks on the disk, that goes together with the metadata area.
>>>
>>>> But I'm hoping there can be some sort of relocation somewhere
>>>> (ultimately it doesn't matter if it is handled by the file system,=
 or by
>>>> md for the whole stripe, or by md for just that disk block, or by =
the
>>>> disk itself), so that you can get raid protection again for that s=
tripe.
>>> I think we agree in hoping:-)
>> IMHO the point is that this feature (Bad Block Log) is a GREAT featu=
re
>> as it just helps in keeping track of the health status of the underl=
ying
>> disks, and helps A LOT in recovering data from the array when a
>> unrecoverable read error occurs (now the full array goes offline). T=
hen
>> something must be done proactively to repair the situation, as it me=
ans
>> that a disk of the array has problems and should be replaced. So, fi=
rst
>> it's worth to make a backup of the still alive array (getting some r=
ead
>> error when the bad blocks/stripes are encountered [maybe using ddres=
cue
>> or similar]), then replace the disk, and reconstruct the array; afte=
r
>> that a fsck on the filesystem may repair the situation.
>>
>> You may argue that the unrecoverable read error come from just very =
few
>> sector of the disk, and it's not worth to replace it (personally I w=
ould
>> replace also on very few ones), as there are still many reserverd
>> sectors for relocation on the disk. Then a simple solution would jus=
t be
>> to zero-write the bad blocks in the Bad Block Log (the data is gone
>> already): if the write succedes (disk uses reserved sectors for
>> relocation), the blocks are removed from the log (now they are ok); =
then
>> fsck (hopefully) may repair the filesystem. At this point there are =
no
>> more md read erros, maybe just filesystem errors (the array is clean=
,
>> the filesystem may be not, but notice that nothing can be done to av=
oid
>> filesystem problems, as there has been a data loss; only fsck may he=
lp).
> another way around, if the badblocks recovery area does not fly with
> Neil or other implementors.
>
> It should be possible to run a periodic check of if any bad sectors h=
ave
> occurred in an array. Then the half-damaged file should be moved away=
 from
> this area with the bad block by copying it and relinking it, and befo=
re
> relinking it to the proper place the good block corresponding to the =
bad
> block should be marked as a corresponding good block on the healthy d=
isk
> drive, so that it not be allocated again. This action could even be
> triggered by the event of the detection of the bad block. This would
> probably meean that ther need to be a system call to mark a
> corresponding good block. The whole thing should be able to run in
> userland and somewhat independent of the file system type, except for
> the lookup of the corresponding file fram a damaged block.

I don't follow this.. if a file has some damaged blocks, they are gone,=
=20
moving it elsewhere does not help.

And however, this is a task of the filesystem.

md is just a block device (more reliable than a single disk due to some=
=20
level of redundancy), and it should be indipendent from the kind of fil=
e=20
system on it (as the file system should be indipendent from the kind of=
=20
block device it resides on [md, hd, flash, iscsi, ...]).

Then what you suggest should be done for every block device that can=20
have bad blocks (that is, every block device). Again, this is a=20
filesystem issue. And of which file system type, as there are many?

The Bad Block Log allows md to behave 'like' a read hard disk would do=20
with smart data:
- unreadable blocks/stripes are recorded into the log, as unreadable=20
sectors are recorder into smart data
- unrecoverable read errors are reported to the caller for both
- the device still works if it has unrecoverable read errors for both=20
(now the whole md device fails, this is the problem)
- if a block/stripe if rewritten with success  the block/stripe is=20
removed from Bad Block Log (and the counter of relocated blocks/stripes=
=20
is incremented); as if a sector is rewritten with succes on a disk the=20
sector is removed from list of unreadable sector, and the counter of=20
relocated sector is incremented (smart data)

A filesystem on a disk does not know what the firmware of the disk does=
=20
about sectors relocation.
The same applies for a hardware (not fake) raid controller firmware.
The same should apply for md. It is transparent to the filesystem.

IMHO a more interesting issue whould be: a write error occurs on a disk=
=20
participating to an already degraded array; failing the disk would fail=
=20
the whole array. What to do? Put the array into read only mode, still=20
allowing read access to data on it for easy backup? In such situation,=20
what would do a hardware raid controller?

Hm, yes.... how do behave hardware raid controllers with uncorrectable=20
read errors?
And how they behave with write error on a disk of an already degraded a=
rray?
I guess md should replicate these behaviours.

=2E.. Neil?

Regards.

--=20
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
