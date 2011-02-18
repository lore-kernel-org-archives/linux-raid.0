From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 17:00:27 -0200
Message-ID: <AANLkTinYkEsaWinaz4LaOBpT36+fpizCSFO=AfH7sWEA@mail.gmail.com>
References: <20110217100139.7520893d@notabene.brown>
	<ijhq7p$pjv$1@dough.gmane.org>
	<20110217010455.GA16324@www2.open-std.org>
	<ijiu99$ill$1@dough.gmane.org>
	<20110217105815.GA24580@www2.open-std.org>
	<4D5D0A66.80608@texsoft.it>
	<20110217154440.GA24982@www2.open-std.org>
	<4D5DB9AC.10106@texsoft.it>
	<20110218025623.GA26387@www2.open-std.org>
	<4D5E4030.8020805@texsoft.it>
	<20110218184329.GA2297@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218184329.GA2297@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

again... for realloc we need TRIM command or reserved sectors just for
bad block realloc, TRIM command tell MD what sector isn=B4t in use, at
WRITE command MD set the sector as inuse, at array creation md set
sector as inuse too. this will only work with ext4 and swap, others
filesystem don=B4t have TRIM. the solution of others filesystem are
based on not used block, but it=B4s a internal logic of each filesystem=
=2E
i don=B4t know what is best, TRIM command is nice (we can send TRIM to
disks, this help to make their life bigger) a bad block is a disk
getting smaller and smaller, the disk can realloc badblock. if it
cant, filesystem should realloc it (it have more information about
logic device, it shouldn=B4t, TRIM command is the information that disk
should have to discart blocks, not a filesystem logic, but... it=B4s a
option, filesystem can realloc)

2011/2/18 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Fri, Feb 18, 2011 at 10:47:28AM +0100, Giovanni Tessore wrote:
>> On 02/18/2011 03:56 AM, Keld J=F8rn Simonsen wrote:
>> >On Fri, Feb 18, 2011 at 01:13:32AM +0100, Giovanni Tessore wrote:
>> >>On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
>> >>>It should be possible to run a periodic check of if any bad secto=
rs have
>> >>>occurred in an array. Then the half-damaged file should be moved =
away
>> >>>from
>> >>>this area with the bad block by copying it and relinking it, and =
before
>> >>>relinking it to the proper place the good block corresponding to =
the bad
>> >>>block should be marked as a corresponding good block on the healt=
hy disk
>> >>>drive, so that it not be allocated again. This action could even =
be
>> >>>triggered by the event of the detection of the bad block. This wo=
uld
>> >>>probably meean that ther need to be a system call to mark a
>> >>>corresponding good block. The whole thing should be able to run i=
n
>> >>>userland and somewhat independent of the file system type, except=
 for
>> >>>the lookup of the corresponding file fram a damaged block.
>> >>I don't follow this.. if a file has some damaged blocks, they are =
gone,
>> >>moving it elsewhere does not help.
>> >Remember the file is in a RAID. So you can lose one disk drive and =
your
>> >data is still intact.
>> >
>> >>And however, this is a task of the filesystem.
>> >No, it is the task of the raid, as it is the raid that gives the
>> >functionality that you can lose a drive and still have your data in=
tact.
>> >the raid level knows what is lost, and =A0what is still good, and w=
here
>> >this stuff is.
>> >
>> >If we are then operating on the file level, then doing something cl=
ever
>> >could
>> >be a cooperation between the raid leven ald the filesystem level, a=
s
>> >described above.
>>
>> Raid of course has this functionality, but at block level; it's agno=
stic
>> of the filesystem on it (there may be no filesystem at all actually,=
 as
>> for raid over raid); it does not know the word 'file'.
>
> true
>
>> Raid adds SOME level of redundancy, not infinite. If the underlying
>> hardware has damaged sectors over the redundancy level of the raid
>> configuration, data in the stripe is lost; and the hardware probably
>> should be replaced.
>>
>> Unrecoverable read errors FROM MD (those addressed by Bad Block Log
>> feature) only appear when this redudancy level is not enough; for ex=
ample:
>> - raid 1 in degraded mode with only 1 disk active, read error on the
>> remaning disk
>> - raid 5 in degraded mode, read error on one of the active disks
>> - raid 6 in degraded mode missing 2 disks, read error on one of the
>> active disks
>> - raid 5, read error on the same sector on more than 1 disk
>> - raid 6, read error on the same sector on more than 2 disks
>> - etc ...
>>
>> in this situation nothing can be done neither at md level, nor at
>> filesytem level: data on the block/stripe is lost.
>
> true too.
>
> My idea was to do something when the MD RAID shifts into the degraded
> states listed above. Not when the MD RAID is in the stats listed abov=
e,
> and getting yet another error.
>
>>
>> Remeber that the Bad Block Log keeps track of the block/stripes who =
gave
>> this unrecoverable read error at md level. It has nothing to do with=
 the
