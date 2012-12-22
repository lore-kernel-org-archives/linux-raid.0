From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Disk speed comparison
Date: Sat, 22 Dec 2012 18:39:51 +0100 (CET)
Message-ID: <27374116.4.1356197991689.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

I have an array with 6 2TB drives plus a spare. While this works well, =
I can from the munin graphs at http://munin.karlsbakk.net/munin/karlsba=
kk.net/smilla.karlsbakk.net/index.html that the WD2001FASS drives (sd[b=
cfg]) perform some 30% better than the  Hitachi HDS723020BLA642 drives =
(sd[eh]). The drives are on a mixed set of controllers, so this shouldn=
't be relevant. Since they all are specified to spin on 7200RPM, I find=
 it wierd that the performance difference shown by the Munin graph is s=
o big.

Anyone seen something similar?

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
