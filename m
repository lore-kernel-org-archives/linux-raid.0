From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Expanding array with multiple devices
Date: Sat, 2 Mar 2013 15:07:15 +0100 (CET)
Message-ID: <1801783.8.1362233235807.JavaMail.root@zimbra>
References: <512FBDA3.7080501@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512FBDA3.7080501@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> While expanding an existing raid is as simple as mdadm --add, followe=
d
> by an mdadm --grow, How would you go about this when expanding it wit=
h
> multiple devices.

Given a RAID-5 on /dev/sd[bcde], I'd do

# mdadm --add /dev/md0 /dev/sd[fghi]
# mdadm --grow --level=3D6 --raid-devices=3D8

No need to create a new RAID and then move the data.

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
