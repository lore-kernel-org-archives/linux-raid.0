From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 19:46:46 +0000
Message-ID: <AANLkTinnc9V8bZWaF+8JEXgAzxUVieiaiH4Fad5FERjJ@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130015231.GA1435@www2.open-std.org>
	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
	<20110130055616.GA13022@www2.open-std.org>
	<AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
	<4D45BF84.7030706@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D45BF84.7030706@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 19:44, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Mathias Bur=C3=A9n put forth on 1/30/2011 6:12 AM:
>
>> Thanks to mdadm, and /dev/disks/by-label/ I should be fine with just
>> swapping the SATA cables around actually, without having to change a=
ny
>> configs. I'll try that later on and let you know if it affects
>> performance anything. Good catch!
>
> Be sure to change the mobo and PCIe card BIOS boot order after moving=
 the SSD
> cable to the PCIe card or the machine won't boot. =C2=A0Also, before =
swapping cables,
> make sure you have the PCIe card chipset driver built into your kerne=
l or
> properly built into your initrd image. =C2=A0If not you still won't b=
oot.
>
> --
> Stan
>

I forgot to mention it, but I already swapped the cables. I had to
change a few things (reinstall GRUB, change menu.lst) but otherwise I
was OK. Strange thing is that my mainboard doesn't seem to want to
boot off a drive that's connected to the Highpoint controller. Just
sits there. However, using GRUB from a USB stick enables me to just do
root (hd2,0), then chainload + and load the GRUB of the SSD. Not
elegant, but it works (for now). Will investigate more later...

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
