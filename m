From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Sun, 16 Sep 2012 09:26:17 -0600
Message-ID: <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk> <5055AD0A.60704@linuxsystems.it>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5055AD0A.60704@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 16, 2012, at 4:42 AM, Niccol=F2 Belli wrote:

> Il 15/09/2012 21:41, Robin Hill ha scritto:
>> Writing zeros is certainly what I'd do in this situation - I've done=
 it
>> for several drives in the past where they've had offline uncorrectab=
le
>> sectors flagged.
>=20
> I just tried to write zeros, it didn't help: the disk doesn't realloc=
ate the bad sector :(

Something isn't right. How did you write zeros?

I went through the archives and wasn't able to find the full smartctl -=
x results for this drive, can you post them?

Does anyone know for sure if the ATA Secure Erase command verifies its =
writes? i.e. does it even have a way of knowing if there are bad sector=
s on a write and remove them from use? Or is the write-read verificatio=
n always occurring on hard drives?

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
