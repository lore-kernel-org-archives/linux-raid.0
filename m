From: Tim Small <tim@seoss.co.uk>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of recovery
 when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 09:43:09 +0100
Message-ID: <4C68FA1D.7040105@seoss.co.uk>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>	<4C68CCC9.2050604@jungers.net> <AANLkTim9gUa95AR1KZcyBp7qM8_PeO1O7Bh99R2P8ON9@mail.gmail.com> <4C68D6D3.6070906@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C68D6D3.6070906@jungers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Jungers <nicolas@jungers.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, =?UTF-8?B?VG9yIEFybmUgVmVzdGI=?= =?UTF-8?B?w7g=?= <torarnv@gmail.com>
List-Id: linux-raid.ids

On 16/08/10 07:12, Nicolas Jungers wrote:
> On 08/16/2010 07:54 AM, Tor Arne Vestb=C3=B8 wrote:
>> You mean you sdc and sde plus either sdb or sdd, depending on which
>> one I think is more sane a this point?
>
> I'd try both.  Do a ddrescue of the failing one and try that (with=20
> copy of the others) and check what's coming out.

As an alternative to using ddrescue, you could quickly prototype variou=
s=20
arrangements (without writing anything to the drives) using a=20
device-mapper copy-on-write mapping - I posted some details to the list=
=20
a while back when I was trying to use this to reconstruct a hw raid=20
array...  Check the list archives for details.

Tim.

--=20
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
