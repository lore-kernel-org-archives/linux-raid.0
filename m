From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Fri, 15 Mar 2013 12:07:47 +0100 (CET)
Message-ID: <32050581.8.1363345666963.JavaMail.root@zimbra>
References: <20130315041054.79eb5dcc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130315041054.79eb5dcc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What happened was:
> - a device (sdg1) was added as a write-mostly member to a degraded
> two-member RAID1 (md3) and started recovering;

May I be so frank as to guessing you found an old drive and added as wr=
ite-mostly? sdg is the bad drive here=E2=80=A6

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
