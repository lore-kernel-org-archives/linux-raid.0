From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: striping and mirroring with only two disks
Date: Sun, 1 Feb 2004 00:55:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040131235556.GB19891@rap.rap.dk>
References: <20040131195302.GA18341@rap.rap.dk> <6.0.1.1.2.20040131152717.03fe1f28@a.cs.okstate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6.0.1.1.2.20040131152717.03fe1f28@a.cs.okstate.edu>
To: Nathan Lewis <nathapl@cs.okstate.edu>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 31, 2004 at 03:36:21PM -0600, Nathan Lewis wrote:
> Even if it were possible, your write performance would be TERRIBLE (i=
maging=20
> writing the chunks in order - 0, 1, 2, 3....  Your disk heads would b=
e=20
> thrashing constantly).

Well, I am not sure that will be so. Most modern disks today have
buffers of 2 MB - 8 MB on the unit, and writes would thus be buffered
there, meaning that the drive would be striping.


> The RAID1 code already does read-balancing.  Not=20
> the same thing as striping, but certainly increases performance on re=
ads,=20
> especially when more than one read is being done at a time.

Yes, striping is best when there is only one read or write in operation=
=2E
I think tho, that lonely sequential reads or writes are very common, ev=
en on servers.
>=20
> If you wanted to try it, I think you might be able to accomplish it w=
ith=20
> partitions.  Partition your two disks in half, so you have:
> disk1 a & b
> disk2 a & b
>=20
> Then mirror disk1a with disk2b (say as /dev/md0), and likewise mirror=
=20
> disk1b with disk2a (say as /dev/md1).  Then create a RAID0 array (/de=
v/md2)=20
> from those two mirrors (md0 and md1).
>=20
> You could also do it the other way:
> create two raid0 arrays (disk1a+disk2a=3D/dev/md0) (disk1b+disk2b=3D/=
dev/md1)=20
> then mirror them as /dev/md2.

I think that is a nice way to get what I was thinking of.
Nice in the way that it is already possible with existing code.
But will the mirroring work? Or, if one of the disks fails, can I be
sure that the other will have all the data, and that I can recreate
the combined md from the two parts?

Why has nobody thought of it before? All descriptions I have seen of
RAID0+1 says that it needs 4 disks.

Best regards
keld
>=20
>=20
> At 01:53 PM 1/31/2004, Keld J=F8rn Simonsen wrote:
> >Hi!
> >
> >Is it possible to both do striping and mirroring if you only have 2 =
disks?
> >
> >I was thinking of having the chunks organized on each disk so
> >that striping reads and writes could be done. Eg. by having
> >
> >disk1: chunk0 chunk2 chunk4 ......   chunk1 chunk3 chunk5
> >disk2: chunk1 chunk3 chunk5 ......   chunk0 chunk2 chunk4
> >
> >Would such a layout of chunks allow for striped reading and writing?
> >
> >Best regards
> >keld
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
