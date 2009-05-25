From: Raz <raziebe@gmail.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Mon, 25 May 2009 23:06:04 +0300
Message-ID: <5d96567b0905251306v4b1b2ef5p9268063ad81eacd8@mail.gmail.com>
References: <1241300764.5607.36.camel@raz> <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	<18965.16276.485692.812516@notabene.brown> <87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
	<87r5ydqsrd.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r5ydqsrd.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is not clear to me why Linux has both LVM and md,waste of
development effort to my opinion. Adding to that brtfs/zfs reaching
mainline, Linux will have 3-4 volume managers to maintain.
why not join hands  and come up with a single unify system?
On Mon, May 25, 2009 at 3:19 PM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Greg Freemyer <greg.freemyer@gmail.com> writes:
>
>> =3D=3D> What I mean by raid equivalent levels
>>
>> More and more arrays allow the user to simply say "give me a 100 GB
>> logical volume with Raid 5 equivalent protection. =A0The array then
>> looks at the drives it has available and puts together the necessary
>> pieces. =A0As drives are added, removed it moves the data around und=
er
>> its own control, but maintains the raid equivalent protection.
>>
>> Especially when working with dozens of drives and lots of logical
>> volumes it makes life much easier. =A0Admittedly it may come at a co=
st
>> of not being able to specify raid levels with the specificity that
>> mdraid currently allows.
>>
>> =3D=3D>
>>
>> The reason I ask if this is the goal is that doing so may factor int=
o
>> decisions about how reshaping is implemented.
>>
>> Greg
>
> That really seems to scream for LVM to support more raid levels. It
> already has linear, raid0 and raid1 support (although I have no idea
> how device mapper raid1 compares to md raid1).
>
> Those should be fleshed out more and also support raid 4/5/6 for what
> you ask.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
