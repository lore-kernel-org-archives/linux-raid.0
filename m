From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 20:36:52 -0200
Message-ID: <AANLkTikS-mD-sxr5XFFA15EGv2tFKa=F5K8EJFeiGfVU@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<4D470F96.40409@cfl.rr.com>
	<AANLkTim57HwYefXg=4CK06X+VXcW3o28VwRxCEnpaeEV@mail.gmail.com>
	<4D4711A5.8070601@cfl.rr.com>
	<AANLkTinVdMA0izAvN0ZS14wMV=p3XUtbgBe+1LwxafD=@mail.gmail.com>
	<4D473366.6090401@cfl.rr.com>
	<AANLkTinEGO9V7oZ7p8YveKe7QXXmLi9xdrhhmj7LS_JZ@mail.gmail.com>
	<AANLkTi=Lm8b+6pbQ0Gm3mw2qGX70uSeu6Li0+Gr7hnqF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Lm8b+6pbQ0Gm3mw2qGX70uSeu6Li0+Gr7hnqF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis <denismpa@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

if you go to hardware level, check first.. is your server mirror
based? if you lost your UPS what=B4s the total system security?
here (mdadm) we just use mdadm, we don=B4t need probability for upper
layers (filesystem) or bottom layers (hardware) we need probability on
devices that=B4s the layer that mdadm work, linux devices. that=B4s why=
 we
should use mirror based probability! not disk based!

2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> it=B4s not just a probability problem, it=B4s a probability based on =
variable type
> if you want probability based on mirror you have a result, if you wan=
t
> probability based on disk you have another result
> raid0 allow disks (but we don=B4t have a 0,5 raid0 system, we just al=
low
> integers numbers, we can=B4t allow decimal numbers on this probabilit=
y!)
>
> the problem here is: raid0 isn=B4t divisible, we can=B4t run a 0,5 ra=
id0
> system. we need a full working raid0 to have a working mirror, a half
> disk don=B4t help us to WORK, just to test and play with data, not to
> real production work! why we don=B4t buy disks with bad blocks? got t=
he
> problem? for tests ok, for production NEVER
>
> i had a raid1 system broken last month, i have luck, two disks of 4
> disks are broken, the first raid0 and the last raid0 but they are on
> separated mirrors (the server hit the floor, sorry boss =3D( ).
>
> i lost information? no! the last raid0 brolen disk was never used =3D=
],
> i used concatenate raid0 (LINEAR), if i was using raid0 with stripe i
> was f****
> result: 4 new disks, 2 working 2 broken (i opened it! and 2 was good,
> after open it they are broken hehehe)
>
> that=B4s the problem, we can=B4t allow luck on production servers,
> consider using probability based on mirrors(only integer numbers) not
> on disks(decimal number of mirror)
>
> i could lost all my informations since i broken two mirrors on two
> mirror based server...
> make probability using integers not decimal numbers... since raid1 is
> mirrors based
>
> another example...
> i want raid10 (2mirrors) if i make partition on 4 disks (8 partitions=
,
> 2 per disk) and make raid1 on each partition on same disk (4 disk sel=
f
> mirrored) what the probability?
>
> i tell you is it mirror based or disk based?
> since software raid (mdadm) is mirror based you have 2 mirrors, you
> can lost 1 mirror! that=B4s the key. for mdadm you can=B4t go inside
> mirror device (just for raid0) but you can=B4t tell that=B4s a good
> probability
>
> look OCZ Revo-drive
> it=B4s a ssd pci board with two SATA SSD storage (120gb revodrive =3D=
 2x
> 55gb ssd) if i make self mirror i have a fault tolerant system? yes!
> understand now? for mdadm we have 2 mirrors, don=B4t make probability
> based on disks! make probability based on mirrors!
>
> 2011/1/31 Denis <denismpa@gmail.com>:
>> 2011/1/31 Phillip Susi <psusi@cfl.rr.com>:
>>> On 1/31/2011 2:53 PM, Roberto Spadim wrote:
>>>> if you have a bigger and bigger and bigger disk configuration and =
only
>>>> two mirrors you still with =A050%
>> might help http://en.wikipedia.org/wiki/Probability
>>
>>
>> --
>> Denis Anjos,
>> www.versatushpc.com.br
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
