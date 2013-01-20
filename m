From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Automatically adding spares on boot
Date: Sun, 20 Jan 2013 13:21:42 +0100 (CET)
Message-ID: <33203141.4.1358684502114.JavaMail.root@zimbra>
References: <50FBDC6F.80304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FBDC6F.80304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> On 01/20/2013 12:51 PM, Roy Sigurd Karlsbakk wrote:
> >> Hope this clarifies. You don't need this script if your OS always
> >> finds
> >> your spares and adds them automatically to your arrays. Mine
> >> doesn't.
> >
> > Really, if md 'forgets' a spare on reboot, that's a bug and should
> > be reported.
>=20
> http://www.google.com/#hl=3Den&q=3Dmdadm+does+not+add+spares+on+boot
>=20
> First hit.

That's rather old=E2=80=A6
=20
> root@zotac:~# lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description: Ubuntu 11.10
> Release: 11.10
> Codename: oneiric

That's rather old too, and soon out of support. Better upgrade to 12.04=
 LTS and try again.

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
