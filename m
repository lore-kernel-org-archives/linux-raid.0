From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: md: badblocks(pid 1216) used obsolete MD ioctl
Date: Mon, 1 Jul 2002 13:43:07 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNACEANDBAA.kc130iseo@coastalnet.com>
References: <5.1.0.14.2.20020701103744.035bf760@mail.harddata.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020701103744.035bf760@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Maurice Hilarius [mailto:maurice@harddata.com]
> Sent: Monday, July 01, 2002 10:41 AM
> To: cwebster@ec.rr.com
> Subject: Re: md: badblocks(pid 1216) used obsolete MD ioctl
>

Thank you for the feedback Maurice.

> You have SCSI bus problems. Likely related to termination.
> 1) check if you have active, powered termination, of the correct type. A
> U160 term will generally work, even with lower SCSI variants, as long as
> they are LVD of some type.

Forgive me, but I don't believe this is a SCSI bus problem. If the problem
moved around or I got different errors each time, I might suspect the bus.
As it is, the same sector on the same drive is called out each time. These
drives are mounted in an external SCSI drive enclosure which is terminated
with the appropriate active termination at the opposite end of the bus from
the connection to the host computer.

> 2) Check if the devices are jumpered to provide termination power to the
> SCSI bus. Make it so if possible, on ALL devices.

All the new drives are Seagate Barracuda ST318438LW. Unless I am mistaken,
they are ready to install in their factory default configuration.
Termination power is supplied by the bus for the external active terminator.
None of the nine drives should be terminated or jumpered to supply
termination power.

> 3) If this an Adaptec controller, go into it's BIOS (CTRL-A on startup
> message) If set to "auto" on termination, over-ride set to actual
> configuration, manually.

Please note that this is an UltraSparc IIi, not in Intel box. It does not
load a separate SCSI BIOS on startup the way Intel machines do.

> Maybe a bad drive?

That's my point. At most, I'm willing to concede that there is a bad sector,
(32772736 as reported in the system log). Even so, e2fsck should be able to
"mark" these "bad blocks", adding them to the list for the device. Once
marked, these blocks will not be written to again.


--Cal Webster

