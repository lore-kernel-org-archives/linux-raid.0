From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 19:27:44 +0100 (CET)
Message-ID: <33445160.30.1360866464484.JavaMail.root@zimbra>
References: <CAH3kUhFbR3coJSwPvqqOGrqcsvoJpdAPgAAiAgc_th1ym33DzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFbR3coJSwPvqqOGrqcsvoJpdAPgAAiAgc_th1ym33DzA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> why not brtfs or xfs?

Well, because btrfs isn't stable and doesn't support RAID-[56] unless y=
ou're using the git tree for testing that, which is rather more unstabl=
e than the rest, and xfs is just a filesystem that needs to sit on top =
of a raid of some kind.

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
