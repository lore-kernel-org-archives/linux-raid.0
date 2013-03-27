From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: cpu stuck when raid5 was in recovery
Date: Wed, 27 Mar 2013 16:54:51 +0100 (CET)
Message-ID: <7692174.18.1364399691145.JavaMail.root@zimbra>
References: <201303271543006872113@meganovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201303271543006872113@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: hanguozhong <hanguozhong@meganovo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> Hello, everyone:
> I Created a 16*2T raid5 array yesterday just for test, the kernel
> 2.6.38 was used.
> And when the array was in recovery, there were lots of "kernel bugs"
> outputs of dmesg.

first of all - 16 drives in a single RAID-5 is like BASE-jumping with a=
 small umbrella, but for test - hey - go on.

But then - any errors from the drives in there?

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
