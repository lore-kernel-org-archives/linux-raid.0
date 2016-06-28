From: Hannes Reinecke <hare@suse.de>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 28 Jun 2016 08:33:43 +0200
Message-ID: <57721A47.8070203@suse.de>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/27/2016 06:42 PM, Chris Murphy wrote:
> Hi,
>=20
> Drives with SCT ERC not supported or unset, result in potentially lon=
g
> error recoveries for marginal or bad sectors: upwards of 180 second
> recovers are suggested.
>=20
> The kernel's SCSI command timer default of 30 seconds, i.e.
>=20
> cat /sys/block/<dev>/device/timeout
>=20
> conspires to  undermine the deep recovery of most drives now on the
> market. This by default misconfiguration results in problems list
> regulars are very well aware of. It affects all raid configurations,
> and even affects the non-RAID single drive use case. And it does so i=
n
> a way that doesn't happen on either Windows or macOS. Basically it is
> linux kernel induced data loss, the drive very possibly could present
> the requested data upon deep recovery being permitted, but the
> kernel's command timer is reached before recovery completes, and
> obliterates any possibility of recovering that data. By default.
>=20
> This now seems to affect the majority of use cases. At one time 30
> seconds might have been sane for a world with drives that had less
> than 30 second recoveries for bad sectors. But that's no longer the
> case.
>=20
'Majority of use cases'.
Hardly. I'm not aware of any issues here.

The problem with SCT ERC (or TLER or whatever the currrent acronym of
the day is called) is that it's a non-standard setting, where every
vendor basically does its own thing.
Plus you can only influence this on higher end-disks; on others you are
at the mercy of the drive firmware, hoping you got the timeout right.

Can you post a message log detailing this problem?
We surely have ways of influencing the timeout, but first we need to
understand what actually is happening.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
