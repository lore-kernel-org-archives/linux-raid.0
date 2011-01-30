From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 00:33:48 +0000
Message-ID: <AANLkTik+Yhhcrmf0R-c7R_W-Bym4bWEYO0f4-WTZd8TL@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130045706.4e8d6fa2@natsu>
	<4D44ADB2.9090707@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D44ADB2.9090707@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 00:15, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Roman Mamedov put forth on 1/29/2011 5:57 PM:
>> On Sat, 29 Jan 2011 23:44:01 +0000
>> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>>
>>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>>> =C2=A0 SCSI storage controller: HighPoint Technologies, Inc. Rocket=
RAID
>>> 230x 4 Port SATA-II Controller (rev 02)
>>> =C2=A0 =C2=A0 host6: [Empty]
>>> =C2=A0 =C2=A0 host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ8009=
64 }
>>> =C2=A0 =C2=A0 host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA100=
0331}
>>> =C2=A0 =C2=A0 host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ8008=
50 }
>>
>> Does this controller support PCI-E 2.0? I doubt it.
>> Does you Atom mainboard support PCI-E 2.0? I highly doubt it.
>> And if PCI-E 1.0/1.1 is used, these last 3 drives are limited to 250=
 MB/sec.
>> in total, which in reality will be closer to 200 MB/sec.
>>
>>> It's all SATA 3Gbs. OK, so from what you're saying I should see
>>> significantly better results on a better CPU? The HDDs should be ab=
le
>>> to push 80MB/s (read or write), and that should yield at least 5*80=
 =3D
>>> 400MB/s (-1 for parity) on easy (sequential?) reads.
>>
>> According to the hdparm benchmark, your CPU can not read faster than=
 640
>> MB/sec from _RAM_, and that's just plain easy linear data from a buf=
fer. So it
>> is perhaps not promising with regard to whether you will get 400MB/s=
ec reading
>> from RAID6 (with all the corresponding overheads) or not.
>
> It's also not promising given that 4 of his 6 drives are WDC-WD20EARS=
, which
> suck harder than a Dirt Devil at 240 volts, and the fact his 6 drives=
 don't
> match. =C2=A0Sure, you say "Non matching drives are what software RAI=
D is for right?"
> =C2=A0Wrong, if you want best performance.
>
> About the only things that might give you a decent boost at this poin=
t are some
> EXT4 mount options in /etc/fstab: =C2=A0data=3Dwriteback,barrier=3D0
>
> The first eliminates strict write ordering. =C2=A0The second disables=
 write barriers,
> so the drive's caches don't get flushed by Linux, and instead work as=
 the
> firmware intends. =C2=A0The first of these is safe. =C2=A0The second =
may cause some
> additional data loss if writes are in flight when the power goes out =
or the
> kernel crashes. =C2=A0I'd recommend adding both to fstab, reboot and =
run your tests.
> =C2=A0Post the results here.
>
> If you have a decent UPS and auto shutdown software to down the syste=
m when the
> battery gets low during an outage, keep these settings if they yield
> substantially better performance.
>
> --
> Stan
>

Right. I wasn't using the writeback option. I won't disable barriers
as I've no UPS. I've seen the stripe=3D ext4 mount option, from
http://www.mjmwired.net/kernel/Documentation/filesystems/ext4.txt :

287	stripe=3Dn		Number of filesystem blocks that mballoc will try
288				to use for allocation size and alignment. For RAID5/6
289				systems this should be the number of data
290				disks *  RAID chunk size in file system blocks.

I suppose in my case, number of data disks is 5, RAID chunk size is
64KB, file system block size is 4KB. This is on top of LVM, I don't
know how that affects the situation. So, the mount option would be
stripe=3D80? (5*64/4)

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
