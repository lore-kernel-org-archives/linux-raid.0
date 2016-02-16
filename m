From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when
 stopping
Date: Tue, 16 Feb 2016 16:47:06 +0100
Message-ID: <56C3447A.3050504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Sebastian,

while it's true in general that a 'change' event should not be sent
when a device is being removed or deleted, sending a 'remove' event
from userspace is most definitely wrong, too.
'remove' events should be generated from the kernel whenever a
device disappears from sysfs; it should never be generated from
userspace (as the device will still be present in sysfs).

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
