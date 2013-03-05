From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Kernel 3.7.9 RAID6 hot replace success
Date: Tue, 5 Mar 2013 19:34:15 +0100 (CET)
Message-ID: <30532376.12.1362508455226.JavaMail.root@zimbra>
References: <51355015.7080301@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51355015.7080301@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Add spare to array
> echo want_replacement > /sys/block/md0/md/dev-sdm/state
> Wait 6 hours
> Remove failed drive
> Job done.
>=20
> Last time I tried this (lots of kernel versions ago) I had all sorts
> of
> issues with removing the failed drive and other sticky stuff that
> required rebooting to clean up. This "just worked".

This is great. Any idea when that came in?

Btw, with as many as 10 drives in a RAID-6, I'd keep at least one spare=
 permanently there=E2=80=A6

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
