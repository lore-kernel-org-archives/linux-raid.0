From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: new bottleneck section in wiki
Date: Wed, 02 Jul 2008 16:55:37 -0500
Message-ID: <486BF959.9050202@gmail.com>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com> <20080702182627.GA12614@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702182627.GA12614@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Wed, Jul 02, 2008 at 01:08:04PM -0500, David Lethe wrote:
>>
>> And also the disk controllers, could these be bottlenecks? They typi=
cally
>> operate at 300 MB/s nominally, per disk channel, and presumably they
>> then have a connection to the southbridge that is capable of handlin=
g
>> this speed. So for a 4-disk SATA-II controller this would be at leas=
t
>> 1200 MB/s or about 10 gigabit.=20
>>
>> best regards
>> keld
>> -------------------
>> It is much more complicated than just saying what the transfer rates=
 are, especially in the world of blocking, arbitration, and unbalanced =
I/O. =20
>=20
> Yes, that is understood, but I am only listing some potential
> bottlenecs, of cause there may be more.
>=20
>> Everything is a potential bottleneck.  As I am under NDA with most o=
f the controller vendors, then I can not provide specifics, but suffice=
 to say that certain cards with certain chipsets will max out at well u=
nder published speeds.  Heck, you could attach solid-state disks with r=
andom I/O access time in the nanosecond range and still only get 150MB/=
sec out of certain controllers, even on a PCIe X 16 bus.=20
>>
>> BTW, there isn't a SATA-II controller in the planet that will delive=
r 1200 MB/sec with 4 disk drives.=20
>=20
> Yes, but I think this is normally due to that the max transfer speed =
per
> disk is in the ballpark of 80-120 MB/s - which is less than half the
> SATA-II max speed. And I think much of this slowdown comes from head =
movement,
> track-to-track, disk latency etc. I was of the impression, that when =
the
> transfer between the disk and the controller is going on, then the
> transfer speed would be not far from the 300 MB/s max speed, eg for
> 90 MB/s 1 TB disks that I bougth recently, or the faster 15000 RPM
> disks, which give something like 120 MB/s.

Actually enough sectors are only passing under the head at that 70-120M=
B/second=20
rate, so when you add in the seeks and such things are a bit lower, but=
 you=20
aren't ever going to be able to exceed that given bit rate, and the bit=
 rate=20
changes from the inside of the disk to the outside of the disk (the out=
side has=20
more sectors on it than the inside), in the disk data sheet's there is =
usually a=20
range of bit rates listed showing this.

                             Roger

                                 Roger
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
