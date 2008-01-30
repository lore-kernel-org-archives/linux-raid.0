From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 16:37:25 +0300
Message-ID: <47A07D95.2030902@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <20080129162640.GA16250@rap.rap.dk> <479F5882.8050400@msgid.tls.msk.ru> <20080129180101.GB19527@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080129180101.GB19527@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
[]
>> Ugh.  2-drive raid10 is effectively just a raid1.  I.e, mirroring
>> without any striping. (Or, backwards, striping without mirroring).
>=20
> uhm, well, I did not understand: "(Or, backwards, striping without
> mirroring)."  I don't think a 2 drive vanilla raid10 will do striping=
=2E
 Please explain.

I was referring to raid0+1 here - mirror of stripes.  Which makes
no sense by its own, but when we create such thing on only 2 drives,
it becomes just raid0...  "Backwards" as raid1+0 vs raid0+1.

This is just to show that various raid levels, in corner cases,
tends to "transform" from one to another.

>> Pretty much like with raid5 of 2 disks - it's the same as raid1.
>=20
> I think in raid5 of 2 disks, half of the chunks are parity chynks whi=
ch
> are evenly distributed over the two disks, and the parity chunk is th=
e
> XOR of the data chunk. But maybe I am wrong. Also the behaviour of su=
ce
> a raid5 is different from a raid1 as the parity chunk is not used as
> data.

With N-disk raid5, parity in a row is calculated by XORing together
data from all the rest of the disks (N-1), ie, P =3D D1 ^ ... ^D(N-1).

In case of 2-disk raid5 (it's also a corner case), the above formula
becomes just P =3D D1.  So, parity block in each row contains exactly
the same data as data block, effectively turning the whole thing into
a raid1 of two disks.  Sure in raid5 parity blocks called just that -
parity, but in reality that parity is THE SAME as data (again, in
case of only 2-disk raid5).

>>> I am not sure what vanilla linux raid10 (near=3D2, far=3D1)
>>> has of properties. I think it can run with only 1 disk, but I think=
 it
>> number of copies should be <=3D number of disks, so no.
>=20
> I have a clear understanding that in a vanilla linux raid10 (near=3D2=
, far=3D1)
> you can run with one failing disk, that is with only one working disk=
=2E
> Am I wrong?

In fact, with (all softs) or raid10, it's not only the number of drives
that can fail that matters, but also WHICH drives can fail.  In classic
raid10:

    DiskA   DiskB  DiskC  DiskD
      0       0      1      1
      2       2      3      3
      4       4      5      5
      ....

(where numbers are the data blocks), you can have only 2 working
disks (ie, 2 failed), but only from different pairs.  You can't
have A and B failed and C and D working for example - you'll lose
half the data and thus the filesystem.  You can have A and C failed
however, or A and D, or B&C, or B&D.

You see - in the above example, all numbers (data blocks) should be
present at least once (after you pull a drive or two or more).  If
at least some numbers don't appear at all, your raid array's dead.

Now write out the layout you want to use like the above, and try
"removing" some drives, and see if you still have all numbers.

=46or example, with 3-disk linux raid10:

  A  B  C
  0  0  1
  1  2  2
  3  3  4
  4  5  5
  ....

We can't pull 2 drives anymore here.  Eg, pulling A&B removes
0 and 3. Pulling B&C removes 2 and 5.  A&C =3D 1 and 4.

With 5-drive linux raid10:

   A  B  C  D  E
   0  0  1  1  2
   2  3  3  4  4
   5  5  6  6  7
   7  8  8  9  9
  10 10 11 11 12
   ...

A&B can't be removed - 0, 5.  A&C CAN be removed, as
are A&D.  But not A&E - losing 2 and 7.  And so on.

6-disk raid10 with 3 copies of each (near=3D3 with linux):

   A B C D E F
   0 0 0 1 1 1
   2 2 2 3 3 3

It can run as long as from each triple (ABC and DEF), at
least one disk is here.  Ie, you can lose up to 4 drives,
as far as the condition is true.  But if you lose only
3 - A&B&C or D&E&F - it can't work anymore.

The same goes for raid5 and raid6, but they're symmetric --
any single (raid5) or double (raid6) disk failure is Ok.
The principle is this:

  raid5: P =3D D1^D2^D3^...^D(N-1)
so, you either have all Di (nothing to reconstruct), or
you have all but one Di AND P - in this case, missing Dm
can be recalculated as
  Dm =3D P^D1^...^D(m-1)^D(m+1)^...^D(N-1)
(ie, a XOR of all the remaining blocks including parity).
(exactly the same applies to raid4, because each row in
raid4 is identical to that of raid5, the difference is
that parity disk is different in each row in raid5, while
in raid4 it stays the same).

I wont write the formula for raid6 as it's somewhat more
complicated, but the effect is the same - any data block
can be reconstructed from any N-2 drives.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
