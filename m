From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Best practice for large storage?
Date: Thu, 14 Feb 2013 18:28:46 +0100 (CET)
Message-ID: <24358517.18.1360862926919.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

It seems we may need some storage for video soon. This is a 20k studen =
college in Norway, with rather a few on media related studies. Since th=
ese students produce rather large amounts of raw material, typically to=
 be stored during the semester, we may need some 50-100TiB, perhaps mor=
e. I have setup systems with these amounts of storage earlier on ZFS, b=
ut may be using Linux MD for this project. I'm aware of the lack of che=
cksumming, snapshots etc with Linux, but may be using it because of mor=
e Linux knowledge amongst the sysadmins here. In such a setup, I guess =
nearline SAS drives on a SAS expander will be used, and with the amount=
 of storage needed, I won't be using a single RAID-6 (too insecure) or =
RAID-10 (too expensive) for the lot. In ZFS-land I used smallish VDEVs =
(~10 drives each) in a large pool.

 - Would using LVM on top of RAID-6 give me something similar?
 - If so, should I stripe the RAID sets, and again, if striping them, w=
ill it be as easy to add new RAID sets as we run out of space?

Thanks, and best regards

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
