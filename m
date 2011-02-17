From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 14:22:33 -0200
Message-ID: <AANLkTikS+Kzia-oBnB6W1Xnyd-c39oF+GdZhU8BjPBXa@mail.gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
	<ijgr9p$7v8$1@dough.gmane.org>
	<20110217083531.3090a348@notabene.brown>
	<ijhje3$ocd$1@dough.gmane.org>
	<20110217100139.7520893d@notabene.brown>
	<ijhq7p$pjv$1@dough.gmane.org>
	<20110217010455.GA16324@www2.open-std.org>
	<ijiu99$ill$1@dough.gmane.org>
	<20110217105815.GA24580@www2.open-std.org>
	<4D5D0A66.80608@texsoft.it>
	<20110217154440.GA24982@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217154440.GA24982@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

another question, out of bad block, but related to write-behind
in mysql ndb, i can run many machines in the cluster, in a write, if 2
machines return commit OK, nbd put all others machines to async write,
it=B4s nice, because speed is improved and i have 1 computer redudancy,
could we implement a diferent write-behind method? i was talking about
it in another email thread
something like:
select what disks must be write-mostly (only read if all mirrors are fa=
iled)
select what disks MUST be commited (sync)
select what disks MUST be write-behind (async)
select what disks can be automatic (sync/async, if X disks are
commited theses disks are automatic write-behind, after write they get
backto non write-behind, idon=B4t see a solution at userspace, just at
kernel space)
itwil help a mix of raid1 with slow and fast disks, maybe the problem
of accesstime can be reduced for harddisks, the raid1 isn=B4t more
slowest disk speed for write
check that write-mostly is for read_balance
write-behind for write command

2011/2/17 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Thu, Feb 17, 2011 at 12:45:42PM +0100, Giovanni Tessore wrote:
>> On 02/17/2011 11:58 AM, Keld J=F8rn Simonsen wrote:
>> >On Thu, Feb 17, 2011 at 11:45:35AM +0100, David Brown wrote:
>> >>On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
>> >>>On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
>> >>>>On 17/02/11 00:01, NeilBrown wrote:
>> >>>>>On Wed, 16 Feb 2011 23:34:43 +0100 David
>> >>>>>Brown<david.brown@hesbynett.no>
>> >>>>>wrote:
>> >>>>>
>> >>>>>>I thought there was some mechanism for block devices to report=
 bad
>> >>>>>>blocks back to the file system, and that file systems tracked =
bad
>> >>>>>>block
>> >>>>>>lists. =A0Modern drives automatically relocate bad blocks (at =
least,
>> >>>>>>they
>> >>>>>>do if they can), but there was a time when they did not and it=
 was up
>> >>>>>>to
>> >>>>>>the file system to track these. =A0Whether that still applies =
to modern
>> >>>>>>file systems, I do not know - they only file system I have stu=
died in
>> >>>>>>low-level detail is FAT16.
>> >>>>>When the block device reports an error the filesystem can certa=
inly
>> >>>>>record
>> >>>>>that information in a bad-block list, and possibly does.
>> >>>>>
>> >>>>>However I thought you were suggesting a situation where the blo=
ck
>> >>>>>device
>> >>>>>could succeed with the request, but knew that area of the devic=
e was of
>> >>>>>low
>> >>>>>quality.
>> >>>>I guess that is what I was trying to suggest, though not very cl=
early.
>> >>>>
>> >>>>>e.g. IO to a block on a stripe which had one 'bad block'. =A0Th=
e IO
>> >>>>>should
>> >>>>>succeed, but the data isn't as safe as elsewhere. =A0It would b=
e nice if
>> >>>>>we
>> >>>>>could tell the filesystem that fact, and if it could make use o=
f it.
>> >>>>>But
>> >>>>>we
>> >>>>>currently cannot. =A0 We can say "success" or "failure", but we=
 cannot
>> >>>>>say
>> >>>>>"success, but you might not be so lucky next time".
>> >>>>>
>> >>>>Do filesystems re-try reads when there is a failure? =A0Could yo=
u return
>> >>>>fail on one read, then success on a re-read, which could be inte=
rpreted
>> >>>>as "dying, but not yet dead" by the file system?
>> >>>This should not be a file system feature. The file system is buil=
t upon
>> >>>the raid, and in mirrorred raid types like raid1 and raid10, and =
also
>> >>>other raid types, you cannot be sure which specific drive and sec=
tor the
>> >>>data was read from - it could be one out of many (typically two) =
places.
>> >>>So the bad blocks of a raid is a feature of the raid and its indi=
vidual
>> >>>drives, not the file system. If it was a property of the file sys=
tem,
>> >>>then the fs should be aware of the underlying raid topology, and =
know if
>> >>>this was a parity block or data block of raid5 or raid6, or which
>> >>>mirror instance of a raid1/10 type which =A0was involved.
>> >>>
>> >>Thanks for the explanation.
>> >>
>> >>I guess my worry is that if md layer has tracked a bad block on a =
disk,
>> >>then that stripe will be in a degraded mode. =A0It's great that it=
 will
>> >>still work, and it's great that the bad block list means that it i=
s
>> >>/only/ that stripe that is degraded - not the whole raid.
>> >I am proposing that the stripe not be degraded, using a recovery ar=
ea for
>> >bad
>> >blocks on the disk, that goes together with the metadata area.
>> >
>> >>But I'm hoping there can be some sort of relocation somewhere
>> >>(ultimately it doesn't matter if it is handled by the file system,=
 or by
>> >>md for the whole stripe, or by md for just that disk block, or by =
the
>> >>disk itself), so that you can get raid protection again for that s=
tripe.
>> >I think we agree in hoping:-)
>>
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
>
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
>
> best regards
> Keld
>
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
