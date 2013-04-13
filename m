From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sat, 13 Apr 2013 16:19:08 +0200 (CEST)
Message-ID: <2615557.4.1365862748221.JavaMail.root@zimbra>
References: <516869D2.9030506@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516869D2.9030506@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have a RAID5 with 8 disks. It worked fine.

It's a thead a week or so about people who run lots of drives in RAID-5=
 and lose a drive, and then anothoer during rebuild, or in other ways h=
ave double disk failure. With eight drives in a single RAID-8 and no go=
od backup, it's like asking for trouble. Use RAID-6.

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
