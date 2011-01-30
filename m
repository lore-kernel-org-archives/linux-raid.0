From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 12:12:36 +0000
Message-ID: <AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130015231.GA1435@www2.open-std.org>
	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
	<20110130055616.GA13022@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130055616.GA13022@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/1/30 Keld J=C3=B8rn Simonsen <keld@keldix.com>:
> On Sun, Jan 30, 2011 at 01:54:42AM +0000, Mathias Bur=C3=A9n wrote:
>> On 30 January 2011 01:52, Keld J=C3=B8rn Simonsen <keld@keldix.com> =
wrote:
>> > On Sat, Jan 29, 2011 at 11:44:01PM +0000, Mathias Bur=C3=A9n wrote=
:
>> >> On 29 January 2011 22:53, Roman Mamedov <rm@romanrm.ru> wrote:
>> >> > On Sat, 29 Jan 2011 22:48:06 +0000
>> >> > Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>> >> >
>> >> >> Hi,
>> >> >>
>> >> >> I'm wondering if the performance I'm getting is OK or if there=
's
>> >> >> something I can do about it. Also, where the potential bottlen=
ecks
>> >> >> are.
>> >> >
>> >> > How are your disks plugged in? Which controller model(s), which=
 bus.
>> >> > But generally, on an Atom 1.6 Ghz those seem like good results.
>> >> >
>> >> > --
>> >> > With respect,
>> >> > Roman
>> >> >
>> >>
>> >>
>> >> Hi,
>> >>
>> >> Sorry, of course I should've included that. Here's the info:
>> >>
>> >> ~/bin $ sudo ./drivescan.sh
>> >> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>> >> =C2=A0 SATA controller: nVidia Corporation MCP79 AHCI Controller =
(rev b1)
>> >> =C2=A0 =C2=A0 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 103265055=
80009990027}
>> >> =C2=A0 =C2=A0 host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1=
022443}
>> >> =C2=A0 =C2=A0 host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20=
152590}
>> >> =C2=A0 =C2=A0 host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20=
188479}
>> >> =C2=A0 =C2=A0 host4: [Empty]
>> >> =C2=A0 =C2=A0 host5: [Empty]
>> >
>> >
>> > Hmm, it seems like you have 2 empty slots on the on-board =C2=A0SA=
TA
>> > controller. Try to move 2 of the disks from the other controller t=
o the
>> > on-board controller.
>> >
>> > And I would also avoid LVM. I think LVM affects striping.
>> >
>> > best regards
>> > Keld
>> >
>>
>> Sadly the 2 empty slots are not to be found on the motherboard, I
>> guess they're in the chipset only.
>
> maybe then use the 5th drive on the sata on-board controller in the
> raid5 - the sda drive. If the raid5 is where you want performance fro=
m.
>
> what do you use sda for? Your OS? It is a lot of space to use just fo=
r
> the OS. It could easily go into the raid5 too. And you culd use a rai=
d
> for the system too, to secure you from bad things happening to your
> system.
>
> Or you could have a few 5 to 10 GB partitions in the beginning of
> each drive, for experimenting with raid layout and performance.
> This should be outside any LVM to exclude LVM having an impact on
> the tests.
>
> Maybe your PCI-e cannot do more than 2.5 Gbit - then 2 of your disks
> would be enough to fill that connection. You could try out
> a raid0 on the 3 drives. If you cannot get more than about 300 MB/s, =
then
> the PCI-E is a bottleneck.
>
> If that is so, then having 3 drives from the PCI-E could slow down th=
e
> whole raid5, and using only 2 drives could speed up the full raid5.
>
> The on-board sata controller is normally much faster, having a direct
> connection to the southbridge - and typically a speed in the neighbou=
rhood of
> 20 Gbit - or 2500 MB/s - which would be enough for many systems to no=
t
> be the bottleneck. It can often pay off to have a motherboard with tw=
o
> on-board sata controllers with in total 8 SATA ports or more,
> instead of bying an extra PCI-E controller.
>
> Looking forward to hear what you find out.
>
> best regards
> keld
>

Ah, good point. The sda is a 60GB SSD, I should definitely move that
to the PCI-E card, as it doesn't do heavy IO (just small random r/w).
Then i can have 4 RAID HDDs on the onboard ctrl, and 2 on the PCI-E
shared with the SSD. If the SSD is idle then I should get ideal
throughputs.

Thanks to mdadm, and /dev/disks/by-label/ I should be fine with just
swapping the SATA cables around actually, without having to change any
configs. I'll try that later on and let you know if it affects
performance anything. Good catch!

I'm not prepared to mess around with partitions on the RAID drives, as
I have data on them I wish to keep.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
