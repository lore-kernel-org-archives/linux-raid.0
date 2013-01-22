From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Chances of silent errors?
Date: Tue, 22 Jan 2013 11:55:38 +0100 (CET)
Message-ID: <24463267.2.1358852138003.JavaMail.root@zimbra>
References: <28222077.12.1358798287217.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28222077.12.1358798287217.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Coming from the zfs world, I've heard a few talk about the chances of
> "silent errors", meaning the checksum on the drives match, but the
> data being bad because of matching checksum (aka collisions). Does
> anyone in here know the relative chance of something like that
> happening with the checksums of current harddisks? Is the 1:10^14 or
> 1:10^15 chances for a URE in regard to this, or is that when the driv=
e
> reports an error, or those two combined?

A follow-up here. I see drive manufacturers report the chance of an URE=
 is 1:10^14 for desktop drives, 1:10^15 for 7k2RPM enterprise drives an=
d 1:10^16 for 10k and 15k enterprise drives (or most do). I was under t=
he impression that "nearline"  / 7k2 enterprise drives were the same th=
ing as desktop drives, only with a slightly different firmware (TLER an=
d friends =3D> don't do anything as stupid as going into "deep recovery=
 mode" like some desktop drives do).

Any idea if there's a real difference between the hardware on enterpris=
e and desktop 7k2 drives? Is this 10-fold difference between error rate=
s real, or is it just marketing?

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
