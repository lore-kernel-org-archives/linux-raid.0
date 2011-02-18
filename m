From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 19:43:29 +0100
Message-ID: <20110218184329.GA2297@www2.open-std.org>
References: <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it> <20110217154440.GA24982@www2.open-std.org> <4D5DB9AC.10106@texsoft.it> <20110218025623.GA26387@www2.open-std.org> <4D5E4030.8020805@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5E4030.8020805@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 18, 2011 at 10:47:28AM +0100, Giovanni Tessore wrote:
> On 02/18/2011 03:56 AM, Keld J=F8rn Simonsen wrote:
> >On Fri, Feb 18, 2011 at 01:13:32AM +0100, Giovanni Tessore wrote:
> >>On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
> >>>It should be possible to run a periodic check of if any bad sector=
s have
> >>>occurred in an array. Then the half-damaged file should be moved a=
way=20
> >>>from
> >>>this area with the bad block by copying it and relinking it, and b=
efore
> >>>relinking it to the proper place the good block corresponding to t=
he bad
> >>>block should be marked as a corresponding good block on the health=
y disk
> >>>drive, so that it not be allocated again. This action could even b=
e
> >>>triggered by the event of the detection of the bad block. This wou=
ld
> >>>probably meean that ther need to be a system call to mark a
> >>>corresponding good block. The whole thing should be able to run in
> >>>userland and somewhat independent of the file system type, except =
for
> >>>the lookup of the corresponding file fram a damaged block.
> >>I don't follow this.. if a file has some damaged blocks, they are g=
one,
> >>moving it elsewhere does not help.
> >Remember the file is in a RAID. So you can lose one disk drive and y=
our
> >data is still intact.
> >
> >>And however, this is a task of the filesystem.
> >No, it is the task of the raid, as it is the raid that gives the
> >functionality that you can lose a drive and still have your data int=
act.
> >the raid level knows what is lost, and  what is still good, and wher=
e
> >this stuff is.
> >
> >If we are then operating on the file level, then doing something cle=
ver=20
> >could
> >be a cooperation between the raid leven ald the filesystem level, as
> >described above.
>=20
> Raid of course has this functionality, but at block level; it's agnos=
tic=20
> of the filesystem on it (there may be no filesystem at all actually, =
as=20
> for raid over raid); it does not know the word 'file'.

true

> Raid adds SOME level of redundancy, not infinite. If the underlying=20
> hardware has damaged sectors over the redundancy level of the raid=20
> configuration, data in the stripe is lost; and the hardware probably=20
> should be replaced.
>=20
> Unrecoverable read errors FROM MD (those addressed by Bad Block Log=20
> feature) only appear when this redudancy level is not enough; for exa=
mple:
> - raid 1 in degraded mode with only 1 disk active, read error on the=20
> remaning disk
> - raid 5 in degraded mode, read error on one of the active disks
> - raid 6 in degraded mode missing 2 disks, read error on one of the=20
> active disks
> - raid 5, read error on the same sector on more than 1 disk
> - raid 6, read error on the same sector on more than 2 disks
> - etc ...
>=20
> in this situation nothing can be done neither at md level, nor at=20
> filesytem level: data on the block/stripe is lost.

true too.

My idea was to do something when the MD RAID shifts into the degraded
states listed above. Not when the MD RAID is in the stats listed above,
and getting yet another error.

>=20
> Remeber that the Bad Block Log keeps track of the block/stripes who g=
ave=20
> this unrecoverable read error at md level. It has nothing to do with =
the=20
> unreadable sector list of the underlying disks: if raid gets a read=20
> error from a disk, it tries to reconstruct data from the other disks,=
=20
> and to rewrite the sector; if it succedes, all is ok for md (it just=20
> increments the counter of corrected read errors, which is persistent =
for=20
> superblock > 1.x); otherwise there is a write error, and the disk is=20
> marked as failed.

Yes, this is current behaviour.=20

I propose that this be changed, in conjunctio with a badblock raid
feature. Supposedly the write (or read) error wil become registered wit=
h
a new badblock log. And there will be generated a report email to the
administrator or some such with notification of the event, repoting the
errpr on the disk as a read or write error, at a specific disk drive an=
d
a specific block.

