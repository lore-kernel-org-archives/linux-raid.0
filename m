From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 17:58:06 +0200 (CEST)
Message-ID: <6085629.18.1366387086623.JavaMail.root@zimbra>
References: <20130419174509.5892c4bd@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130419174509.5892c4bd@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

> On Wed, 17 Apr 2013 20:45:40 +0200
> Alexander Zvyagin <zvyagin.alexander@gmail.com> wrote:
>=20
> > I have almost working RAID50 (two RAID5 forms RAID0) in my
> > Linux-mint13. When booting the system always ends up in initramfs
> > shell, saying it cannot find the "root".
>=20
> Post a full dmesg of a failed boot-up;
>=20
> also try "rootdelay=3D10" kernel command line parameter.

Please see http://paste.ubuntu.com/5721934/ for the full list, taken wi=
th network console. This is with rootdelay=3D10
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
