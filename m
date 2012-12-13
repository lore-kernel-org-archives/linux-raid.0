From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Degraded Raid6
Date: Thu, 13 Dec 2012 19:51:06 +0100 (CET)
Message-ID: <15214561.24.1355424666351.JavaMail.root@zimbra>
References: <20121212204907.248080@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121212204907.248080@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Waage <berndman1980@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I run an 8-disk raid 6 on which sporadically 2 drives dropped out,
> that I could just re-add when I zeroed the zuperblock beforehand.
> Recently, upon re-adding those 2 drives (after the zero-superblock) a
> third drive dropped out after 5-10 minutes of syncing. I then did a
> zero-superblock on the third drive and tried to re-add it - which
> failed.
=2E..
> 10 8 113 - spare /dev/sdh1
> 11 8 1 - spare /dev/sda1
> 12 8 65 - spare /dev/sde1

If you had two drives failing, why didn't you let these spares take ove=
r the job?

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
