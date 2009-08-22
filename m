From: "NeilBrown" <neilb@suse.de>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with
     RAID1  or 10, when creating:
Date: Sun, 23 Aug 2009 07:19:32 +1000 (EST)
Message-ID: <b5c57585f8e55bf526f86418980dfbb4.squirrel@neil.brown.name>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
    <c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
    <43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, August 23, 2009 3:48 am, Igor Podlesny wrote:
> 2009/8/23 Drew <drew.kay@gmail.com>:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0"... It can also be used when creating a=
 RAID1 or RAID10 if
>>> you want
>>> to avoid =C2=A0the =C2=A0initial =C2=A0resync ..."
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm wondering why namely those levels ar=
e chosen and not
>>> RAID5/6 for e. g.?
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0I think it's also safe to use with RAID5=
/6, isn't it?
>>
>> RAID1/10 don't have parity calculations whereas RAID5/6 do.
>
> 	Well, and what does it change? I mean if we write some data to that
> "assume clean" RAID5/6 the parity will be updated anyway.
>

Yes it will be updated.  But if it is updated with a
read-modify-write cycle then an old incorrect value will be updated
to a new incorrect value, which doesn't help you much.

The current RAID6 implementation never does read-modify-write for
P/Q update so you could get away with --assume-clean there, but I
don't promise that future implementations will never use r-m-w.
RAID5 definitely does use R-M-W for single-block writes on
arrays of 4 or more drives.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
