From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Thu, 18 Apr 2013 16:18:38 +0200 (CEST)
Message-ID: <31706911.18.1366294718929.JavaMail.root@zimbra>
References: <516FF25B.4000907@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516FF25B.4000907@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org, Oliver Schinagl <oliver+list@schinagl.nl>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> To re-summarize (for full info, see first post of thread):
> * There are 2 RAID5 arrays in the machine, each have 8 disks.

Once more: 8 drives in RAID-5 isn't very safe. The chances are rather h=
igh to get a double disk failure with that amount of drives in R5.

See the list for examples.

Just my 2c

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
