From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Performance question, RAID5
Date: Sat, 29 Jan 2011 18:15:46 -0600
Message-ID: <4D44ADB2.9090707@hardwarefreak.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>	<20110130035352.1d72e8d1@natsu>	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com> <20110130045706.4e8d6fa2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130045706.4e8d6fa2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roman Mamedov put forth on 1/29/2011 5:57 PM:
> On Sat, 29 Jan 2011 23:44:01 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>=20
>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>>   SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
>> 230x 4 Port SATA-II Controller (rev 02)
>>     host6: [Empty]
>>     host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>>     host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>>     host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }
>=20
> Does this controller support PCI-E 2.0? I doubt it.
> Does you Atom mainboard support PCI-E 2.0? I highly doubt it.
> And if PCI-E 1.0/1.1 is used, these last 3 drives are limited to 250 =
MB/sec.
> in total, which in reality will be closer to 200 MB/sec.
>=20
>> It's all SATA 3Gbs. OK, so from what you're saying I should see
>> significantly better results on a better CPU? The HDDs should be abl=
e
>> to push 80MB/s (read or write), and that should yield at least 5*80 =
=3D
>> 400MB/s (-1 for parity) on easy (sequential?) reads.
>=20
> According to the hdparm benchmark, your CPU can not read faster than =
640
> MB/sec from _RAM_, and that's just plain easy linear data from a buff=
er. So it
> is perhaps not promising with regard to whether you will get 400MB/se=
c reading
> from RAID6 (with all the corresponding overheads) or not.

It's also not promising given that 4 of his 6 drives are WDC-WD20EARS, =
which
suck harder than a Dirt Devil at 240 volts, and the fact his 6 drives d=
on't
match.  Sure, you say "Non matching drives are what software RAID is fo=
r right?"
 Wrong, if you want best performance.

About the only things that might give you a decent boost at this point =
are some
EXT4 mount options in /etc/fstab:  data=3Dwriteback,barrier=3D0

The first eliminates strict write ordering.  The second disables write =
barriers,
so the drive's caches don't get flushed by Linux, and instead work as t=
he
firmware intends.  The first of these is safe.  The second may cause so=
me
additional data loss if writes are in flight when the power goes out or=
 the
kernel crashes.  I'd recommend adding both to fstab, reboot and run you=
r tests.
 Post the results here.

If you have a decent UPS and auto shutdown software to down the system =
when the
battery gets low during an outage, keep these settings if they yield
substantially better performance.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
