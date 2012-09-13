From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Thu, 13 Sep 2012 12:46:42 +0200
Message-ID: <5051B992.7030200@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 13/09/2012 12:34, Robin Hill ha scritto:
> Has anything actually attempted to read from that part of the array?
> Even if so, it may just have happened to read from the working disk
> anyway. md can only detect the error when it tries to read/write that
> sector of that disk.

I forced a read with "dd if=3D/dev/md0 of=3D/dev/null bs=3D524228 count=
=3D1=20
skip=3D1", I even get errors in syslog!

> Your best bet now is to do an array check:
>      echo check>  /sys/block/md0/md/sync_action
>
> This will force a read of all disks in the array. This should trigger
> the read error, causing an attempt to re-write the faulty block, in t=
urn
> causing the drive remap the bad sector (assuming the re-write fails).
> This should also be scheduled to run regularly for all arrays in orde=
r
> to pick up these sort of issues before they cause major problems duri=
ng
> a rebuild.

/etc/init.d/mdadm should do exactly this kind of things (distro is=20
Debian Squeeze). I have this in cron.d:
57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d)=
=20
-le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; =
fi

Unfortunately it seems it didn't work :(

Shouldn't a dd if=3D/dev/md0 be enough to trigger the read error?

Thanks,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
