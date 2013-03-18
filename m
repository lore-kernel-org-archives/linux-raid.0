From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have
 failed.
Date: Mon, 18 Mar 2013 18:31:09 +0100 (CET)
Message-ID: <32480862.0.1363627869379.JavaMail.root@zimbra>
References: <20130318104905.4a70bc00@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130318104905.4a70bc00@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

> > Are other people seeing this, or is this an artifact of the way I a=
m
> > killing devices ('echo offline > /sys/block/$dev/device/state')?
>=20
> That is a perfectly good way to kill a device.

Anyone that knows what may have replaced this in 3.8, or if this isn't =
available for virtio devices? I have a vm on 3.8 (ubuntu raring alpha/b=
eta/something), and I find no such file there. Works great on the host =
OS, though (ubuntu precise, linux 3.2).

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
