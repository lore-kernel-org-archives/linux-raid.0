From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: filesystem on mdadm raid from unpartioned block devices
Date: Wed, 12 Jan 2011 20:37:23 -0200
Message-ID: <AANLkTik0V_c_+xjMgn6-qYbUd7o2C5w6csJ8UgLU5B7S@mail.gmail.com>
References: <1294871497.16201.9.camel@TRAVLOR>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1294871497.16201.9.camel@TRAVLOR>
Sender: linux-raid-owner@vger.kernel.org
To: GarBoge <garboge@shaw.ca>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

i think that mkfs.ext4 is 4096 default block size
-b 4096 is the option for device block size


2011/1/12 GarBoge <garboge@shaw.ca>:
> A quick question that I haven't been able to find and answer for.
>
> I have been using whole block devices (whole unpartitioned hard drive=
s)
> in various raid 1 and 5 setups using mdadm 3.1.4 with pretty mundane
> options (default options such as striping and but using metadata 1.2)=
=2E
> Typically I use mkfs.ext4 with no options (default) to install the
> filesystem.
>
> Is there an issue with alignment on the newer 4096-byte drives. If so
> what would be the proper approach?
>
> I thank you for your time.
>
> Ashley
>
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
