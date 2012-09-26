From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Wed, 26 Sep 2012 13:33:49 -0600
Message-ID: <F2C9D196-A5AC-4F35-9177-FDFCA755FB2B@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <5231765.ZMIFzBOKSc@techz> <FABB1E4C-1CAC-429F-96CF-FC563336A913@colorremedies.com> <5315095.pvR2SvTGWe@techz>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5315095.pvR2SvTGWe@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 26, 2012, at 6:17 AM, G=FCnther J. Niederwimmer wrote:
>>=20
>> dirty state.
>=20
> OK, I run the Intel Tool in windows two times with the last Tool I fo=
und.
>=20
> The Tool don't found any Problem (?) and don't repair, but mdadm=85.

I'm going to trim this down:

>=20
> /dev/sda:
> [Volume0]:
>           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
>       Map State : normal
>    Dirty State : clean
>=20
>=20
> /dev/sdb:
> [Volume0]:
>           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
>      Map State : normal
>    Dirty State : dirty
>                 =B0=B0=B0=B0=B0=B0=B0

I don't understand this UI. Are there two Volume0's?=20

I can see how the dirty state would apply independently among physical =
devices /dev/sda and /dev/sdb. But the virtual device, the array volume=
, "Volume0" seems like it would have only one instance. So I don't unde=
rstand how it can be clean in one case and dirty in another.



Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
