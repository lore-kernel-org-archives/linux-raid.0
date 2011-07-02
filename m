From: "Cal Leeming [Simplicity Media Ltd]"
	<cal.leeming@simplicitymedialtd.co.uk>
Subject: Curious problem with asynchronous RAID1 rebuild operations
Date: Sat, 2 Jul 2011 12:07:54 +0100
Message-ID: <CALvtuFQ_c_-8DqKGaTV6LjL0JXC=8VKPKyx5U1Be49fepLcWzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I tried to rebuild/sync two RAID1 arrays at the same time, with strange=
 results.

When a new drive was added into md0, it started to sync fine at
123,000kb/sec. Whilst that was running, I also added a new drive into
md1, and this causes both arrays sync speed to slow down to
20,000kb/sec. I checked the=A0/proc/sys/dev/raid/speed_limit_{min|max}
and these were both set fine.

I removed the drive from md1, and the md0 sync went back to the normal =
speed.

RAID Setup:
md0 - 2 drives (2TB Western Digital)
md1 - 2 drives (500GB M3 SDD)

So my question is, does anyone know why the sync speed (on all arrays)
slowed down to almost 6-7 times the norm, when two (or more?) sync
operations are taking place?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
