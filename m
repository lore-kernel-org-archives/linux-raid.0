From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: SSSE6 / RAID6
Date: Tue, 22 May 2012 15:18:20 -0700
Message-ID: <4FBC10AC.3000803@zytor.com>
References: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/22/2012 02:27 PM, Mathias Bur=C3=A9n wrote:
> Hi list,
>=20
> I just compiled 3.4 for my little Atom box. Is there any way I can
> confirm if the RAID6 check is using SSSE6 instructions?
>=20

It should be printed in the boot log (/var/log/dmesg or similar.)

	-hpa


--=20
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
