From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Best practice for large storage?
Date: Fri, 15 Feb 2013 00:23:13 +0100 (CET)
Message-ID: <29597293.40.1360884193537.JavaMail.root@zimbra>
References: <CAH3kUhGVt1iyn9tt=2-+f6H++obOGSK3x0pBBPZV8CFUXjp5yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhGVt1iyn9tt=2-+f6H++obOGSK3x0pBBPZV8CFUXjp5yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

xfs+lvm+mdadm works, but I'm still back to my original question. I don'=
t care about what filesystem is on top, only about the storage undernea=
th. Read the original question again, please

----- Opprinnelig melding -----=20



xfs+lvm+mdadm don`t work? too complex?=20



2013/2/14 Roy Sigurd Karlsbakk < roy@karlsbakk.net >=20


----- Opprinnelig melding -----=20

> why not brtfs or xfs?=20

Well, because btrfs isn't stable and doesn't support RAID-[56] unless y=
ou're using the git tree for testing that, which is rather more unstabl=
e than the rest, and xfs is just a filesystem that needs to sit on top =
of a raid of some kind.=20



Vennlige hilsener / Best regards=20

roy=20
--=20
Roy Sigurd Karlsbakk=20
(+47) 98013356=20
roy@karlsbakk.net=20
http://blogg.karlsbakk.net/=20
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt=20
--=20
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.=20




--=20
Roberto Spadim=20


--=20

Vennlige hilsener / Best regards=20

roy=20
--=20
Roy Sigurd Karlsbakk=20
(+47) 98013356=20
roy@karlsbakk.net=20
http://blogg.karlsbakk.net/=20
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt=20
--=20
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
