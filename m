From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Bad blocks are killing us!
Date: Mon, 22 Nov 2004 04:17:39 -0500
Message-ID: <200411220917.iAM9HiN30335@www.watkins-home.com>
References: <41A1A1AE.7060909@conterra.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A1A1AE.7060909@conterra.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Dieter Stueken' <stueken@conterra.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Summary for anyone that missed this thread.
If a RAID5 array is scanned to verify that the parity data matches the =
data,
how should the system handle a mismatch?  Assume no disks had read erro=
rs.
If the parity does not agree, then 1 or more disks are wrong.  The pari=
ty
disk could be wrong, in which case no data is lost or corrupt, yet.  Bu=
t a
disk failure at this time would corrupt data unless it was the parity d=
isk
for this stripe.  If any other disk is wrong, then data is corrupt.  If=
 you
are lucky, the corrupt data will be un-used space.  In this case no dat=
a is
really corrupt, yet.

I agree with your assessment, or you agree with mine!  :)
I disagree on how it should be handled.

Now, what to do if a parity error occurs?  As I see it, we have these
possible options:

A. Ignore it.  This is what is done today.  But log the blocks affected=
=2E
Risk of data corruption is high.  And know that the risk of additional =
data
corruption is increased when a disk fails.  Re-building to the spare ha=
s the
effect of correcting the parity so the error is now masked.

B. Just correct the parity, you stand a high risk of data corruption wi=
thout
knowing about it.  But without correcting the parity you still have the=
 same
risk.  Log the blocks affected.  By correcting the parity, no additiona=
l
corruption will occur when a disk fails.

C. Mark all blocks (or chunks) affected by the parity error as unreadab=
le.
This would cause data loss, but no corruption.  The data loss would be =
the
size of the mismatch (in blocks or chunks) times the number of disks in=
 the
array - 1.  This acts more like a disk drive when a sector can't be rea=
d.
Log the blocks affected.  In the case of a 14 disk RAID5 array, a singl=
e
sector parity error would cause 13 sectors to be lost, or much more if =
going
by chunks.  Optionally, still allow option B at some later time at the
user's request.  This would allow the user to determine what data is
affected, then attempt to recover some of the data.

D. Report the error, and allow manual parity correction.  This is like
option A then at user request option B.

E. All of the above.  Have the option to choose which of the above you =
want.
This will allow each user to choose how the system will handle parity
errors.  This option should be configured per array, not system wide.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Dieter Stueken
Sent: Monday, November 22, 2004 3:22 AM
To: linux-raid@vger.kernel.org
Subject: Re: Bad blocks are killing us!

Guy Watkins wrote:
> ... but the md-level
> approach might be better.  But I'm not sure I see the point of
> it---unless you have raid 6 with multiple parity blocks, if a disk
> actually has the wrong information recorded on it I don't think you
> can detect which drive is bad, just that one of them is."
>=20
> If there is a parity block that does not match the data, true you do =
not
> know which device has the wrong data.  However, if you do not "correc=
t"
the
> parity, when a device fails, it will be constructed differently than =
it
was
> before it failed.  This will just cause more corrupt data.  The parit=
y
must
> be made consistent with whatever data is on the data blocks to preven=
t
this
> corrosion of data.  With RAID6 it should be possible to determine whi=
ch
> block is wrong.  It would be a pain in the @$$, but I think it would =
be
> doable.  I will explain my theory if someone asks.


This is exactly the same conflict, a single drive has with a unreadable
sector.
It notices the sector as bad, and it can not fulfill any read request, =
until
the data is not rewritten or erased. The single drive can not (and shou=
ld
never
try to!) silently replace the bad sector by some spare sectors, as it c=
an
not
recover the content.

Also the RAID system can not solve this problem automagically, and neve=
r
should
do so, as the former content can not be deduced any more. But notice, t=
hat
we
have two very different problems to examine: The above problem arises, =
if
all
disks of the RAID system claim to read correct data, whereas the parity
information
tells us, that one of them must be wrong. As long as we don't have RAID=
6,
to recover single bit errors, the data is LOST and can not be recovered=
=2E

This is very different to the situation, when one of the disks DOES rep=
orts
an internal crc-error. In this case your data CAN be recovered reliable=
 from
the
parity information, and in most cases successfully written back to the =
disk.

But there is also a difference between the problem for RAID compared to=
 the
internal
disk: Whereas the disk always reads all CRC data for the sector to veri=
fy
its integrity,
the RAID system does not normally check the validity of the parity
information
by default. (this is, why the idea of data scans actually came up). So,=
 if a
scan
discovers a bad parity information, the only action that can (and must!=
) be
taken
is, to tag this piece of data to be invalid. And it is very important, =
not
only
to log that information somewhere. It is even more important to prevent
further readings
of this piece of lost data. Otherwise those definitely invalid data may=
 be
read
without any notice again, may even get written back again and thus turn=
s
into valid
data, even though it become garbage.


People oftenargue for some spare sector management, which would solve a=
ll
problems.
I think this is an illusion. Spare sectors can only be useful if you fa=
il
WRITING data,
not when reading data failed or data loss occurred. This is realized al=
ready
within
the single disks in a sufficient way (I think). If your disk gives writ=
e
errors, you
either have a very old one, without internal spare sector management, o=
r
your disk
run out of spare sectors already. Read errors are quite more frequent t=
han
write
errors and thus a much more important issue.

Dieter St=FCken.
--=20
Dieter St=FCken, con terra GmbH, M=FCnster
     stueken@conterra.de
     http://www.conterra.de/
     (0)251-7474-501
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
