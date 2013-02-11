From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 20:49:12 +0100 (CET)
Message-ID: <31549980.18.1360612152269.JavaMail.root@zimbra>
References: <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: linux-raid@vger.kernel.org, Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

> Why would you plug thousands of dollars of SSD into an onboard
> controller? It's probably running off a 1x PCIE shared with every
> other onboard device. An LSI 8x 8 port HBA will run you a few
> hundred(less than 1 SSD) and let you melt your northbridge. At least
> on my Supermicro X8DTL boards I had to add active cooling to it or it
> would overheat and crash at sustained IO. I can hit 2 - 2.5GB a secon=
d
> doing large sequential IO with Samsung 840 Pros on a RAID10.

Those onboard controllers are usually connect to 8x PCIe or similar. Al=
so, those controllers from LSI won't allow TRIM support, which may come=
 in handy=E2=80=A6

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
