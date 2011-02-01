From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 12:25:00 -0200
Message-ID: <AANLkTinDHzOJFB+-qkNnnfcuR4_3_HPPyOahY1SPQ7E2@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice, english isn=B4t my language, i=B4m not offended, i know that we h=
ave
problem reading my words... thanks =3D)

probability using =B4raid world words=B4, isn=B4t =B4mdadm world words=B4
since mdadm don=B4t work with disk or ssd (it work with devices)
probability can=B4t go inside device to try to explain anything without
knowing how mdadm works

if you want global system probability, don=B4t call mdadm as a source o=
f
probability if you don=B4t know what it can do.
can a failed mirror be used without sync? no

another point, after a fail (disk) will your system stop or continue?
did you probability consider a fixed point in time or a global
scenario? talking about probability, try to explain the context, and
how to calculate it (it=B4s necessary, belive me)

using mdadm raid10 how many devices could you lose, for mirror context?
1 mirror, right? losing 1 mirror =3D losing 1 raid0 disk, right?
if ok, make probability (for mdadm world) with this mirrors, not with d=
isks
use probability with the most secure results, it=B4s not a academic
probability, it=B4s a production use software, use secure results.

the original question... how could i make probability about security
for mdadm software? raid1 raid10 raid 5 raid6 raid0, all raid, maybe
the answer could be documentated on raid wiki =3D), just to don=B4t get
back again in this mail list
anyone could help with this part of documentation
probability isn=B4t just numbers, it=B4s numbers+context
a car can be a vehicle, but a vehicle can be a truck too
probability numbers are nothing without context

2011/2/1 Jon Nelson <jnelson-linux-raid@jamponi.net>:
> On Tue, Feb 1, 2011 at 4:01 AM, David Brown <david@westcontrol.com> w=
rote:
>> On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
>>>
>>> raid1+0 and Linux MD raid10 are similar, but significantly differen=
t
>>> in a number of ways. Linux MD raid10 can run on only 2 drives.
>>> Linux raid10,f2 has almost RAID0 striping performance in sequential=
 read.
>>> You can have an odd number of drives in raid10.
>>> And you can have as many copies as you like in raid10,
>>>
>>
>> You can make raid10,f2 functionality from raid1+0 by using partition=
s. For
>> example, to get a raid10,f2 equivalent on two drives, partition them=
 into
>> equal halves. =A0Then make md0 a raid1 mirror of sda1 and sdb2, and =
md1 a
>> raid1 mirror of sdb1 and sda2. =A0Finally, make md2 a raid0 stripe s=
et of md0
>> and md1.
>>
>> If you have three disks, you can do that too:
>>
>> md0 =3D raid1(sda1, sdb2)
>> md1 =3D raid1(sdb1, sdc2)
>> md2 =3D raid1(sdc1, sda2)
>> md3 =3D raid0(md0, md1, md2)
>>
>> As far as I can figure out, the performance should be pretty much th=
e same
>> (although wrapping everything in a single raid10,f2 is more convenie=
nt).
>
> The performance will not be the same because. Whenever possible, md
> reads from the outermost portion of the disk -- theoretically the
> fastest portion of the disk (by 2 or 3 times as much as the inner
> tracks) -- and in this way raid10,f2 can actually be faster than
> raid0.
>
>
> --
> Jon
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
