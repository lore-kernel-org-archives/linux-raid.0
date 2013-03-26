From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Tue, 26 Mar 2013 21:37:27 +0100 (CET)
Message-ID: <26589278.14.1364330247753.JavaMail.root@zimbra>
References: <51520563.6010700@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51520563.6010700@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 3/26/2013 2:21 PM, Roy Sigurd Karlsbakk wrote:
> > If you have 2x4TB and you want to setup the lot for booting and
> > data, I'd recommend doing like the NAS boxes I've seen (well, only
> > QNAP 410 IIRC). On that one, they chose to create partitions for /
> > and swap (and perhaps /boot), and equal-ish partitions for those
> > used for data. On those, you can place a RAID-10, or perhaps two
> > RAID-1s and use LVM to stripe them. The latter is far more flexible=
,
> > as RAID-10 lacks most of the flexibility other RAID leverls have.

> I have 4 x 2TB, actually.

Erm, that's what I meant. I just wouldn't recommend using RAID-10, sinc=
e it isn't very flexible. LVM on top of multiple mirrors is better.

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
