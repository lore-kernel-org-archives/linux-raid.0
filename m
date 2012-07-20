From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Fri, 20 Jul 2012 06:35:33 -0400 (EDT)
Message-ID: <2bdff9a4-8da2-40d8-bd59-a2daaad95304@zmail15.collab.prod.int.phx2.redhat.com>
References: <CABYL=Tq0qfOtW-+XEaMzapCbAG2zW7Z91jn3ev1YSVQAk35jig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tq0qfOtW-+XEaMzapCbAG2zW7Z91jn3ev1YSVQAk35jig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> yeah, i think this data corruption could/should be implemented as
> badblocks...
> do you have a disk that read blocks with wrong data like you told?

All of them were replaced during the warranty period ... but it seems
I have a new candidate. I'll use it for my tests. I'll write specific
data there and then I'll be reading them with sufficient idle time
intervals until I get either a read error or corrupted data without
read errors.

> if yes, could you check if it have bad blocks? (via some software,
> since i don=C2=B4t know if linux kernel will report it as badblock on
> dmesg or something else)

I always check S.M.A.R.T. atributes and all of the drives reported
reallocated and pending sectors, while there were no uncorrectable
sectors reported in some cases. I remember, that one of the drives
stopped booting because of MBR corruption, but the sector was readable
with dd without problems. I could also clean it and created new
partition table with fdisk (but the SMART atributes didn't change
with the new write operation. That really looks like there was=20
a reallocation done prior to my checks even if reallocations should
be done only during the write operation and I'm sure there was
absolutely no need for writing to MBR. I suspect some of the drive
firmwares, that they do the reallocation transparently during
the idle state. Especially seagate drives with capacities around
200GB can be heard, that they're doing their own surface checks
when they're idle. Maybe that's intention of the manufacturers.
I could imagine they don't want people to claim for the drive
replacement and thus they're trying to cover the issues up.
I also believe, that the SMART attributes might be intentionally
misreported by the firmware. The drive's electronics might be=20
transparently doing a lot of internal stuff dependent on the current
drive's internal design, that can't be easily mapped to any of the
SMART attributes and thus not reported at all. You know, nobody
can make the manufacturers to follow the rules ... moreover, there
might be a design/firmware bug or something else preventing the drive
working correctly in some cases. I can imagine many different
scenarios since I was a hardware designer for almost 10 years
and writing a firmware for conceptually wrong hardware design
might be the worst nightmare you could ever imagine. And low-price
device designs are often cheated and full of workarounds.

Anyway ... I believe, that relying on (by nature) unreliable hardware
might be considered a conceptual issue of the current MD-RAID layer.


> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>=20

Regards,
Jaromir.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
