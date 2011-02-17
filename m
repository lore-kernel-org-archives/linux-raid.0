From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 16:44:40 +0100
Message-ID: <20110217154440.GA24982@www2.open-std.org>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5D0A66.80608@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 17, 2011 at 12:45:42PM +0100, Giovanni Tessore wrote:
> On 02/17/2011 11:58 AM, Keld J=F8rn Simonsen wrote:
> >On Thu, Feb 17, 2011 at 11:45:35AM +0100, David Brown wrote:
> >>On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
> >>>On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
> >>>>On 17/02/11 00:01, NeilBrown wrote:
> >>>>>On Wed, 16 Feb 2011 23:34:43 +0100 David=20
> >>>>>Brown<david.brown@hesbynett.no>
> >>>>>wrote:
> >>>>>
> >>>>>>I thought there was some mechanism for block devices to report =
bad
> >>>>>>blocks back to the file system, and that file systems tracked b=
ad=20
> >>>>>>block
> >>>>>>lists.  Modern drives automatically relocate bad blocks (at lea=
st,=20
> >>>>>>they
> >>>>>>do if they can), but there was a time when they did not and it =
was up=20
> >>>>>>to
> >>>>>>the file system to track these.  Whether that still applies to =
modern
> >>>>>>file systems, I do not know - they only file system I have stud=
ied in
> >>>>>>low-level detail is FAT16.
> >>>>>When the block device reports an error the filesystem can certai=
nly
> >>>>>record
> >>>>>that information in a bad-block list, and possibly does.
> >>>>>
> >>>>>However I thought you were suggesting a situation where the bloc=
k=20
> >>>>>device
> >>>>>could succeed with the request, but knew that area of the device=
 was of
> >>>>>low
> >>>>>quality.
> >>>>I guess that is what I was trying to suggest, though not very cle=
arly.
> >>>>
> >>>>>e.g. IO to a block on a stripe which had one 'bad block'.  The I=
O=20
> >>>>>should
> >>>>>succeed, but the data isn't as safe as elsewhere.  It would be n=
ice if=20
> >>>>>we
> >>>>>could tell the filesystem that fact, and if it could make use of=
 it.=20
> >>>>>But
> >>>>>we
> >>>>>currently cannot.   We can say "success" or "failure", but we ca=
nnot=20
> >>>>>say
> >>>>>"success, but you might not be so lucky next time".
> >>>>>
> >>>>Do filesystems re-try reads when there is a failure?  Could you r=
eturn
> >>>>fail on one read, then success on a re-read, which could be inter=
preted
> >>>>as "dying, but not yet dead" by the file system?
> >>>This should not be a file system feature. The file system is built=
 upon
> >>>the raid, and in mirrorred raid types like raid1 and raid10, and a=
lso
> >>>other raid types, you cannot be sure which specific drive and sect=
or the
> >>>data was read from - it could be one out of many (typically two) p=
laces.
> >>>So the bad blocks of a raid is a feature of the raid and its indiv=
idual
> >>>drives, not the file system. If it was a property of the file syst=
em,
> >>>then the fs should be aware of the underlying raid topology, and k=
now if
> >>>this was a parity block or data block of raid5 or raid6, or which
> >>>mirror instance of a raid1/10 type which  was involved.
> >>>
> >>Thanks for the explanation.
> >>
> >>I guess my worry is that if md layer has tracked a bad block on a d=
isk,
> >>then that stripe will be in a degraded mode.  It's great that it wi=
ll
> >>still work, and it's great that the bad block list means that it is
> >>/only/ that stripe that is degraded - not the whole raid.
> >I am proposing that the stripe not be degraded, using a recovery are=
a for=20
> >bad
> >blocks on the disk, that goes together with the metadata area.
> >
> >>But I'm hoping there can be some sort of relocation somewhere
> >>(ultimately it doesn't matter if it is handled by the file system, =
or by
> >>md for the whole stripe, or by md for just that disk block, or by t=
he
> >>disk itself), so that you can get raid protection again for that st=
ripe.
> >I think we agree in hoping:-)
>=20
> IMHO the point is that this feature (Bad Block Log) is a GREAT featur=
e=20
> as it just helps in keeping track of the health status of the underly=
ing=20
> disks, and helps A LOT in recovering data from the array when a=20
> unrecoverable read error occurs (now the full array goes offline). Th=
en=20
> something must be done proactively to repair the situation, as it mea=
ns=20
> that a disk of the array has problems and should be replaced. So, fir=
st=20
> it's worth to make a backup of the still alive array (getting some re=
ad=20
> error when the bad blocks/stripes are encountered [maybe using ddresc=
ue=20
> or similar]), then replace the disk, and reconstruct the array; after=
=20
> that a fsck on the filesystem may repair the situation.
>=20
> You may argue that the unrecoverable read error come from just very f=
ew=20
> sector of the disk, and it's not worth to replace it (personally I wo=
uld=20
> replace also on very few ones), as there are still many reserverd=20
> sectors for relocation on the disk. Then a simple solution would just=
 be=20
> to zero-write the bad blocks in the Bad Block Log (the data is gone=20
> already): if the write succedes (disk uses reserved sectors for=20
> relocation), the blocks are removed from the log (now they are ok); t=
hen=20
> fsck (hopefully) may repair the filesystem. At this point there are n=
o=20
> more md read erros, maybe just filesystem errors (the array is clean,=
=20
> the filesystem may be not, but notice that nothing can be done to avo=
id=20
> filesystem problems, as there has been a data loss; only fsck may hel=
p).

another way around, if the badblocks recovery area does not fly with
Neil or other implementors.

It should be possible to run a periodic check of if any bad sectors hav=
e
occurred in an array. Then the half-damaged file should be moved away f=
rom
this area with the bad block by copying it and relinking it, and before
relinking it to the proper place the good block corresponding to the ba=
d=20
block should be marked as a corresponding good block on the healthy dis=
k
drive, so that it not be allocated again. This action could even be
triggered by the event of the detection of the bad block. This would
probably meean that ther need to be a system call to mark a
corresponding good block. The whole thing should be able to run in
userland and somewhat independent of the file system type, except for
the lookup of the corresponding file fram a damaged block.

best regards
Keld

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
