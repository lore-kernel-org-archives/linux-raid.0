From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 12 Jan 2013 13:06:19 +0100 (CET)
Message-ID: <2258826.8.1357992379424.JavaMail.root@zimbra>
References: <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Unlikely to make up the difference is the scheduler. Parallel fs's
> like XFS don't perform nearly as well with CFQ, so you should have a
> kernel parameter elevator=3Dnoop.

uh=E2=80=A6 how can the filesystem chosen be relevant to the disk eleva=
tor? CFQ will try to optimize access to reduce seeks and should be comp=
letely independent on the filesystem used on top. Also, if you really w=
ant to disable CFQ (which you shouldn't do on rotating rust, IMO), bett=
er use deadline (which is default on newer kernels).

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
