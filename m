From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 12:51:56 +0200 (CEST)
Message-ID: <26874571.8.1366368716107.JavaMail.root@zimbra>
References: <CAGA4a+FucP9SG5NDc079gD06G0vgS_PK3eCiiL2Lvx3sMC1U_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+FucP9SG5NDc079gD06G0vgS_PK3eCiiL2Lvx3sMC1U_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: Alexander Zvyagin <zvyagin.alexander@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> The thing is that in order for this to work you need to have the
> stripe scanned after the two 5s are created, I seem to recall that if
> you put the stripe last in your mdadm.conf it will come up after the
> 5s

I just tried to change the order in mdadm.conf, update-initramfs -u, re=
boot, same thing. md9 doesn't come up until a manual -A --scan

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
