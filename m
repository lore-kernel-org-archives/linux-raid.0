From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Automatically adding spares on boot
Date: Sun, 20 Jan 2013 12:51:42 +0100 (CET)
Message-ID: <27071535.2.1358682702567.JavaMail.root@zimbra>
References: <50FAE8CB.50802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FAE8CB.50802@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hope this clarifies. You don't need this script if your OS always
> finds
> your spares and adds them automatically to your arrays. Mine doesn't.

Really, if md 'forgets' a spare on reboot, that's a bug and should be r=
eported. This is how my raid looks

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [r=
aid1] [raid10]=20
md0 : active raid6 sdg[5] sdh[6](S) sdc[7] sdb[0] sde[3] sdf[4] sdd[8]
      7814051840 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/6]=
 [UUUUUU]
     =20
unused devices: <none>

What distro/version is this?

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
