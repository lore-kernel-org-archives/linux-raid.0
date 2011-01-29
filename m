From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sat, 29 Jan 2011 23:44:01 +0000
Message-ID: <AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130035352.1d72e8d1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 January 2011 22:53, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sat, 29 Jan 2011 22:48:06 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> Hi,
>>
>> I'm wondering if the performance I'm getting is OK or if there's
>> something I can do about it. Also, where the potential bottlenecks
>> are.
>
> How are your disks plugged in? Which controller model(s), which bus.
> But generally, on an Atom 1.6 Ghz those seem like good results.
>
> --
> With respect,
> Roman
>


Hi,

Sorry, of course I should've included that. Here's the info:

~/bin $ sudo ./drivescan.sh
Controller device @ pci0000:00/0000:00:0b.0 [ahci]
  SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
    host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
    host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
    host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
    host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
    host4: [Empty]
    host5: [Empty]
Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
  SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
230x 4 Port SATA-II Controller (rev 02)
    host6: [Empty]
    host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
    host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
    host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }

It's all SATA 3Gbs. OK, so from what you're saying I should see
significantly better results on a better CPU? The HDDs should be able
to push 80MB/s (read or write), and that should yield at least 5*80 =3D
400MB/s (-1 for parity) on easy (sequential?) reads.


// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
