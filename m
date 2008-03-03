From: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array as (somewhat) faulty
Date: Mon, 3 Mar 2008 12:44:20 +0100
Message-ID: <47CBE494.3060406@gmail.com>
References: <47CBD62E.7040608@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CBD62E.7040608@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hello,
>=20
> Noticing the problems Tor Vestb=F8 is having, I remembered that I hav=
e an=20
> array in a similar state, which I never figured out.=20

[snip]

>     Array Slot : 4 (failed, 1, 2, 3, 0)
>    Array State : Uuuu 1 failed            <-- why is that?
> root@Thesaurus:~#

I've seen this in my array too. Was expecting Uuu_, or Uuuu after=20
rebuild, but it also said "1 failed".

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
