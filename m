From: Neil Brown <neilb@suse.de>
Subject: Re: --assume-clean on raid5/6
Date: Sun, 8 Aug 2010 18:56:02 +1000
Message-ID: <20100808185602.0e96efa2@notabene>
References: <D27CA15508148C428A25104ADEFAAC810661CD00@CORPUSMX50C.corp.emc.com>
	<4C5D5187.7080109@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5D5187.7080109@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: stefan.huebner@stud.tu-ilmenau.de, brian.foster@emc.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 07 Aug 2010 14:28:55 +0200
Stefan /*St0fF*/ H=C3=BCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:

> Hi Brian,
>=20
> --assume-clean skips over the initial resync.  Which - if you will
> create a filesystem after creating the array - is a time-saving idea.
> But keep in mind: even if the disks are brand new and contain only
> zeros, the parity would probably look not all zeros.  So reading from
> such an array would be a bad idea.
> But if the next thing you do is create LVM/filesystem etc., then all =
bit
> read from the array will have been written to before (and by that are=
 in
> sync).

There is an important point that this misses.

When md updates a block on a RAID5 it will sometimes use a read-modify-=
write
cycle which reads the old block and old parity, subtracts the old block=
 from
the parity block and then added the new block to the parity block.  The=
n it
writes the new data block and the new parity block.

If the old parity was correct for the old stripe, then the new parity w=
ill be
correct for the new stripe.  But if the old was wrong then the new will=
 be
wrong.

So if you use assume-clean then the parity may well be wrong and could =
remain
wrong even when you write new data.  If you then lose a device, the dat=
a for
that device will be computed using wrong parity and you will get wrong =
data -
hence data corruption.

So you should only use --assume-clean if you know the array really is
'clean'.

RAID1/RAID10 cannot suffer from this so --assume-clean is quite safe wi=
th
those array types.
The current implementation of RAID6 never does read-modify-write so
--assume-clean is currently safe with RAID6 too.  However I do not prom=
ise
that RAID6 might not change to use read-modify-write cycles in some fut=
ure
implementation.  So I would not recommend using --assume-clean on RAID6=
 just
to avoid the resync cost.

NeilBrown

>=20
> Stefan
>=20
> Am 06.08.2010 03:19, schrieb brian.foster@emc.com:
> > Hi all,
> >=20
> > I've read in the list archives that use of --assume-clean on raid5
> > (raid6?) is not safe assuming the member drives are not sync, but i=
t's
> > not clear to me as to why. I can see the content of an written raid=
5
> > array change if I fail a drive out of the array (created w/
> > --assume-clean), but data that I write prior to failing a drive rem=
ains
> > intact. Perhaps I'm missing something. Could somebody elaborate on =
the
> > danger/risk of using --assume-clean? Thanks in advance.
> >=20
> > Brian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
