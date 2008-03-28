From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Reopen: 16 HDDs too much for RAID6?
Date: Fri, 28 Mar 2008 10:20:02 +0100
Message-ID: <20080328102002.a8b836b6.taeuber@bbaw.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de>
	<20080306094559.GA29734@skl-net.de>
	<20080306115559.63ac361d.taeuber@bbaw.de>
	<20080306161621.GD32242@skl-net.de>
	<20080307084146.GA9653@percy.comedia.it>
	<20080307114555.6ce17158.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080307114555.6ce17158.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo!

Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:
> I zeroed out all physical devices completely:
> # for DEV in /dev/sd[c-r]; do dd if=3D/dev/zero of=3D$DEV; done
>=20
> Now the problem is gone. I don't know what really caused the problem.
> Many thanks for your suggestions.

The problem has occured again.
I'm not sure what the cause was, but the duplicated superblock is there=
 again. But the raid fell apart before. So I suspect this occurs only a=
fter the array was degraded.
The discs are not defective so I tried to reassemble the array with the=
 original discs again:
monosan:~ # mdadm -A /dev/md4
mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar supe=
rblocks.
      If they are really different, please --zero the superblock on one
      If they are the same or overlap, please remove one from the
      DEVICE list in mdadm.conf.

How can I extract the superblocks to check if they are really identical=
ly?

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