>> unreadable sector list of the underlying disks: if raid gets a read
>> error from a disk, it tries to reconstruct data from the other disks=
,
>> and to rewrite the sector; if it succedes, all is ok for md (it just
>> increments the counter of corrected read errors, which is persistent=
 for
>> superblock > 1.x); otherwise there is a write error, and the disk is
>> marked as failed.
>
> Yes, this is current behaviour.
>
> I propose that this be changed, in conjunctio with a badblock raid
> feature. Supposedly the write (or read) error wil become registered w=
ith
> a new badblock log. And there will be generated a report email to the
> administrator or some such with notification of the event, repoting t=
he
> errpr on the disk as a read or write error, at a specific disk drive =
and
> a specific block.
>
> I would then like a program in userland that from the specified
> information looks up the semi-damaged file in the file system,
> tries to copy the file, and then sets a flag on other healthy blocks
> related the the newly identified badblock for the related badblogs lo=
gs
> for the healthy drives, so that it would generate an error if the blo=
ck
> is attempetd to be used again.
>
> Or alternatively, I would like reallloc of the badblock in the damage=
d
> drive, given that there be set aside an area of the RAID metadata
> foor badblock realloc (in a manner similar to what is done for many d=
isk
> drive HW. I think I prefer the latter solution.
>
>
>
>>
>> >
>> >>md is just a block device (more reliable than a single disk due to=
 some
>> >>level of redundancy), and it should be indipendent from the kind o=
f file
>> >>system on it (as the file system should be indipendent from the ki=
nd of
>> >>block device it resides on [md, hd, flash, iscsi, ...]).
>> >true
>> >
>> >>Then what you suggest should be done for every block device that c=
an
>> >>have bad blocks (that is, every block device). Again, this is a
>> >>filesystem issue. And of which file system type, as there are many=
?
>> >yes, it is a cooperation between the file system layer, and the rai=
d
>> >layer, I propose this be done in userland.
>> >
>> >>The Bad Block Log allows md to behave 'like' a read hard disk woul=
d do
>> >>with smart data:
>> >>- unreadable blocks/stripes are recorded into the log, as unreadab=
le
>> >>sectors are recorder into smart data
>> >>- unrecoverable read errors are reported to the caller for both
>> >>- the device still works if it has unrecoverable read errors for b=
oth
>> >>(now the whole md device fails, this is the problem)
>> >>- if a block/stripe if rewritten with success =A0the block/stripe =
is
>> >>removed from Bad Block Log (and the counter of relocated blocks/st=
ripes
>> >>is incremented); as if a sector is rewritten with succes on a disk=
 the
>> >>sector is removed from list of unreadable sector, and the counter =
of
>> >>relocated sector is incremented (smart data)
>> >Smart drives also reallocate bad blocks, hiding the errors from the=
 SW
>> >level.
>>
>> And that is the only natural place where this operation should be do=
ne.
>> Suppose you got a unrecoverable read error from md on a block. It me=
ans
>> that some sector on one (or more) of the underlying disks gave a rea=
d
>> error. If you try to rewrite the md block, the sectors are rewritten=
 to
>> the underlying disk, so either:
>> - all disks write correctly because they could solve the prolem (its=
 a
>> matter of their firmware, maybe relocating the sector on reserved ar=
ea):
>> block relocated, all OK.
>> - some disks give an error on write (no more space for relocatable
>> errors, or other hw problems): then the disk(s) is(are) marked faile=
d,
>> and must be replaced.
>> There is no need for reserved blocks anywhere else than those of the
>> underlying disks.
>>
>> Having reserved relocable blocks at raid level would be usefull to
>> address another situation: uncorrectable errors on write. But this i=
s
>> another story.
>
> I agree.
>
>> >>A filesystem on a disk does not know what the firmware of the disk=
 does
>> >>about sectors relocation.
>> >>The same applies for a hardware (not fake) raid controller firmwar=
e.
>> >>The same should apply for md. It is transparent to the filesystem.
>> >Yes, normally the raid layer and the fs layer are independent.
>> >
>> >But you can add better recovery with what I suggest.
>> >
>> >>IMHO a more interesting issue whould be: a write error occurs on a=
 disk
>> >>participating to an already degraded array; failing the disk would=
 fail
>> >>the whole array. What to do? Put the array into read only mode, st=
ill
>> >>allowing read access to data on it for easy backup? In such situat=
ion,
>> >>what would do a hardware raid controller?
>> >>
>> >>Hm, yes.... how do behave hardware raid controllers with uncorrect=
able
>> >>read errors?
>> >>And how they behave with write error on a disk of an already degra=
ded
>> >>array?
>> >>I guess md should replicate these behaviours.
>> >I think we should be more intelligent than ordinary HW RAID:-)
>>
>> I think it is a good point if the software raid had the same feature=
s
>> and reliability of those mission critical hw controllers ;-)
>
> yes we can hope for such implementation.
>
> Best regards
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
