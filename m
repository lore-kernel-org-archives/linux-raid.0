From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: RAID-5 & RAID-0 lower read performance using  ADMA + HW XOR engine
Date: Mon, 21 Jul 2008 17:24:31 -0700 (PDT)
Message-ID: <841573.81999.qm@web81305.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recently I ported ADMA=A0 interface to of of=A0our AMCC powerPC chips. =
Which has High Speed DMA and HW XOR acceleration. I am using high speed=
 DMA to do memcopy in RAID-0 . In RAID-5 I am using DMA + HW XOR engine=
=2E I am using IO-meter to test the performance.
=A0
=A0
=A0
RAID-0: (page size 64k, File System Block size 64k)
=A0
=A0=A0 READ: 27MBps
=A0=A0 Write: 68MBps=20
=A0
RAID-5: (Page size 64K and File system Block size 64k)
=A0=A0=A0 READ: 28MBps
=A0=A0=A0 WRITE: 50MBps
=A0
=A0
I see there is lot of IO wait time. Any suggestions how to reduce IO wa=
it time ? For sure there is no HW acceleration on Read path.
=A0
Thanks in advance,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
