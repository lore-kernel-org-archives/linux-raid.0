From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Reopen: 16 HDDs too much for RAID6?
Date: Fri, 28 Mar 2008 11:14:40 +0100
Message-ID: <200803281114.41018.bs@q-leap.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de> <20080307114555.6ce17158.taeuber@bbaw.de> <20080328102002.a8b836b6.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080328102002.a8b836b6.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?utf-8?q?T=C3=A4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo Lars,

On Friday 28 March 2008 10:20:02 Lars T=C3=A4uber wrote:
> Hallo!
>
> Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:
> > I zeroed out all physical devices completely:
> > # for DEV in /dev/sd[c-r]; do dd if=3D/dev/zero of=3D$DEV; done

why not simply "mdadm --zero-superblock $DEV"?

> >
> > Now the problem is gone. I don't know what really caused the proble=
m.
> > Many thanks for your suggestions.
>
> The problem has occured again.
> I'm not sure what the cause was, but the duplicated superblock is the=
re
> again. But the raid fell apart before. So I suspect this occurs only =
after
> the array was degraded. The discs are not defective so I tried to
> reassemble the array with the original discs again: monosan:~ # mdadm=
 -A
> /dev/md4
> mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar
> superblocks. If they are really different, please --zero the superblo=
ck on
> one If they are the same or overlap, please remove one from the
>       DEVICE list in mdadm.conf.
>
> How can I extract the superblocks to check if they are really identic=
ally?


mdadm --examine /dev/dm-9
mdadm --examine /dev/dm-8

Do you have some kind of multipathing, which really could cause a ident=
ical=20
superblocks on dm-9 and dm-8? Did you specify dm-9 and dm-8 in you=20
mdadm.conf / assemble script or the real human readable lvm / multipath=
=20
names?


Cheers,
Bernd


--=20
Bernd Schubert
Q-Leap Networks GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
