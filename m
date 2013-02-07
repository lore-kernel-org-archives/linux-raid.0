From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid-5 initiated as raid-4?
Date: Thu, 7 Feb 2013 19:32:29 +0100 (CET)
Message-ID: <23526154.30.1360261949571.JavaMail.root@zimbra>
References: <23689346.18.1360259772196.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23689346.18.1360259772196.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> ok, so do I understand correctly that the initial raid-5 build only
> writes data/parity to a single drive (the 'replacement')? Doing some
> more testing now to see what I can find=E2=80=A6

Now, this is interesting. Initiating a raid-5 will create parity blocks=
 (and perhaps data blocks) for the other drives, growing it will recrea=
te parity for them all, which is normal. now, creating an empty raid-6 =
takes merely second, on the same (virtual) drive size (only more drives=
). What does the raid-6 code do that the raid-5 code could (or should?)=
 have done?

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
