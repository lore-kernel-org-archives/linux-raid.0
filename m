From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with RAID1
	or 10, when creating:
Date: Sun, 23 Aug 2009 01:48:51 +0800
Message-ID: <43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
	<c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/8/23 Drew <drew.kay@gmail.com>:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0"... It can also be used when creating a =
RAID1 or RAID10 if you want
>> to avoid =C2=A0the =C2=A0initial =C2=A0resync ..."
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm wondering why namely those levels are=
 chosen and not RAID5/6 for e. g.?
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0I think it's also safe to use with RAID5/=
6, isn't it?
>
> RAID1/10 don't have parity calculations whereas RAID5/6 do.

	Well, and what does it change? I mean if we write some data to that
"assume clean" RAID5/6 the parity will be updated anyway.

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
