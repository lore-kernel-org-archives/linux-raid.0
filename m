From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Wed, 16 Sep 2009 13:07:43 +0300
Message-ID: <70ed7c3e0909160307v538cffebgf913ae213f42ed3d@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <h8nrkn$n8p$5@ger.gmane.org>
	<70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	<70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
	<1253037953.7774.131.camel@kiste> <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
	<1253040282.7774.149.camel@kiste> <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
	<1253094266.6394.5.camel@localhost> <20090916100022.GA15413@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090916100022.GA15413@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the heads up, Robin.

I've just checked and it seems that they do start from the same sector:

/dev/sdg: WDC WD10EADS-65L5B1
/dev/sdh: MAXTOR STM31000340AS
root@Adam:/boot# fdisk -l /dev/sd[g-h]

Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1      121601   976760001   fd  Linux raid auto=
detect

Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1               1      121601   976760001   fd  Linux raid auto=
detect


There are other disks in the array, but the rest are all WD disks and
have a similar structure to the one above.

On Wed, Sep 16, 2009 at 1:00 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Wed Sep 16, 2009 at 11:44:26AM +0200, Matthias Urlichs wrote:
>
>> On Wed, 2009-09-16 at 12:31 +0300, Majed B. wrote:
>> > I have a question which would probably sound stupid: If I have a b=
ad
>> > blocks output file from dd_rescue, can I reconstruct a bad sector'=
s
>> > data by reading the same sector from all disks (using dd if=3D/dev=
/sdx
>> > of=3D./bbfix_#number bs=3D512 count=3D1 skip=3Dbb_number-1), then =
run an
>> > normal XOR operation, write zeros to the bad block to force sector
>> > remap, then dd the XOR output to the said sector?
>>
>> Well, of course. Assuming that the disk's sector remap works, which =
was
>> my problem, and that we're talking about RAID5.
>>
> And also assuming that the array starts from the same sector of each
> disk.
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
