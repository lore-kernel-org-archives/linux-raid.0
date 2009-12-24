From: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Thu, 24 Dec 2009 11:16:25 +0200
Message-ID: <8e04b5820912240116k6c93333byfcd0dc6b82fedec0@mail.gmail.com>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
	 <20091222165225.GA2684@rap.rap.dk>
	 <8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
	 <20091222182248.GA5719@rap.rap.dk>
	 <87d424rbex.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d424rbex.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Keld Jorn Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 24, 2009 at 11:03 AM, Goswin von Brederlow
<goswin-v-b@web.de> wrote:
> Keld J=C3=B8rn Simonsen <keld@keldix.com> writes:
>
>> On Tue, Dec 22, 2009 at 07:08:25PM +0200, Ciprian Dorin, Craciun wro=
te:
>>> 2009/12/22 Keld J=C3=B8rn Simonsen <keld@keldix.com>:
>>> > On Tue, Dec 22, 2009 at 06:34:55PM +0200, Ciprian Dorin, Craciun =
wrote:
>>> >> =C2=A0 =C2=A0 Hello all!
>>> >>
>>> >> =C2=A0 =C2=A0 I've created a 64G RAID 1 matrix from 3 real disks=
=2E (I intend to
>>> >> use this as a target for backups.)
>>> >> =C2=A0 =C2=A0 Now while playing around with this array, I've obs=
erved that the
>>> >> read performance is quite low because it always reads from the d=
isk in
>>> >> the first slot (which happens to be the slowest...)
>>> >>
>>> >> =C2=A0 =C2=A0 So my questions are:
>>> >> =C2=A0 =C2=A0 * is there any way to tell the MD driver to load-b=
alance the reads
>>> >> between the three disks?
>>> >
>>> > It does not make sense to do distributed reading in raid1 for seq=
uential
>>> > files. This is because it will not be faster to read from more dr=
ives,
>>> > as this will only make the reading from one drive skipping blocks=
 on
>>> > that drive. In other words, in the time you use for skipping bloc=
ks on
>>> > one drive, you could just as well have read the blocks. So then b=
etter
>>> > just read all the blocks off one drive, and then do other possibl=
e IO
>>> > from other drives.
>>>
>>> =C2=A0 =C2=A0 Aha. It makes sens now. But, does it mean that if I h=
ave parallel
>>> IO's (from different read operations) they are going to be distribu=
ted
>>> between the disks?
>>
>> It should, but I am not fully sure it does.
>> But try it out with two concurrent reads of two big files, and then
>> watch it with iostat
>>
>> Best regards
>> keld
>
> Actualy the kernel remembers the last read/write position for each
> raid1 component and then uses the one which is nearest.
>
> And when you read at 2/3 different positions at the same time then it
> will use different components for each an use the same ones for
> subsequent reads (as they will be nearer).
>
> Try
>
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D0 &
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D1024 &
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M cunt=3D1024 skip=3D2048
>
> They should more or less get the same speed as a single dd.
>
> MfG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Goswin


    Thanks all for your feedback. (I haven't tried the proposed three
dd's in parallel, but I promise I'll try them the next time I assemble
my backup array.)

    But one observation though:
    * indeed my usage of the array was mono-process;
    * when reading from the array to construct the MD5 sums for the
files I've used only one process;
    * indeed the data was read from a single disk (at a time);
    * but now the interesting think comes: I think it favored one disk
(the same most of the time) over the others;

    Is this as expected?

    Thanks again,
    Ciprian.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
