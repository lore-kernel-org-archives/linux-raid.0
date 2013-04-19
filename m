From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 12:45:32 +0200 (CEST)
Message-ID: <22897457.6.1366368332298.JavaMail.root@zimbra>
References: <16868321.4.1366367759598.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16868321.4.1366367759598.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Zvyagin <zvyagin.alexander@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> # If using nested MD, such as RAID5+0, another scan is needed
> mdadm --assemble --scan

Btw, that probably won't be enough for you, since fstab etc is parsed b=
efore rc.local is run. I tried to fix it with doing

# If using nested MD, such as RAID5+0, another scan is needed
mdadm --assemble --scan
mount /testraid

=E2=80=A6but for some reason the filesystem doesn't get mounted...

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
