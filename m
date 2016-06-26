From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Sun, 26 Jun 2016 22:12:15 +0100
Message-ID: <5770452F.8000109@youngman.org.uk>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
 <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
 <22381.43040.31844.544728@quad.stoffel.home>
 <576E6E68.9070209@youngman.org.uk> <576EB5FD.1000309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <576EB5FD.1000309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Peter Gebhard <pgeb@seas.upenn.edu>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Another Sillyname <anothersname@googlemail.com>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 25/06/16 17:49, Phil Turmel wrote:
> Hi Wol, Peter,
>=20
> { Convention on kernel.org is to reply-to-all, bottom or interleave
> replies, and trim unnecessary context.  CC list fixed up accordingly.=
 }

Sorry, but the OP had already been trimmed, I trimmed a bit further...
>=20
> On 06/25/2016 07:43 AM, Wols Lists wrote:
>=20
>> I know you're getting conflicting advice, but I'd try to get a good =
dd
>> backup first. I don't know of any utility that will do an md integri=
ty
>> check on a ddrescue'd disk :-( so you'd need to do a fsck and hope .=
=2E.
>=20
> Conflicting advice indeed.  More conflict ahead:
>=20
> dd is totally useless for raid recovery in all cases.  ddrescue may b=
e
> of use in this case:

And if dd gets a copy without errors, what's the difference between tha=
t
and a ddrescue? Surely they're identical?

That said, it struck me you're probably better off using ddrescue,
because ddrescue could get that copy in one. So if you can get it in
one, it doesn't matter which you use, so you should use ddrescue becaus=
e
it saves a wasted attempt with dd. (I've just read the ddrescue man
page. Recommended reading ... :-)


>=20
> Which means that the the balance of the drives have no redundancy
> available to reconstruct data for any UREs remaining in the array.  I=
f
> there were, forced assembly of originals after any timeout mismatch
> fixes would be the correct solution.  That would let remaining
> redundancy fix UREs while adding more redundancy (the #1 reason for
> choosing raid6 over raid5).
>=20
> Peter, I strongly recommend that you perform a forced assembly on the
> three drives, omitting the unit kicked out last year.  (After fixing =
any
> timeout issue, if any.  Very likely, btw.)  Mount the filesystem
> read-only and backup the absolutely critical items.  Do not use fsck
> yet.  You may encounter UREs that causes some of these copies to fail=
,
> letting you know which files to not trust later.  If you encounter
> enough failures to drop the array again, simply repeat the forced
> assembly and readonly mount and carry on.
>=20
> When you've gotten all you can that way, shut down the array and use
> ddrescue to duplicate all three drives.  Take the originals out of th=
e
> box, and force assemble the new drives.  Run fsck to fix any remainin=
g
> errors from zeroed blocks, then mount and backup anything else you ne=
ed.
>=20
> If you need to keep costs down, it would be fairly low risk to just
> ddrescue the most recent failure onto the oldest (which will write ov=
er
> any UREs it currently has).  Then forced assemble with it instead.
>=20
> And add a drive to the array to get back to a redundant operation.
> Consider adding another drive after that and reshaping to raid6.  If
> your drives really are ok (timeout issue, not physical), then you cou=
ld
> re-use one or more of the originals to get back to full operation.  U=
se
> --zero-superblock on them to allow MD to use them again.
>=20
Hmm...

Would it be an idea to get 4 by 3TB drives? That way he can do the
backup straight on to a RAID6 array, and IF he gets a successful backup
then the old drives are now redundant, for backups or whatever (3TB Red=
s
or NASs are about =C2=A3100 each...)

Cheers,
Wol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
