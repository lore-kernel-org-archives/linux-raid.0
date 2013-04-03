From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 21:56:46 +0200 (CEST)
Message-ID: <5992258.6.1365019006583.JavaMail.root@zimbra>
References: <515C2C3C.3020400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515C2C3C.3020400@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org, Peter Landmann <sfrazt@googlemail.com>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> On 4/3/2013 6:00 AM, Peter Landmann wrote:
>=20
> You didn't mention your stripe_cache_size value. It'll make a lot of
> difference. Make sure it's at least 4096. The default is 256.

Looks like Documentation/md.txt (on 3.8.5) says stripe_cache_size, stri=
p_cache_active and preread_bypass_threshold are only available for RAID=
-5. How can I tune RAID-6 like this?

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
