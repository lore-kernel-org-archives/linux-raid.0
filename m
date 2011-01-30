From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 01:54:42 +0000
Message-ID: <AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130015231.GA1435@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130015231.GA1435@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 01:52, Keld J=C3=B8rn Simonsen <keld@keldix.com> wro=
te:
> On Sat, Jan 29, 2011 at 11:44:01PM +0000, Mathias Bur=C3=A9n wrote:
>> On 29 January 2011 22:53, Roman Mamedov <rm@romanrm.ru> wrote:
>> > On Sat, 29 Jan 2011 22:48:06 +0000
>> > Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>> >
>> >> Hi,
>> >>
>> >> I'm wondering if the performance I'm getting is OK or if there's
>> >> something I can do about it. Also, where the potential bottleneck=
s
>> >> are.
>> >
>> > How are your disks plugged in? Which controller model(s), which bu=
s.
>> > But generally, on an Atom 1.6 Ghz those seem like good results.
>> >
>> > --
>> > With respect,
>> > Roman
>> >
>>
>>
>> Hi,
>>
>> Sorry, of course I should've included that. Here's the info:
>>
>> ~/bin $ sudo ./drivescan.sh
>> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>> =C2=A0 SATA controller: nVidia Corporation MCP79 AHCI Controller (re=
v b1)
>> =C2=A0 =C2=A0 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 103265055800=
09990027}
>> =C2=A0 =C2=A0 host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022=
443}
>> =C2=A0 =C2=A0 host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152=
590}
>> =C2=A0 =C2=A0 host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188=
479}
>> =C2=A0 =C2=A0 host4: [Empty]
>> =C2=A0 =C2=A0 host5: [Empty]
>
>
> Hmm, it seems like you have 2 empty slots on the on-board =C2=A0SATA
> controller. Try to move 2 of the disks from the other controller to t=
he
> on-board controller.
>
> And I would also avoid LVM. I think LVM affects striping.
>
> best regards
> Keld
>

Sadly the 2 empty slots are not to be found on the motherboard, I
guess they're in the chipset only.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
