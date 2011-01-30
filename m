From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 00:27:22 +0000
Message-ID: <AANLkTimnGw9k6yMkbC2hFYanPUdkHgchpob4wy6Whc3S@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130045706.4e8d6fa2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130045706.4e8d6fa2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 January 2011 23:57, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sat, 29 Jan 2011 23:44:01 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>> =C2=A0 SCSI storage controller: HighPoint Technologies, Inc. RocketR=
AID
>> 230x 4 Port SATA-II Controller (rev 02)
>> =C2=A0 =C2=A0 host6: [Empty]
>> =C2=A0 =C2=A0 host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ80096=
4 }
>> =C2=A0 =C2=A0 host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000=
331}
>> =C2=A0 =C2=A0 host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ80085=
0 }
>
> Does this controller support PCI-E 2.0? I doubt it.
> Does you Atom mainboard support PCI-E 2.0? I highly doubt it.
> And if PCI-E 1.0/1.1 is used, these last 3 drives are limited to 250 =
MB/sec.
> in total, which in reality will be closer to 200 MB/sec.
>
>> It's all SATA 3Gbs. OK, so from what you're saying I should see
>> significantly better results on a better CPU? The HDDs should be abl=
e
>> to push 80MB/s (read or write), and that should yield at least 5*80 =
=3D
>> 400MB/s (-1 for parity) on easy (sequential?) reads.
>
> According to the hdparm benchmark, your CPU can not read faster than =
640
> MB/sec from _RAM_, and that's just plain easy linear data from a buff=
er. So it
> is perhaps not promising with regard to whether you will get 400MB/se=
c reading
> from RAID6 (with all the corresponding overheads) or not.
>
> --
> With respect,
> Roman
>


Ah, right. The Ion platform actually supports PCI-E 2.0, but the
controller I'm using doesn't, according to lspci, if I understand it
correctly. SATA ontroller:

05:00.0 SCSI storage controller: HighPoint Technologies, Inc.
RocketRAID 230x 4 Port SATA-II Controller (rev 02)
	Subsystem: Marvell Technology Group Ltd. Device 11ab
	[....]
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00

PCI-Express bridge:

00:18.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev
b1) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	[...]
	Capabilities: [80] Express (v2) Root Port (Slot+), MSI 00

That might explain why the different stripe caches didn't have any
effect either. Thanks for pointing that out, apparently I didn't think
about it when I purchased the (super cheap) card.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
