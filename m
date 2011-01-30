From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 14:03:06 -0600
Message-ID: <4D45C3FA.2040900@hardwarefreak.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>	<20110130094444.68288b0e@natsu>	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>	<20110130171533.4c9e236b@natsu> <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mathias Bur=E9n put forth on 1/30/2011 1:41 PM:

> Thanks. New results up for those interested:
> http://stuff.dyndns.org/logs/bonnie_results.html

Three things I notice:

1.  You're CPU bound across the board, for all the tests that matter an=
yway
2.  Because of this, your performance spread is less than 5% across the=
 board
    meaning any optimizations are useless
3.  Is that a 7 Gigabyte chunk size?  That's totally unrealistic.  It s=
hould be
    less than 1 MB for almost all workloads.

According to those numbers, you can swap SATA controllers and PCIe bus =
slot
assignments all day long, but you'll gain nothing without a faster CPU.

Why are you using a 7 Gigabyte chunk size?  And if the other OP was cor=
rect
about the 768MB stripe cache, that's totally unrealistic as well.  And =
in real
world use, you don't want a high readahead setting.  It just wastes buf=
fer cache
memory for no gain (except maybe in some synthetic benchmarks).

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
