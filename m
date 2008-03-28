From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: Reopen: 16 HDDs too much for RAID6?
Date: Fri, 28 Mar 2008 11:27:00 +0100
Message-ID: <20080328112700.5d5dd662.taeuber@bbaw.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de>
	<20080307114555.6ce17158.taeuber@bbaw.de>
	<20080328102002.a8b836b6.taeuber@bbaw.de>
	<200803281114.41018.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200803281114.41018.bs@q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo Bernd,

Bernd Schubert <bs@q-leap.de> schrieb:
> Hallo Lars,
>=20
> On Friday 28 March 2008 10:20:02 Lars T=C3=A4uber wrote:
> > Hallo!
> >
> > Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:
> > > I zeroed out all physical devices completely:
> > > # for DEV in /dev/sd[c-r]; do dd if=3D/dev/zero of=3D$DEV; done
>=20
> why not simply "mdadm --zero-superblock $DEV"?

I just wanted to make clear, that there couldn't be anything left anywh=
ere on the disk. I already learned about this option of mdadm.

=20
> > >
> > > Now the problem is gone. I don't know what really caused the prob=
lem.
> > > Many thanks for your suggestions.
> >
> > The problem has occured again.
> > I'm not sure what the cause was, but the duplicated superblock is t=
here
> > again. But the raid fell apart before. So I suspect this occurs onl=
y after
> > the array was degraded. The discs are not defective so I tried to
> > reassemble the array with the original discs again: monosan:~ # mda=
dm -A
> > /dev/md4
> > mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar
> > superblocks. If they are really different, please --zero the superb=
lock on
> > one If they are the same or overlap, please remove one from the
> >       DEVICE list in mdadm.conf.
> >
> > How can I extract the superblocks to check if they are really ident=
ically?
>=20
>=20
> mdadm --examine /dev/dm-9
> mdadm --examine /dev/dm-8

I just reassembled the array for another test. Next time I'll have a de=
eper look with this.


> Do you have some kind of multipathing, which really could cause a ide=
ntical=20
> superblocks on dm-9 and dm-8? Did you specify dm-9 and dm-8 in you=20
> mdadm.conf / assemble script or the real human readable lvm / multipa=
th=20
> names?

Here the conf file:
monosan:~ # cat /etc/mdadm.conf=20
DEVICE /dev/sd[ab][0-9] /dev/dm-*
ARRAY /dev/md2 level=3Draid1 UUID=3Dd9d31de2:e6dbd3c3:37c7ea09:882a64e5
ARRAY /dev/md3 level=3Draid1 num-devices=3D2 UUID=3Da8687183:a79e514c:c=
a492c4b:ffd4384f
ARRAY /dev/md4 level=3Draid6 num-devices=3D15 spares=3D1 UUID=3Dcfcbe07=
1:f6766d8f:0f1ffefa:892d09c3
ARRAY /dev/md9 level=3Draid1 num-devices=3D2 name=3D9 UUID=3Ddb687150:6=
14e76fd:28feefc0:b1aae572

All dm-* devices are really distinctive. I could post the /etc/multipat=
h.conf too if you want.

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
