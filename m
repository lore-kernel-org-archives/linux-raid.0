From: Phil Turmel <philip@turmel.org>
Subject: Re: MD on raw device, use unallocated space anyway?
Date: Fri, 10 Jan 2014 18:19:01 -0500
Message-ID: <52D07FE5.1030703@turmel.org>
References: <CADNH=7H2E5J3MPyGt4YHHK8wLzhizJLmdos0G60OE1qEwvBOKg@mail.gmail.com>	<BLU0-SMTP3004D13A23660A4859D816298B30@phx.gbl>	<CADNH=7FRJwC+N8dTfOgbXRxcVa0Drcrptv=tmXY33mz25zdgYg@mail.gmail.com>	<BLU0-SMTP163A53F7E505381E9CB2F2598B30@phx.gbl> <CADNH=7E3X7nbNC333==kN4X51=jAGJ4gF+qC_OX1uJ=GyUmR=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7E3X7nbNC333==kN4X51=jAGJ4gF+qC_OX1uJ=GyUmR=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, Wilson Jonathan <piercing_male@hotmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/10/2014 03:38 PM, Mathias Bur=C3=A9n wrote:
> On 10 January 2014 20:10, Wilson Jonathan <piercing_male@hotmail.com>=
 wrote:
>>
>> In that case the answer would be no. However if fail/remove the 3TB
>> drive, then partitioned the drive as 2TB and 1TB and then added the =
2TB
>> partition back into the array then you can use the 1TB on its own...
>> just as long the "2TB" partition is the same size as the 2TB drives =
(or
>> slightly bigger) then it should all work nicely.
>=20
> Thanks, that confirms my suspicions. I wanted to avoid this (as a
> rebuild would be required) but it's the only way, I suppose.

Actually, you could move the data currently starting at sector zero to
sector 2048 (1MB) or some other start point, then partition the drive t=
o
point at it.  If your array has a bitmap, then you could quickly
--re-add the partition to the array.

> Unless I
> upgrade to 3TB all around and gain some storage.

Can't beat that.  :-)

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
