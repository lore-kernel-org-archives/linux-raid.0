From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 13:41:42 -0200
Message-ID: <AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<20110131225235.GA11775@www2.open-std.org>
	<ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<ii96gl$vrl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ii96gl$vrl$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, read/write scheduling is another task..
the best algorithm is time based (optimize to minimal time)
it=B4s not the round robin neither the closer head algorithm
if you want performace use minimal time to execute (time based)

in this topic (many emails) there=B4s a important thing. resolve the
probability problem and make it 'official', include numbers and
context

the best algorithm for read and write isn=B4t the question about
probability of how many mirros can i lose, how many disks can i lose
(maybe can be if we change context to more source based, MAYBE)

2011/2/1 David Brown <david@westcontrol.com>:
> On 01/02/2011 14:50, Jon Nelson wrote:
>>
>> On Tue, Feb 1, 2011 at 4:01 AM, David Brown<david@westcontrol.com> =A0=
wrote:
>>>
>>> On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
>>>>
>>>> raid1+0 and Linux MD raid10 are similar, but significantly differe=
nt
>>>> in a number of ways. Linux MD raid10 can run on only 2 drives.
>>>> Linux raid10,f2 has almost RAID0 striping performance in sequentia=
l
>>>> read.
>>>> You can have an odd number of drives in raid10.
>>>> And you can have as many copies as you like in raid10,
>>>>
>>>
>>> You can make raid10,f2 functionality from raid1+0 by using partitio=
ns.
>>> For
>>> example, to get a raid10,f2 equivalent on two drives, partition the=
m into
>>> equal halves. =A0Then make md0 a raid1 mirror of sda1 and sdb2, and=
 md1 a
>>> raid1 mirror of sdb1 and sda2. =A0Finally, make md2 a raid0 stripe =
set of
>>> md0
>>> and md1.
>>>
>>> If you have three disks, you can do that too:
>>>
>>> md0 =3D raid1(sda1, sdb2)
>>> md1 =3D raid1(sdb1, sdc2)
>>> md2 =3D raid1(sdc1, sda2)
>>> md3 =3D raid0(md0, md1, md2)
>>>
>>> As far as I can figure out, the performance should be pretty much t=
he
>>> same
>>> (although wrapping everything in a single raid10,f2 is more conveni=
ent).
>>
>> The performance will not be the same because. Whenever possible, md
>> reads from the outermost portion of the disk -- theoretically the
>> fastest portion of the disk (by 2 or 3 times as much as the inner
>> tracks) -- and in this way raid10,f2 can actually be faster than
>> raid0.
>>
>
> This would presumably apply to all raid1 arrangements, not just raid1=
0 -
> when md has a choice to read from more than one place it will prefer =
the
> outermost place. =A0In the arrangement I described above, the raid pa=
irs such
> as md0 each have one have on an inner partition, and one half on an o=
uter
> partition. =A0/If/ md is smart enough, then it will do the same here =
and read
> from the outer partition by preference.
>
> The question is, does md determine the "outermost" copy by track numb=
er
> relative to the partition, or by absolute track number on the disk? =A0=
If it
> is the former, then I see your point - with my raid 1 + 0 arrangement=
 the
> innermost and outermost partitions will be viewed the same. =A0If it =
is the
> later, then my arrangement will work equally well.
>
> On a related note, if you mix an SSD and a HD (partition) in a mirror=
, will
> md prefer to read from the SSD first? =A0I know it is possible to use=
 the
> "write-mostly" flag to force all reads to come from the SSD (assuming=
 it
> hasn't failed), but it would be nice to get parallel reads from the H=
D as
> well whenever the read is large enough or when there are multiple rea=
ds in
> parallel.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
