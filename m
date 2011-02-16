From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 11:21:50 -0300
Message-ID: <AANLkTi=DpeH0Ba2T_wJHuSYXzORpfW5W42SP6bUkBf-f@mail.gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BB4EA.8030907@texsoft.it>
	<AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
	<20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
	<AANLkTikeGuar5eBb7fv3+bLt=Z=bM9Zt7LfKeshxxJ9U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikeGuar5eBb7fv3+bLt=Z=bM9Zt7LfKeshxxJ9U@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

since we have the option1 done, why continue with raid1 code? could we
port write-behind to raid10 code?
another thing, could raid10 work without replica? like a raid0?

why? just to remove many files with the same function (raid1and raid0,
if raid10 do the same work, many some mdadm changes allow us to
--level=3D1 to understand that's raid10 without stripe, --level=3D0 is
raid10 without mirrors)

2011/2/16 Roberto Spadim <roberto@spadim.com.br>:
> hummm nice =3D)
> near layout is the key for many mirrors?
> i will check more layouts
>
> 2011/2/16 Robin Hill <robin@robinhill.me.uk>:
>> On Wed Feb 16, 2011 at 10:40:40AM -0300, Roberto Spadim wrote:
>>
>>> i agree with giovanni, another question since we will make a lot of
>>> change on mirrors based arrays (raid1, raid10) with the badblock li=
st,
>>> could we:
>>>
>>> option1) remove raid1 code, change raid10 to work without raid0
>>> 'service', change raid10 to work with more than 1mirror (like raid1
>>> do)?
>>> option2) port raid10 layout to raid1?
>>>
>> You can already do option1 (if I'm understanding you correctly). =A0=
A
>> RAID10 array can use as many mirrors as you like (--layout n2 is the
>> default, meaning a near layout with 2 replicas, using n4 would give =
4
>> replicas), and as long as the number of replicas is equal to the num=
ber
>> of devices, there should be no striping involved in the process.
>>
>> Cheers,
>> =A0 =A0Robin
>> --
>> =A0 =A0 ___
>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@=
robinhill.me.uk> |
>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
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
