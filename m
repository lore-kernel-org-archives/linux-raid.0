From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 10:47:28 +0100
Message-ID: <4D5E4030.8020805@texsoft.it>
References: <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it> <20110217154440.GA24982@www2.open-std.org> <4D5DB9AC.10106@texsoft.it> <20110218025623.GA26387@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218025623.GA26387@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2011 03:56 AM, Keld J=F8rn Simonsen wrote:
> On Fri, Feb 18, 2011 at 01:13:32AM +0100, Giovanni Tessore wrote:
>> On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
>>> It should be possible to run a periodic check of if any bad sectors=
 have
>>> occurred in an array. Then the half-damaged file should be moved aw=
ay from
>>> this area with the bad block by copying it and relinking it, and be=
fore
>>> relinking it to the proper place the good block corresponding to th=
e bad
>>> block should be marked as a corresponding good block on the healthy=
 disk
>>> drive, so that it not be allocated again. This action could even be
>>> triggered by the event of the detection of the bad block. This woul=
d
>>> probably meean that ther need to be a system call to mark a
>>> corresponding good block. The whole thing should be able to run in
>>> userland and somewhat independent of the file system type, except f=
or
>>> the lookup of the corresponding file fram a damaged block.
>> I don't follow this.. if a file has some damaged blocks, they are go=
ne,
>> moving it elsewhere does not help.
> Remember the file is in a RAID. So you can lose one disk drive and yo=
ur
> data is still intact.
>
>> And however, this is a task of the filesystem.
> No, it is the task of the raid, as it is the raid that gives the
> functionality that you can lose a drive and still have your data inta=
ct.
> the raid level knows what is lost, and  what is still good, and where
> this stuff is.
>
> If we are then operating on the file level, then doing something clev=
er could
> be a cooperation between the raid leven ald the filesystem level, as
> described above.

Raid of course has this functionality, but at block level; it's agnosti=
c=20
of the filesystem on it (there may be no filesystem at all actually, as=
=20
for raid over raid); it does not know the word 'file'.

Raid adds SOME level of redundancy, not infinite. If the underlying=20
hardware has damaged sectors over the redundancy level of the raid=20
configuration, data in the stripe is lost; and the hardware probably=20
should be replaced.

Unrecoverable read errors FROM MD (those addressed by Bad Block Log=20
feature) only appear when this redudancy level is not enough; for examp=
le:
- raid 1 in degraded mode with only 1 disk active, read error on the=20
remaning disk
- raid 5 in degraded mode, read error on one of the active disks
- raid 6 in degraded mode missing 2 disks, read error on one of the=20
active disks
- raid 5, read error on the same sector on more than 1 disk
- raid 6, read error on the same sector on more than 2 disks
- etc ...

in this situation nothing can be done neither at md level, nor at=20
filesytem level: data on the block/stripe is lost.

Remeber that the Bad Block Log keeps track of the block/stripes who gav=
e=20
this unrecoverable read error at md level. It has nothing to do with th=
e=20
unreadable sector list of the underlying disks: if raid gets a read=20
error from a disk, it tries to reconstruct data from the other disks,=20
and to rewrite the sector; if it succedes, all is ok for md (it just=20
increments the counter of corrected read errors, which is persistent fo=
r=20
superblock > 1.x); otherwise there is a write error, and the disk is=20
marked as failed.


>
>> md is just a block device (more reliable than a single disk due to s=
ome
>> level of redundancy), and it should be indipendent from the kind of =
file
>> system on it (as the file system should be indipendent from the kind=
 of
>> block device it resides on [md, hd, flash, iscsi, ...]).
> true
>
>> Then what you suggest should be done for every block device that can
>> have bad blocks (that is, every block device). Again, this is a
>> filesystem issue. And of which file system type, as there are many?
> yes, it is a cooperation between the file system layer, and the raid
> layer, I propose this be done in userland.
>
>> The Bad Block Log allows md to behave 'like' a read hard disk would =
do
>> with smart data:
>> - unreadable blocks/stripes are recorded into the log, as unreadable
>> sectors are recorder into smart data
>> - unrecoverable read errors are reported to the caller for both
>> - the device still works if it has unrecoverable read errors for bot=
h
>> (now the whole md device fails, this is the problem)
>> - if a block/stripe if rewritten with success  the block/stripe is
>> removed from Bad Block Log (and the counter of relocated blocks/stri=
pes
>> is incremented); as if a sector is rewritten with succes on a disk t=
he
>> sector is removed from list of unreadable sector, and the counter of
>> relocated sector is incremented (smart data)
> Smart drives also reallocate bad blocks, hiding the errors from the S=
W
> level.

And that is the only natural place where this operation should be done.=
=20
Suppose you got a unrecoverable read error from md on a block. It means=
=20
that some sector on one (or more) of the underlying disks gave a read=20
error. If you try to rewrite the md block, the sectors are rewritten to=
=20
the underlying disk, so either:
- all disks write correctly because they could solve the prolem (its a=20
matter of their firmware, maybe relocating the sector on reserved area)=
:=20
block relocated, all OK.
- some disks give an error on write (no more space for relocatable=20
errors, or other hw problems): then the disk(s) is(are) marked failed,=20
and must be replaced.
There is no need for reserved blocks anywhere else than those of the=20
underlying disks.

Having reserved relocable blocks at raid level would be usefull to=20
address another situation: uncorrectable errors on write. But this is=20
another story.

>> A filesystem on a disk does not know what the firmware of the disk d=
oes
>> about sectors relocation.
>> The same applies for a hardware (not fake) raid controller firmware.
>> The same should apply for md. It is transparent to the filesystem.
> Yes, normally the raid layer and the fs layer are independent.
>
> But you can add better recovery with what I suggest.
>
>> IMHO a more interesting issue whould be: a write error occurs on a d=
isk
>> participating to an already degraded array; failing the disk would f=
ail
>> the whole array. What to do? Put the array into read only mode, stil=
l
>> allowing read access to data on it for easy backup? In such situatio=
n,
>> what would do a hardware raid controller?
>>
>> Hm, yes.... how do behave hardware raid controllers with uncorrectab=
le
>> read errors?
>> And how they behave with write error on a disk of an already degrade=
d array?
>> I guess md should replicate these behaviours.
> I think we should be more intelligent than ordinary HW RAID:-)

I think it is a good point if the software raid had the same features=20
and reliability of those mission critical hw controllers ;-)

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
