From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 11:09:57 -0300
Message-ID: <AANLkTikeGuar5eBb7fv3+bLt=Z=bM9Zt7LfKeshxxJ9U@mail.gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BB4EA.8030907@texsoft.it>
	<AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
	<20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
Cc: Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

hummm nice =3D)
near layout is the key for many mirrors?
i will check more layouts

2011/2/16 Robin Hill <robin@robinhill.me.uk>:
> On Wed Feb 16, 2011 at 10:40:40AM -0300, Roberto Spadim wrote:
>
>> i agree with giovanni, another question since we will make a lot of
>> change on mirrors based arrays (raid1, raid10) with the badblock lis=
t,
>> could we:
>>
>> option1) remove raid1 code, change raid10 to work without raid0
>> 'service', change raid10 to work with more than 1mirror (like raid1
>> do)?
>> option2) port raid10 layout to raid1?
>>
> You can already do option1 (if I'm understanding you correctly). =A0A
> RAID10 array can use as many mirrors as you like (--layout n2 is the
> default, meaning a near layout with 2 replicas, using n4 would give 4
> replicas), and as long as the number of replicas is equal to the numb=
er
> of devices, there should be no striping involved in the process.
>
> Cheers,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
