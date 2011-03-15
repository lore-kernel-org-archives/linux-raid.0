From: Rory Jaffe <rsjaffe@gmail.com>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Tue, 15 Mar 2011 05:53:27 +0000
Message-ID: <AANLkTikw4rf=T-hM4P5kCd9UaD_5ffZK=mn-6DPdG1nK@mail.gmail.com>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
	<4D7B85EB.60505@turmel.org>
	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
	<AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
	<4D7BB462.5030706@turmel.org>
	<AANLkTim+OwO5-w5Hhjdchp+Nj8k0zTLqqvRKfAzFgkWz@mail.gmail.com>
	<4D7BD323.3040205@turmel.org>
	<AANLkTi=ZtxFJDtYCP62BZDg5=QyM3873eNDXZqC2c_wu@mail.gmail.com>
	<4D7CC7B9.3010207@turmel.org>
	<AANLkTinHVJh-fd2z6Rq037CuAUXwnJK1tEjgxM60OHnP@mail.gmail.com>
	<20110315164441.109af85e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315164441.109af85e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> ubuntu@ubuntu:~/mdadm-3.2$ mdadm -V
>> mdadm - v3.2 DEVELOPER_ONLY - 1st February 2011 (USE WITH CARE)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^^^^^^^^^^^^^ =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^=
^^^^^^^^^^^^
>
> I guess you must be a developer, so probably don't need any help....
>
> But may I suggest trying mdadm-3.1.4 instead??
>
> NeilBrown
Well, I was developing a headache. Does that qualify me as a developer?

Seriously, point well-taken. I've now installed 3.1.4. 3.1.4 seems to
be doing the job correctly.

It's now reshaping.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
