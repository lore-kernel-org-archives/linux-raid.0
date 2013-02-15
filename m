From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID10 layout question
Date: Fri, 15 Feb 2013 19:58:10 +0100 (CET)
Message-ID: <29203573.10.1360954690174.JavaMail.root@zimbra>
References: <A1B82B87-68E8-4E6A-BF67-B1DCD85FE376@tenshu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A1B82B87-68E8-4E6A-BF67-B1DCD85FE376@tenshu.net>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Jones <cmsj@tenshu.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 2) Will I take a performance hit if I manually make two RAID1 sets an=
d
> then a RAID0 of them?

I'd rather use separate mirrors (raid1) and use lvm on top of that - be=
tter flexibility.

> 3) Should I forget about the layout and just use RAID6?

Depends what you need. RAID-6 will give you lower IOPS, but better sequ=
encial I/O. It will also stand *any* two drives failing, while striped =
mirrors (raid-10 or raid-1 with raid-0/lvm on top) will only tolerate a=
 single drive failing per mirror. The chances of two drives failing at =
the same time is low, but it's rather common to see a single drive fail=
ing and then seeing bad data on another drive. If not scterc (smartctl =
etc) is enabled, or the timeout (/sys/block/$dev/device/timeout) hasn't=
 been increased, a single bad sector may make md kick out a drive, whic=
h would be bad if it's rebuilding a mirror. Personally, I use RAID-6 - =
it's safe and fast enough for my needs.

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
