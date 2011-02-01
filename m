From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 19:04:35 -0200
Message-ID: <AANLkTi=T7=c974t+EtFTB2RVb0GnHLyFJTxXC0U+GBm_@mail.gmail.com>
References: <20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<20110131225235.GA11775@www2.open-std.org>
	<ii8lcv$3jg$1@dough.gmane.org>
	<20110201160245.GA25659@www2.open-std.org>
	<20110201203210.GB26468@www2.open-std.org>
	<AANLkTiksG6oJMdJ=z3ZELk=_2FWGRWVVhHUvrBPa2+J1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiksG6oJMdJ=z3ZELk=_2FWGRWVVhHUvrBPa2+J1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the problem for benchmark on linux (mdadm) raid implementation (raid1
vs raid0) is:
raid1 read balance(closest head) is diferent from raid0 read
balance(stripe) algorithm

it=B4s good but can=B4t be as fast as raid0 for read intensive (sequent=
ial)
the problem of closest head algorithm is it can=B4t paralelize reads
like raid0 paralelize


2011/2/1 Roberto Spadim <roberto@spadim.com.br>:
>> For sequential reading, this is not true. For random reading and
>> writing I agree with you in theory, but benchmarks show that it is n=
ot
>> so, at least for Linux RAID, viz the above URL.
>
> i agree with you, since linux algorith for raid1 is closest head, not
> round robin or time based
>
> there=B4s some patch on internet (google it: round robin raid1 linux)
> for roundrobin, but none for time based =3D(
> it=B4s a point of optimization of today raid1 algorithm
>
> round robin (may be at this mail list)
> http://www.spinics.net/lists/raid/msg30003.html
>
> 2011/2/1 Keld J=F8rn Simonsen <keld@keldix.com>:
>> On Tue, Feb 01, 2011 at 05:02:46PM +0100, Keld J=F8rn Simonsen wrote=
:
>>> On Tue, Feb 01, 2011 at 11:01:33AM +0100, David Brown wrote:
>>> > On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
>>> > >raid1+0 and Linux MD raid10 are similar, but significantly diffe=
rent
>>> > >in a number of ways. Linux MD raid10 can run on only 2 drives.
>>> > >Linux raid10,f2 has almost RAID0 striping performance in sequent=
ial read.
>>> > >You can have an odd number of drives in raid10.
>>> > >And you can have as many copies as you like in raid10,
>>> > >
>>> >
>>> > You can make raid10,f2 functionality from raid1+0 by using partit=
ions.
>>> > For example, to get a raid10,f2 equivalent on two drives, partiti=
on them
>>> > into equal halves. =A0Then make md0 a raid1 mirror of sda1 and sd=
b2, and
>>> > md1 a raid1 mirror of sdb1 and sda2. =A0Finally, make md2 a raid0=
 stripe
>>> > set of md0 and md1.
>>>
>>> I don't think you get the striping performance of raid10,f2 with th=
is
>>> layout. And that is one of the main advantages of raid10,f2 layout.
>>> Have you tried it out?
>>>
>>> As far as I can see the layout of blocks are not alternating betwee=
n the
>>> disks. You have one raid1 of sda1 and sdb2, there a file is allocat=
ed on
>>> blocks sequentially on sda1 and then mirrored on sdb2, where it is =
also
>>> sequentially allocated. That gives no striping.
>>
>> Well, maybe the RAID0 layer provides the adequate striping.
>> I am noy sure, but it looks like it could hold in theory.
>> One could try it out.
>>
>> One advantage of this scheme could be improved probability
>> When 2 drives fail, eg. in the case of a 4 drive array.
>> The probability of survival of a running system could then
>> be enhaced form 33 % to 66 %.
>>
>> One problem could be the choice of always the lowest block number, w=
hich
>> is secured in raid10,f2, but not in a raid0 over raid1 (or raid10,n2=
) scenario.
>>
>> best regards
>> keld
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
