From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 13:44:04 -0600
Message-ID: <4D45BF84.7030706@hardwarefreak.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>	<20110130035352.1d72e8d1@natsu>	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>	<20110130015231.GA1435@www2.open-std.org>	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>	<20110130055616.GA13022@www2.open-std.org> <AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mathias Bur=E9n put forth on 1/30/2011 6:12 AM:

> Thanks to mdadm, and /dev/disks/by-label/ I should be fine with just
> swapping the SATA cables around actually, without having to change an=
y
> configs. I'll try that later on and let you know if it affects
> performance anything. Good catch!

Be sure to change the mobo and PCIe card BIOS boot order after moving t=
he SSD
cable to the PCIe card or the machine won't boot.  Also, before swappin=
g cables,
make sure you have the PCIe card chipset driver built into your kernel =
or
properly built into your initrd image.  If not you still won't boot.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
