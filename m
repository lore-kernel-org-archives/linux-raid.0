From: "Majed B." <majedb@gmail.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 09:40:01 +0300
Message-ID: <70ed7c3e0910132340q1c4acdfbxa6938261088acca3@mail.gmail.com>
References: <hb1udb$6t1$1@ger.gmane.org> <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com>
	<hb2470$rol$1@ger.gmane.org> <70ed7c3e0910130810r58ab391id2fbfdff6200dcd8@mail.gmail.com>
	<hb3qpa$6ep$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hb3qpa$6ep$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I see.

Well, whether MD is smart enough to rearrange a queue when the arrays
are sharing disks or not, it still means that you can't run your
processes in parallel.

I did see MD put the arrays in queue during resyncs when I had a
similar setup. I didn't benchmark the arrays at that time, so I don't
have solid numbers of how much of a performance penalty that setup
caused.

On Wed, Oct 14, 2009 at 9:23 AM, Antonio Perez <ap23563m@gmx.com> wrote=
:
> Majed B. wrote:
>
>> I think I already answered your question:
>>
>>> For desktop usage it's OK to use that setup since you won't be writ=
ing
>>> to / and the other segments a lot at the same time.
>>
>>> If you're running an application which writes a lot of data to / an=
d
>>> you require to read/write a lot of data of the rest of the disk, it
>>> will conflict and slow things down a lot.
>>>
>>> Basically, you're partitioning each disk and making each partition
>>> belong to an array.
>>
>> If you misunderstood part, or I did, let me know :)
>
> Thanks Majeb. I believe I understand you.
>
> This is what I get from your comment:
>
> If the disks are setup with several partitions, and the corresponding
> partitions belong to a md array as this:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]1 --> md1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]2 --> md2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]3 --> md3
>
> If md1 is used as / and md2 is used as /home (or /data) there will be=
 no
> concurrent reads to both places.
>
> While this may be true, depending on the specific application, it is =
not
> what I am asking.
> _____________________________________________________________________=
___
>
> The point is:
>
> If md1 is used as /data1 and md2 is used as /data2 will it work?
>
> Will the md system be aware that those are on the same disk (spindle)=
 and
> use the correct queuing on the reads for the best reading speed possi=
ble?
>
> Or will md get confused on the correct read sequence causing addition=
al head
> seeks which will degrade overall performance.
>
> Sorry if I confuse you more, this is not an "simple" question.
>
> Please read Robin Hill answer. :-)
>
> --
> Antonio Perez
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
