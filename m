From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: aoe disk not recognized as part of raid
Date: Sun, 25 May 2008 08:28:58 +1200
Message-ID: <48387A8A.3020201@sauce.co.nz>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>    <20080523170056.d6e39787.taeuber@bbaw.de> <46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Sat, May 24, 2008 1:00 am, Lars T=C3=A4uber wrote:
>> Sorry!
>>
>>> mdadm version 2.6.6 although it is reported as:
>>> monosan:~ # mdadm -V
>>> mdadm - v2.6 - 21 December 2006
>> I accidentally compiled mdadm 2.6 instead of 2.6.6. But this is even
>> worse:
>>
>> monosan:~ # mdadm -V
>> mdadm - v2.6.6 - 19th May 2008
>> monosan:~ # mdadm -As
>> Segmentation fault
>=20
> That's bad.
> What do you get from:
>=20
>  ulimit -c unlimited
>  mdadm -As
>  gdb `which mdadm` core
>  where
>=20
> ??
>=20
> NeilBrown

I saw this last week, but can unfortunately only offer limited=20
information - for various reasons, this system is no longer available.

On an up to date Fedora 8 x86_64 2.6.24.7-92.fc8 sytem, I replaced mdad=
m=20
with a locally built mdadm 2.6.5 - compiled with -O2.

On the next reboot, the md RAID1 / failed to assemble, with mdadm=20
errors. When I accessed from a rescue disk, running mdadm -A /dev/mdX=20
(can't rember exact dev), returned "Segmentation fault".

If it's any use, I do still have a complete mdadm 2.6.5 tree containing=
=20
the faulty objects from this system.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
