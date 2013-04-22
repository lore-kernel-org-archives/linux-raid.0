From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Mon, 22 Apr 2013 13:02:51 +0200 (CEST)
Message-ID: <20944014.4.1366628571053.JavaMail.root@zimbra>
References: <20130422081015.206aed16@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422081015.206aed16@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

> > Please see http://paste.ubuntu.com/5721934/ for the full list, take=
n
> > with network console. This is with rootdelay=3D10
>=20
> The "bind" messages are in random order so presumably udev running
> 'mdadm -I'
> on each device as it appear to add it to an array.
> However when the md0 and md1 devices appear, udev isn't being run on
> that.
> So it looks like your udev rules file is wrong.
> Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention
> mdadm and
> post them.

/lib/udev/rules.d/64-md-raid.rules is here http://paste.ubuntu.com/5592=
227/
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
