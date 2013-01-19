From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sat, 19 Jan 2013 14:21:59 +0100 (CET)
Message-ID: <20597456.6.1358601718986.JavaMail.root@zimbra>
References: <50F9D32F.7090606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F9D32F.7090606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

> >> The probability of a URE during rebuild increases with the number
> >> and
> >> size of the source drives being read to rebuild the failed drive.
> >> Thus
> >> the probability of encountering a URE in the 1:1 drive scenario is
> >> extremely low, close to zero if you believe manufacturer specs.
> >
> > For a 2TB drive and BER 10^-14 (common for non-enterprise drives),
> > the
> > probability is 1/6 of a single URE for a read of the entire drive.
>=20
> If my math is correct, with a URE rate of 10E14, that's one URE for
> every ~12.5TB read. So theoretically one would have to read the entir=
e
> 2TB drive more than 6 times before hitting the first URE. So it seems
> unlikely that one would hit a URE during a mirror rebuild with such a
> 2TB drive.

ok, perhaps, maybe, but then it's 17% chance of losing data after a mir=
ror or raid-5 rebuild with 2TB drives, or the double of that if using 4=
TB drives. That's not very amusing=E2=80=A6

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
