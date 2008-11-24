From: Alex Lilley <alex@redwax.co.uk>
Subject: Re: Raid 5 --grow to fewer, larger drivers
Date: Mon, 24 Nov 2008 18:28:16 +0000
Message-ID: <492AF240.9020608@redwax.co.uk>
References: <492AA493.6080605@redwax.co.uk> <1f0f1a960811240621j619701aboc32c2da9765cd7a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960811240621j619701aboc32c2da9765cd7a1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Twigathy <twigathy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That is an interesting work around T, though it does have its own=20
issues, namely the need to take the data off-line for the time of the=20
copy over the network besides the hassle.

I would be interested to know why there would be any greater=20
difficulty/risk in growing to fewer, larger disks than simply growing t=
o=20
more disks of the same size.  The problem is that if you have a number=20
of disks and need more space, you add another disk of the same size and=
=20
lots of disks will eventually bite you on the bum, so being able to=20
consolidate in the way I set out would be a real bonus and nice and=20
straight forward (or maybe not!?)

Regarding the risk factor during any array resync, I should hope we all=
=20
have a precious data backed up anyway!

Thanks for you =C2=A30.02 though :-)

Alex

Twigathy wrote:
> In that situation, I think I'd be happier to hook all the disks up (I=
f
> not on the same machine, on two machines on the same [gigE] network,
> make a new raid5 on the new set of disks, rsync stuff to the new arra=
y
> and then retire the old array (Swapping in the array you just
> created)... messing around resizing disks for this job just sounds
> like mess and risk to me!
>
> Just my =C2=A30.02 ;-)
>
> T
>
> 2008/11/24 Alex Lilley <alex@redwax.co.uk>:
>  =20
>> Senario:  raid5 with  4 x 120gb.
>>
>> aim:  raid5 with 3 x 250gb
>>
>> 3 x 120gb disks replaced with 3 x 250gb, array has been rebuilt/resy=
nc'd at
>> original size. Can we remove the remaining 120gb drive and reshape t=
he array
>> over the remaining 3 drives using all the new space.
>>
>> I guessed --grow --raid-devices=3D3 --size-max would work but return=
s "can
>> change at most one of size, raiddisks, bitmap and layout"
>>
>> I then --failed and --remove the remaining 120gb drive and tried --g=
row
>> --raid-devices=3D3 but receive "Cannot reduce number of data disks (=
yet)".
>>
>> I am therefore slightly stumped!
>>
>> Is this something that is actually possible or something that is pla=
nned for
>> because as the size of disk drives multiplies and the desire to keep=
 tabs of
>> power usage increases it is likely that we will want to reduce the n=
umber of
>> disk, besides the obvious increased risk of failure introduced by ha=
ving a
>> greater number of drives.
>>
>> Regards
>>
>> Alex
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    =20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD=
,j=07=EF=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=
=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ=
+=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
