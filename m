From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID performance - new kernel results
Date: Tue, 16 Apr 2013 21:28:47 +0200 (CEST)
Message-ID: <20372204.0.1366140527266.JavaMail.root@zimbra>
References: <516C6018.5030800@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516C6018.5030800@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

> > I suspect that the single ping packets being lost are an indication
> > of a
> > problem, but this should not impact the users (TCP should look afte=
r
> > the
> > re-transmission, etc). Wether this is related to the longer 10-50
> > second
> > outage I'm not sure.
>=20
> No, single lost pings are *not* a sign of a problem. It is perfectly
> normal for a network to have random traffic spikes that fill a
> switch's
> store-and-forward buffers. ICMP pings are *datagrams*, like UDP, so
> they aren't retransmitted when dropped. Losing them as infrequently a=
s
> you say suggests your network isn't heavily loaded.

Switches (unlike bridges) do not use store-and-forward. They use cut-th=
rough, meaning they use store-and-forward for the initial packet from A=
 to B and then store the path and switch it later, sniffing the MAC add=
resses and just use pass-through.

As was said, the traffic on the network was minimal, so I really doubt =
this had an impact. Getting 30 seconds+ of drops must come from a bad n=
etwork stack or a really bad switch, but then again, two switches were =
tested, so I doubt the switches alone could do that.

What may be doing it, is bad (or perhaps incompatible) bonding setup.

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
