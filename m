From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Tue, 26 Jul 2016 21:19:26 +0100
Message-ID: <5797C5CE.6020300@youngman.org.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
 <22423.44287.974770.114127@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22423.44287.974770.114127@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/07/16 19:33, Peter Grandi wrote:
> [ ... ]
>> migrate all my data from a raid 5 of 4x2TB (actually 3 because
>> i'm degraded right now) to a raid 6 of 4x4TB so exactly i got :
>> - raid 5, should be 4 disk of 2T but got problem and so right
>>   now it's just 2x2T and a 2Tb disk image in a 4T disk (the
>>   raid crashed and is not start right now but is clean)
>> - 2 disk of 4TB
>> - the raid 5 use lvm2 on top of mdadm
>> I want a raid 6 [ ... ]
>=20
> In general an in-place migration is a very dangerous operation
> because it stresses existing hardware a lot plus it uses code
> that is rarely used and is quite complex. Given that your
> situation is already compromised.

But copying everything off will stress it just as much, surely? The
alternatives imho are worse ...
>=20
> Plus your goal does not make a lot of sense: from a RAID5 of 4
> drives to a RAID6 of 4 drives. Very strange.
>=20
=46rom a 6TB raid5 to an 8TB raid6? What's strange about that?

> Also I note that you currently don't have 4 drives of 4TB, but
> 3, so there you get your wish 2 drives of 2TB as the fourth
> member as in =AB2 2TB as a raid 0=BB
>=20
> The good thing about your plan is to use the larger drives to
> make a *copy* of your data, so you don't quite do an in-place
> migration.
>=20
So beg or borrow a 2TB (or larger) drive, provided you have enough slot=
s
for 6 drives. Borrow or buy (they're cheap enough) an add-in SATA card
if you need to.

Now he can add the second 4TB drive to complete his raid5.

Add in the third 4TB to replace the 2TB partition and free up the partl=
y
used 4TB drive.

Use the now-free first 4TB drive to replace one of the 2TB drives. Sham=
e
he can't reshape the resulting array into a 3 x 4TB raid5 (at least, I
don't think he can).

Use the borrowed drive to replace the last 2TB drive.

Combine the 2 2TB drives into a 4TB raid0 array, and use that to replac=
e
the borrowed drive.

We now have a 4 x 4TB raid5 array which he can convert to raid6.

If the worst comes to the worst and he can't get that spare drive, he
could always fail the last 2TB drive (taking it back to degraded raid5
:-( then combine the 2 x 2TB and add them back to get a fully working
array again.

Unfortunately, I can't think of any way to get to the planned final
config without either borrowing an extra drive, or having (at some
point) a degraded array.

Cheers,
Wol

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
