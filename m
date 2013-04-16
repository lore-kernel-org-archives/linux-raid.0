From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Use RAID-6!
Date: Tue, 16 Apr 2013 18:44:31 +0200 (CEST)
Message-ID: <15345091.8.1366130671716.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

After reading this list for some time, there's a single mode of failure=
 that's repeated over and over: RAID-5 loses a drive and finds bad data=
 on another (or just loses another). This is rather normal, far more th=
an documented by the disk vendors. This is also the case with "professi=
onal" systems with "enterprise" drives.

So, if you can afford another drive, please use RAID-6. Do *not* trust =
RAID-5 with something like 8 drives.

Also, maybe this should be on an FAQ/RAID tutorial somewhere?

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
