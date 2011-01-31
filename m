From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 21:00:28 -0200
Message-ID: <AANLkTikHnaEa_Ga64bjwOM7=DibXzRc9P53U_gfewWKY@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131225235.GA11775@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> =3D] hehehe there is no standard for linux, just the linux standard =
that
>> was implemented :P
it=B4s a joke =3DP hhehe

>> you can?t get a smart array(hp) disk and put on a perc(dell) or linu=
x
>> mdadm and wait it will work without tweaking...
they are not standard based?! (they are standard based! before anyone t=
ell...)


i was talking about wikipedia writers thinking that linux don=B4t have =
a
standard, check last email to understand the context:

>Before this goes any further, why not just reference the excellent
>Wikipedia article (actually, excellent applies to both Wikipedia *and*
>the article):
>http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
>
>The only problem I have with the wikipedia article is the assertion
>that Linux MD RAID 10 is non-standard. It's as standard as anything
>else is in this world.
>
>
>--
>Jon






2011/1/31 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Mon, Jan 31, 2011 at 07:47:05PM -0200, Roberto Spadim wrote:
>> =3D] hehehe there is no standard for linux, just the linux standard =
that
>> was implemented :P
>
> There is a Linux standard, LSB Linux Standard Base ISO/IEC 23360.
> And then there is the POSIX standard that the Linux kernel and
> many utilities in GNU/linux follow. POSIX is ISO/IEC 9945.
>
>> linux raid10 work and is the same idea of the 'raid10' academic stan=
dard
>
> raid1+0 and Linux MD raid10 are similar, but significantly different
> in a number of ways. Linux MD raid10 can run on only 2 drives.
> Linux raid10,f2 has almost RAID0 striping performance in sequential r=
ead.
> You can have an odd number of drives in raid10.
> And you can have as many copies as you like in raid10,
>
>> i don?t know any raid standard, just hardware based standard
>
> There is an organisation that standardizes RAID levels.
> Unfortunately I cannot find a link right now.
> The raid10 offset layout is an implementation of one of their specs.
>
>> you can?t get a smart array(hp) disk and put on a perc(dell) or linu=
x
>> mdadm and wait it will work without tweaking...
>
> Yes. And?
>
> best regards
> keld
>
>> 2011/1/31 Jon Nelson <jnelson-linux-raid@jamponi.net>:
>> > Before this goes any further, why not just reference the excellent
>> > Wikipedia article (actually, excellent applies to both Wikipedia *=
and*
>> > the article):
>> >
>> > http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAI=
D_10
>> >
>> > The only problem I have with the wikipedia article is the assertio=
n
>> > that Linux MD RAID 10 is non-standard. It's as standard as anythin=
g
>> > else is in this world.
>> >
>> >
>> > --
>> > Jon
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
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
