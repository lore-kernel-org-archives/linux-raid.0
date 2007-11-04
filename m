From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Sun, 4 Nov 2007 08:42:04 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711040841160.2225@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <472DCBBB.1040806@systella.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-851533030-1194183724=:2225"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472DCBBB.1040806@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-851533030-1194183724=:2225
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 4 Nov 2007, BERTRAND Jo=EBl wrote:

> Justin Piszcz wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflus=
h]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflus=
h]
>>=20
>> After several days/weeks, this is the second time this has happened, whi=
le=20
>> doing regular file I/O (decompressing a file), everything on the device=
=20
>> went into D-state.
>
> =09Same observation here (kernel 2.6.23). I can see this bug when I try=
=20
> to synchronize a raid1 volume over iSCSI (each element is a raid5 volume)=
, or=20
> sometimes only with a 1,5 TB raid5 volume. When this bug occurs, md subsy=
stem=20
> eats 100% of one CPU and pdflush remains in D state too. What is your=20
> architecture ? I use two 32-threads T1000 (sparc64), and I'm trying to=20
> determine if this bug is arch specific.
>
> =09Regards,
>
> =09JKB
>

Using x86_64 here (Q6600/Intel DG965WH).

Justin.
---1463747160-851533030-1194183724=:2225--
