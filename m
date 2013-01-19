From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Automatically adding spares on boot
Date: Sat, 19 Jan 2013 19:27:58 +0100 (CET)
Message-ID: <27416855.12.1358620078446.JavaMail.root@zimbra>
References: <50EDA431.1090905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50EDA431.1090905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Over the years I've had various problems with the degree to which the
> adding of spares on boot is automatic. There have been times when thi=
s
> has just worked, and other times (such as now) where it only works
> very
> occasionally (or not at all). Google is full of stories like this.
>=20
> I have no clue why it's not working automatically, I just know that i=
t
> isn't.
>=20
> So I wrote a little script that automates this, and hooked it up to
> mdmon as an event handler.
>=20
> It can probably do with an elegance upgrade, but it works for me.

hm=E2=80=A6 I don't se the point, really. I have a RAID-6 with a spare,=
 and last time a drive died, the spare kicked in automatically. Why wou=
ld you add something at boot?
--=20
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
