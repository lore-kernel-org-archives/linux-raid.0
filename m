From: Drew <drew.kay@gmail.com>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with RAID1
	or 10, when creating:
Date: Sat, 22 Aug 2009 10:46:08 -0700
Message-ID: <c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> =C2=A0 =C2=A0 =C2=A0 =C2=A0"... It can also be used when creating a R=
AID1 or RAID10 if you want
> to avoid =C2=A0the =C2=A0initial =C2=A0resync ..."
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm wondering why namely those levels are =
chosen and not RAID5/6 for e. g.?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I think it's also safe to use with RAID5/6=
, isn't it?

RAID1/10 don't have parity calculations whereas RAID5/6 do.

--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
