From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip (corrected email
 address)
Date: Fri, 2 Jan 2009 07:45:31 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901020745190.11852@p34.internal.lan>
References: <495E01E3.9060903@sm7jqb.se> <alpine.DEB.1.10.0901020741200.11852@p34.internal.lan>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-455362939-1230900331=:11852"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901020741200.11852@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: bengt@sm7jqb.se
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-455362939-1230900331=:11852
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 2 Jan 2009, Justin Piszcz wrote:

>
>
> On Fri, 2 Jan 2009, Bengt Samuelsson wrote:
>
>>=20
>> Hi,
>>=20
>> I need some support for this soft-raid system.
>>=20
>> I am running it as RAID5 with 4 samsung spinpoint 500G SATA300 tot 1.3T=
=20
>> byte
>>=20
>> And it runs in http://sm7jqb.dnsalias.com
>> I use mdadm sytem in a Debian Linux
>> CPU 1.2Mhz 1G memory ( my older 433Mhz / 512M dont work at all )
>>=20
>> I have 'some courrupt' data. And I don't understand whay and how to fix =
it.
>> Mybee slow it down more, but how slow it down?
>>=20
>> Any with experents from this cheep way of RAID systems.
>>=20
>> Ask for more information and I can get it, logs, setup files and what yo=
u=20
>> want
>> to know.
>>=20
>> --=20
>> Bengt Samuelsson
>> Nydalav=E4gen 30 A
>> 352 48 V=E4xj=F6
>>=20
>> +46(0)703686441
>>=20
>> http://sm7jqb.se
>>=20
>>=20
>> --=20
>> To UNSUBSCRIBE, email to debian-user-REQUEST@lists.debian.org with a=20
>> subject of "unsubscribe". Trouble? Contact listmaster@lists.debian.org
>>=20
>
> If this is an mdadm-related raid (not dmraid) please show all relevant md=
=20
> info, mdadm -D /dev/md0, I have cc'd linux-raid on this thread for you.
>
> You'll want to read md.txt in /usr/src/linux/Documentation and read on th=
e=20
> check and repair commands.
>
> In addition, have you run memtest86 on your system first to make sure its=
 not=20
> memory related?
>
> Justin.
---1463747160-455362939-1230900331=:11852--
