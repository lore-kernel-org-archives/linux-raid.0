From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Sun, 16 Sep 2012 18:00:30 -0600
Message-ID: <EE6B2D2D-D200-4B42-B8FF-3FEF14ABD667@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk> <5055AD0A.60704@linuxsystems.it> <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com> <5055F0CF.6000908@linuxsystems.it> <50566243.1080907@linuxsystems.it>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50566243.1080907@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 16, 2012, at 5:35 PM, Niccol=F2 Belli wrote:
>=20
> then I read this on the smartmontools mailing list:
>=20
> <<
> Possibly what is happening is that because he is only writing a parti=
al
> block, the OS is first trying to read the the original block so that =
it
> can preserve the parts that won't be changing. When this operation fa=
ils,
> it blocks the write that would trigger reallocation of the bad sector=
=2E
> Writing using the OS blocksize (typically 4096 on linux systems) prop=
erly
> aligned should work around that issue.
> >>
>=20
> so I tried with
>=20
> dd if=3D/dev/zero of=3D/dev/sda bs=3D4096
>=20
> and ta-daaa!

Useful info. Obviously Secure Erasing a disk takes a while and is overk=
ill for just one sector. But I'm still curious if anyone knows if for s=
ure ATA Secure Erase will remove bad sectors from use.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
