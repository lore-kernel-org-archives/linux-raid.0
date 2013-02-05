From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: 3TB drives failure rate (summary)
Date: Tue, 5 Feb 2013 19:08:25 +0100 (CET)
Message-ID: <27438597.16.1360087705797.JavaMail.root@zimbra>
References: <511144A7.4050208@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511144A7.4050208@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: =?utf-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

> I'm using some SSD's in a RAID, but smartctl -l scterc /dev/sdX says
> it
> doesn't support it.
>=20
> Do SSD's not support it because it is not relevant (ie, either the
> data
> is there or not, we always know immediately, never any "retry" or
> whatever?)
>=20
> Or, should I be concerned about this?

My C300s support SCTERC, defaulting to 4 seconds timeout. How the SSD a=
ctually handles errors, is probably implementation specific.

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
