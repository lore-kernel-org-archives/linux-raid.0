From: Michael Sallaway <michael@sallaway.com>
Subject: Re: status of sas1068 ata-passthrough bug?
Date: Wed, 03 Nov 2010 13:39:57 +1000
Message-ID: <4CD0D98D.3010503@sallaway.com>
References: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>	<20101102220517.41416adb.ctpm@ist.utl.pt>	<AANLkTi=m0QSBq=W0KoZiSo_5hdbi31z9ipV2z6s5C2=T@mail.gmail.com> <20101103032049.3a731d19.ctpm@ist.utl.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101103032049.3a731d19.ctpm@ist.utl.pt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 3/11/2010 1:20 PM, Cl=C3=A1udio Martins wrote:
>   I would guess that Ubuntu might have some 2.6.35 kernel with this f=
ix
> backported, but I'm just speculating.

I can confirm that it does -- I was running 10.04 (which has 2.6.32 as=20
standard), and had problems with my 1068E card. I manually installed th=
e=20
linux-image-2.6.35-21-server package for some other fixes to the RAID6=20
error handling, and found that the 1068E card started working fine when=
=20
I put it back in.

> Also, as a last resort, you could try to apply the patch and rebuild
> using the sources of your favorite distro kernel. The patch is quite
> simple, but be warned that the MPTSAS module also got some other
> potentially interesting fixes on the 2.6.36 cycle.

Interesting.... where might I find out more info about that? (trying to=
=20
figure out if I should stay with .35 for now....)

Cheers,
Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
