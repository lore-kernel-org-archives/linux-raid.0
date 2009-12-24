From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Thu, 24 Dec 2009 10:03:50 +0100
Message-ID: <87d424rbex.fsf@frosties.localdomain>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
	<20091222165225.GA2684@rap.rap.dk>
	<8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
	<20091222182248.GA5719@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222182248.GA5719@rap.rap.dk> (Keld Jorn Simonsen's message
	of "Tue, 22 Dec 2009 20:22:49 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Keld Jorn Simonsen <keld@keldix.com>
Cc: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen <keld@keldix.com> writes:

> On Tue, Dec 22, 2009 at 07:08:25PM +0200, Ciprian Dorin, Craciun wrot=
e:
>> 2009/12/22 Keld J=F8rn Simonsen <keld@keldix.com>:
>> > On Tue, Dec 22, 2009 at 06:34:55PM +0200, Ciprian Dorin, Craciun w=
rote:
>> >> =A0 =A0 Hello all!
>> >>
>> >> =A0 =A0 I've created a 64G RAID 1 matrix from 3 real disks. (I in=
tend to
>> >> use this as a target for backups.)
>> >> =A0 =A0 Now while playing around with this array, I've observed t=
hat the
>> >> read performance is quite low because it always reads from the di=
sk in
>> >> the first slot (which happens to be the slowest...)
>> >>
>> >> =A0 =A0 So my questions are:
>> >> =A0 =A0 * is there any way to tell the MD driver to load-balance =
the reads
>> >> between the three disks?
>> >
>> > It does not make sense to do distributed reading in raid1 for sequ=
ential
>> > files. This is because it will not be faster to read from more dri=
ves,
>> > as this will only make the reading from one drive skipping blocks =
on
>> > that drive. In other words, in the time you use for skipping block=
s on
>> > one drive, you could just as well have read the blocks. So then be=
tter
>> > just read all the blocks off one drive, and then do other possible=
 IO
>> > from other drives.
>>=20
>>     Aha. It makes sens now. But, does it mean that if I have paralle=
l
>> IO's (from different read operations) they are going to be distribut=
ed
>> between the disks?
>
> It should, but I am not fully sure it does.
> But try it out with two concurrent reads of two big files, and then
> watch it with iostat=20
>
> Best regards
> keld

Actualy the kernel remembers the last read/write position for each
raid1 component and then uses the one which is nearest.

And when you read at 2/3 different positions at the same time then it
will use different components for each an use the same ones for
subsequent reads (as they will be nearer).

Try

dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D0 &
dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D1024 &
dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D2048

They should more or less get the same speed as a single dd.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
