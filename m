From: Pedro Teixeira <finas@aeiou.pt>
Subject: Raid10 multi core scaling
Date: Tue, 26 Nov 2013 10:58:59 +0000
Message-ID: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=C2=A0=C2=A0 I created a Raid10 array with 16 sata 1TB disks and the ar=
ray
performance
seems to be limited by the md0_raid10 taking 99% of one core and not
scalling to other cores. I tried overclocing the cpu cores and this lea=
d to
a small increase in performance ( but md0_raid10 keeps eating 99% of on=
e
core ).

=C2=A0 =C2=A0I'm using:
=C2=A0 =C2=A0=C2=A0- a phenom X6 at 3600mhz
=C2=A0 =C2=A0=C2=A0- 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cach=
e )
=C2=A0 =C2=A0=C2=A0- 4x marvell 9230 sata3 controllers ( 4 ports each )=
 pcie 2.0 2x
lanes.
=C2=A0 =C2=A0=C2=A0- 8GB ram
=C2=A0 =C2=A0=C2=A0- custom 3.12 kernel and mdadm compiled from latest =
source

=C2=A0 =C2=A0what I did to test performance was to force a check on the=
 array, and
this
leads to mdadm reporting a speed of about 990000K/sec. The hard disks
report a 54% utilization. ( Overclocking the cpu by 200mhz increases th=
e
resync speed a bit and the hdd's utilizartion to about 58% )

=C2=A0 =C2=A0If I do the same with a raid5 array instead of raid10, the=
m resync
speed
will be almost double of raid10, the harddisk utilization reported will=
 be
98-100% and I can see at least two cores being used.

_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
