From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 03:56:23 +0100
Message-ID: <20110218025623.GA26387@www2.open-std.org>
References: <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org> <ijiu99$ill$1@dough.gmane.org> <20110217105815.GA24580@www2.open-std.org> <4D5D0A66.80608@texsoft.it> <20110217154440.GA24982@www2.open-std.org> <4D5DB9AC.10106@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5DB9AC.10106@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 18, 2011 at 01:13:32AM +0100, Giovanni Tessore wrote:
> On 02/17/2011 04:44 PM, Keld J=F8rn Simonsen wrote:
> >It should be possible to run a periodic check of if any bad sectors =
have
> >occurred in an array. Then the half-damaged file should be moved awa=
y from
> >this area with the bad block by copying it and relinking it, and bef=
ore
> >relinking it to the proper place the good block corresponding to the=
 bad
> >block should be marked as a corresponding good block on the healthy =
disk
> >drive, so that it not be allocated again. This action could even be
> >triggered by the event of the detection of the bad block. This would
> >probably meean that ther need to be a system call to mark a
> >corresponding good block. The whole thing should be able to run in
> >userland and somewhat independent of the file system type, except fo=
r
> >the lookup of the corresponding file fram a damaged block.
>=20
> I don't follow this.. if a file has some damaged blocks, they are gon=
e,=20
> moving it elsewhere does not help.

Remember the file is in a RAID. So you can lose one disk drive and your
data is still intact.

> And however, this is a task of the filesystem.

No, it is the task of the raid, as it is the raid that gives the
functionality that you can lose a drive and still have your data intact=
=2E
the raid level knows what is lost, and  what is still good, and where
this stuff is.

If we are then operating on the file level, then doing something clever=
 could
be a cooperation between the raid leven ald the filesystem level, as
described above.


> md is just a block device (more reliable than a single disk due to so=
me=20
> level of redundancy), and it should be indipendent from the kind of f=
ile=20
> system on it (as the file system should be indipendent from the kind =
of=20
> block device it resides on [md, hd, flash, iscsi, ...]).

true

> Then what you suggest should be done for every block device that can=20
> have bad blocks (that is, every block device). Again, this is a=20
> filesystem issue. And of which file system type, as there are many?

yes, it is a cooperation between the file system layer, and the raid
layer, I propose this be done in userland.

> The Bad Block Log allows md to behave 'like' a read hard disk would d=
o=20
> with smart data:
> - unreadable blocks/stripes are recorded into the log, as unreadable=20
> sectors are recorder into smart data
> - unrecoverable read errors are reported to the caller for both
> - the device still works if it has unrecoverable read errors for both=
=20
> (now the whole md device fails, this is the problem)
> - if a block/stripe if rewritten with success  the block/stripe is=20
> removed from Bad Block Log (and the counter of relocated blocks/strip=
es=20
> is incremented); as if a sector is rewritten with succes on a disk th=
e=20
> sector is removed from list of unreadable sector, and the counter of=20
> relocated sector is incremented (smart data)

Smart drives also reallocate bad blocks, hiding the errors from the SW
level.

> A filesystem on a disk does not know what the firmware of the disk do=
es=20
> about sectors relocation.
> The same applies for a hardware (not fake) raid controller firmware.
> The same should apply for md. It is transparent to the filesystem.

Yes, normally the raid layer and the fs layer are independent.

But you can add better recovery with what I suggest.

> IMHO a more interesting issue whould be: a write error occurs on a di=
sk=20
> participating to an already degraded array; failing the disk would fa=
il=20
> the whole array. What to do? Put the array into read only mode, still=
=20
> allowing read access to data on it for easy backup? In such situation=
,=20
> what would do a hardware raid controller?
>=20
> Hm, yes.... how do behave hardware raid controllers with uncorrectabl=
e=20
> read errors?
> And how they behave with write error on a disk of an already degraded=
 array?
> I guess md should replicate these behaviours.

I think we should be more intelligent than ordinary HW RAID:-)

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
