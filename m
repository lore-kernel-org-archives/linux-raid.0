From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 write performance
Date: Sat, 19 Nov 2005 00:56:33 -0500
Message-ID: <200511190556.jAJ5uaw16109@www.watkins-home.com>
References: <437EB0A6.8040807@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437EB0A6.8040807@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>
Cc: 'Dan Stromberg' <strombrg@dcs.nac.uci.edu>, =?ISO-8859-2?Q?'Jure_Pe=E8ar'?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Mike Hardy [mailto:mhardy@h3c.com]
> Sent: Friday, November 18, 2005 11:57 PM
> To: Guy
> Cc: 'Dan Stromberg'; 'Jure Pe=E8ar'; linux-raid@vger.kernel.org
> Subject: Re: raid5 write performance
>=20
>=20
>=20
> Guy wrote:
>=20
> > It is not just a parity issue.  If you have a 4 disk RAID 5, you ca=
n't
> be
> > sure which if any have written the stripe.  Maybe the parity was
> updated,
> > but nothing else.  Maybe the parity and 2 data disks, leaving 1 dat=
a
> disk
> > with old data.
> >
> > Beyond that, md does write caching.  I don't think the file system =
can
> tell
> > when a write is truly complete.  I don't recall ever having a Linux
> system
> > crash, so I am not worried.  But power failures cause the same risk=
, or
> > maybe more.  I have seen power failures, even with a UPS!
>=20
> Good points there Guy - I do like your example. I'll go further with
> crashing too and say that I actually crash outright occasionally.
> Usually when building out new machines where I don't know the proper
> driver tweaks, or failing hardware, but it happens without power loss=
=2E
> Its important to get this correct and well understood.
>=20
> That said, unless I hear otherwise from someone that works in the cod=
e,
> I think md won't report the write as complete to upper layers until i=
t
> actually is. I don't believe it does write-caching, and regardless, i=
f
> it does it must not do it until some durable representation of the da=
ta
> is committed to hardware and the parity stays dirty until redundancy =
is
> committed.
>=20
> Building on that, barring hardware write-caching, I think with a
> journalling FS like ext3 and md only reporting the write complete whe=
n
> it really is, things won't be trusted at the FS level unless they're
> durably written to hardware.
>=20
> I think that's sufficient to prove consistency across crashes.
>=20
> For example, even if you crash during an update to a file smaller tha=
n a
> stripe, the stripe will be dirty so the bad parity will be discarded =
and
> the filesystem won't trust the blocks that didn't get reported back a=
s
> written by md. So that file update is lost, but the FS is consistent =
and
> all the data it can reach is consistent with what it thinks is there.
>=20
> So, I continue to believe silent corruption is mythical. I'm still op=
en
> to good explanation it's not though.
>=20
> -Mike

I will take a stab at an explanation.

Assume a single stripe has data for 2 different files (A and B).  A dis=
k has
failed.  The file system writes a 4K chunk of data to file A.  The pari=
ty
gets updated, but not the data.  Or the data gets updated but not the
parity.  The system crashes or power fails.  The system recovers, but c=
an't
do anything about the parity with a failed disk.  But the filesystem do=
es
its thing.  The disk is replaced and added, the data block is reconstru=
cted
using a good block and a bad block.  The parity now matches the data.  =
But
the reconstructed block (file B) is wrong and the file using that block=
 has
not been changed for years.  So, silent corruption.  But you could argu=
e it
was a double failure.

Also, after a power failure, I have seen the system come back with a si=
ngle
disk failed.  I guess that 1 disk had an expired superblock.  When you =
add
that disk back, any stripes that were not up to date will be re-constru=
cted
with invalid data.  I don't know if the intent logging will help here o=
r
not.  Most likely, more than 1 disk will have an expired superblock.  I=
f you
force md to assemble the array it resyncs, but I don't know if it does =
the
parity or picks a disk to pretend was just added.  It show a single dis=
k as
rebuilding, if that is correct, silent corruption could occur.

Guy

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
