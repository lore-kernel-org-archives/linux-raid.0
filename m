From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Mixing 512 bytes and 4K sector harddrives in a raid1?
Date: Mon, 7 Feb 2011 13:07:39 -0200
Message-ID: <AANLkTimpk+N6GuQXBRYU7teKiL_Chp8gn+uRLt_HoT-p@mail.gmail.com>
References: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Olsson <henrik@fixme.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

speed problem =3D) (i tested eeheheh)
i was talking about it in this list
i don=B4t know yet what the internal raid1 sector size (i think it=B4s =
the
chuck size defined on mdadm --create, but i=B4m not sure)
if you use 4k ssd you can see read/write when making <4kb read on ssd,
if it's a hd no problem, ssd will degrade max ssd speed with wrong
sector size (read/write not aligned)
i'm waiting the chunck size answer if you want wait the list to answer.=
=2E.

2011/2/7 Henrik Olsson <henrik@fixme.se>:
> Hi,
>
> One of the drives in my raid1 recently crashed and it looks like all
> the replacement disks (2TB) i can find use 4K sectors, but the old
> ones were 512 bytes.
> Are there any issues with having a raid1 array with different sector
> sizes for the drives?
>
> Regards,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
