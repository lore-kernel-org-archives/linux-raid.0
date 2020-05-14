From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid6check extremely slow ?
Date: Thu, 14 May 2020 19:20:24 +0200 (CEST)
Message-ID: <1999694976.3317399.1589476824607.JavaMail.zimbra@karlsbakk.net>
References: <20200510120725.20947240E1A@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200510120725.20947240E1A@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I'm running raid6check on a 12 TB (8 x 2 TB harddisks)
> RAID6 array and wonder why it is so extremely slow...
> It seems to be reading the disks only a about 400 kB/s,
> which results in an estimated time of some 57 days!!!
> to complete checking the array.  The system is basically idle, there
> is neither any significant CPU load nor any other I/o (no to the
> tested array, nor to any other storage on this system).
>=20
> Am I doing something wrong?

Try checking with iostat -x to see if one disk is performing worse than the=
 other ones. This sometimes happens and can indicate a failure that the nor=
mal SMART/smartctl stuff can't identify. If you see a utilisation of one of=
 the disks at 100%, that's the bastard. Under normal circumstances, you pro=
bably won't be able to return that, since it "works". There's a quick fix f=
or that, though. Just unplug the disk, plug it into a power cable, let it s=
pin up and then sharpy twist it 90 degees a few times, and it's all sorted =
out and you can return it ;)

Vennlig hilsen

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.