I would then like a program in userland that from the specified
information looks up the semi-damaged file in the file system,
tries to copy the file, and then sets a flag on other healthy blocks
related the the newly identified badblock for the related badblogs logs
for the healthy drives, so that it would generate an error if the block=
=20
is attempetd to be used again.

Or alternatively, I would like reallloc of the badblock in the damaged
drive, given that there be set aside an area of the RAID metadata
foor badblock realloc (in a manner similar to what is done for many dis=
k
drive HW. I think I prefer the latter solution.



>=20
> >
> >>md is just a block device (more reliable than a single disk due to =
some
> >>level of redundancy), and it should be indipendent from the kind of=
 file
> >>system on it (as the file system should be indipendent from the kin=
d of
> >>block device it resides on [md, hd, flash, iscsi, ...]).
> >true
> >
> >>Then what you suggest should be done for every block device that ca=
n
> >>have bad blocks (that is, every block device). Again, this is a
> >>filesystem issue. And of which file system type, as there are many?
> >yes, it is a cooperation between the file system layer, and the raid
> >layer, I propose this be done in userland.
> >
> >>The Bad Block Log allows md to behave 'like' a read hard disk would=
 do
> >>with smart data:
> >>- unreadable blocks/stripes are recorded into the log, as unreadabl=
e
> >>sectors are recorder into smart data
> >>- unrecoverable read errors are reported to the caller for both
> >>- the device still works if it has unrecoverable read errors for bo=
th
> >>(now the whole md device fails, this is the problem)
> >>- if a block/stripe if rewritten with success  the block/stripe is
> >>removed from Bad Block Log (and the counter of relocated blocks/str=
ipes
> >>is incremented); as if a sector is rewritten with succes on a disk =
the
> >>sector is removed from list of unreadable sector, and the counter o=
f
> >>relocated sector is incremented (smart data)
> >Smart drives also reallocate bad blocks, hiding the errors from the =
SW
> >level.
>=20
> And that is the only natural place where this operation should be don=
e.=20
> Suppose you got a unrecoverable read error from md on a block. It mea=
ns=20
> that some sector on one (or more) of the underlying disks gave a read=
=20
> error. If you try to rewrite the md block, the sectors are rewritten =
to=20
> the underlying disk, so either:
> - all disks write correctly because they could solve the prolem (its =
a=20
> matter of their firmware, maybe relocating the sector on reserved are=
a):=20
> block relocated, all OK.
> - some disks give an error on write (no more space for relocatable=20
> errors, or other hw problems): then the disk(s) is(are) marked failed=
,=20
> and must be replaced.
> There is no need for reserved blocks anywhere else than those of the=20
> underlying disks.
>=20
> Having reserved relocable blocks at raid level would be usefull to=20
> address another situation: uncorrectable errors on write. But this is=
=20
> another story.

I agree.

> >>A filesystem on a disk does not know what the firmware of the disk =
does
> >>about sectors relocation.
> >>The same applies for a hardware (not fake) raid controller firmware=
=2E
> >>The same should apply for md. It is transparent to the filesystem.
> >Yes, normally the raid layer and the fs layer are independent.
> >
> >But you can add better recovery with what I suggest.
> >
> >>IMHO a more interesting issue whould be: a write error occurs on a =
disk
> >>participating to an already degraded array; failing the disk would =
fail
> >>the whole array. What to do? Put the array into read only mode, sti=
ll
> >>allowing read access to data on it for easy backup? In such situati=
on,
> >>what would do a hardware raid controller?
> >>
> >>Hm, yes.... how do behave hardware raid controllers with uncorrecta=
ble
> >>read errors?
> >>And how they behave with write error on a disk of an already degrad=
ed=20
> >>array?
> >>I guess md should replicate these behaviours.
> >I think we should be more intelligent than ordinary HW RAID:-)
>=20
> I think it is a good point if the software raid had the same features=
=20
> and reliability of those mission critical hw controllers ;-)

yes we can hope for such implementation.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
