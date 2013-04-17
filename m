From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 19:27:18 +0200 (CEST)
Message-ID: <32292886.12.1366219638178.JavaMail.root@zimbra>
References: <516DABF2.5050409@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DABF2.5050409@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I personally don't even trust RAID 6. All our servers use three-disk
> RAID 1 setups, with disks from at least two different manufacturers t=
o
> prevent against firmware bricking (although this is becoming more and
> more difficult as the industry consolidates).

You can *never* trust RAID alone. Even with ZFS, you can have problems =
taking down a whole pool, even with RAIDz3 and ZFS' checksumming. A pow=
er surge can take down half (or even all) the drives in the array, and =
even with three-way mirrors, the chances are good your pool will die.

So, choose something decent, like RAID-6 (RAIDz2) or mirrors, three-way=
 if you're paranoid, and keep a good backup, preferably offsite and on =
tape. Tapes in a tape library can't be damaged much of a power surge (e=
xcept perhaps those in the reader).

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
