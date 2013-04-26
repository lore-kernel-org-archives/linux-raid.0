From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Fri, 26 Apr 2013 21:10:12 +0200 (CEST)
Message-ID: <5359373.10.1367003412336.JavaMail.root@zimbra>
References: <20130425094417.4882607e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130425094417.4882607e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>, Dmitrijs Ledkovs <xnox@debian.org>
List-Id: linux-raid.ids

> My current thinking is that the initramfs should *only* assemble
> arrays needed
> to mount the root filesystems. All other arrays should wait for root
> to be
> mounted so that real /etc/mdadm.conf (or /etc/mdadm/mdadm.conf) can b=
e
> consulted.
> This can be achieved by putting
> auto -all
> in mdadm.conf on the initramfs, then listing the arrays that are
> needed.
>=20
> I'm not convinced that your boot-degraded option is a bad thing.
> Certainly
> it should be optional so unattended boot is possible, and we should d=
o
> our
> best to minimise the number of times that it is consulted. But there
> are
> times when it is better to know that something is wrong, than to
> proceed and
> do the wrong thing.
>=20
> A particularly bad case is a RAID1 pair where one device failed a few
> days
> ago.
> If after a reboot the good device is missing (cable problem?) and the
> bad
> device is visible, it could be best not to boot rather than to boot
> with an
> old root based on the old 'failed' device.


Anyone that knows more about this issue and how to fix it? I've filed a=
 bug, but haven't gotten any more feedback

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
