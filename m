From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Thu, 7 Mar 2013 11:02:39 +0100 (CET)
Message-ID: <18656028.2.1362650559146.JavaMail.root@zimbra>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It appears the Raid 5/10 discard support does not work in the mainlin=
e
> kernel.
>=20
> I've been trying to backport it to a RHEL 6 kernel without success. I
> finally managed to setup a mainline dev box and discovered it doesn't
> work on it either!
>=20
> I'm now testing on a stock 3.8.2 kernel. The drives I'm using are
> Samsung 840 Pro's hanging off an LSI 9211-8i. No backplane and each
> drive has a dedicated channel. No RAID on the LSI, its just an HBA.

I'm not sure if TRIM/UNMAP is supported on that controller, even in HBA=
 mode (and with IT firmware). I've also seen scterc fail to work on tha=
t controller as well, while working with an ordinary "stupid" controlle=
r on the same disk.

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
