From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 10:11:18 +0100
Message-ID: <4F508EB6.2030101@profihost.ag>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 02.03.2012 10:06, schrieb Lars T=C3=A4uber:
>> Correct that's why i've also tried to install it on sda / sdb but th=
en
>> grub complains about not finding any partition table.
>=20
> do you have a partition table inside the raid?
> This will not work I expect. The kernel might find the partition tabl=
e but
> grub?
>=20
> Or do you have no partition table at all and a filesystem directly on=
 the
> raid device?

No partition table on sda / sdb. Partition table is on md127. This
scenario works fine with metadata 0.9. And as far as i understand it
should work with 1.2 too.

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
