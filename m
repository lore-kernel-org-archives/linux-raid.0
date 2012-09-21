From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Fri, 21 Sep 2012 13:35:24 -0600
Message-ID: <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361158.MkTZ6QR6cp@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 21, 2012, at 5:42 AM, G=FCnther J. Niederwimmer wrote:

>=20
> I have=20
> mdadm-3.2.5-3.7.1

If you're making the RAID with that, it defaults to metadata version 1.=
2. But to be sure
mdadm -E /dev/mdX


> parted 2.4.-24.2.2
>=20
> on the computer.
>=20
>> Could be a bug in parted 2.3, which is old. Try using parted 3.0.
>=20
> I will search ;)

Or track down gdisk (a.k.a. GPT fdisk), which I prefer to parted anyway=
=2E


> my question is,  win can work with no Problem on the "Fakeraid" and a=
 GPT=20
> Table. Could it be, that the kernel or / and parted have a Problem wi=
th the=20
> GPT Table on a Raid1 or a Raid10 Fakeraid ?

Just because Windows works with fakeraid doesn't mean it's a linux kern=
el problem. It's clearly not finding the secondary partition header whe=
re the primary one says it should be. So something is moving it, or ste=
pping on it.

What linux distribution and version are you using? The fact you've got =
an older parted makes me wonder if the distribution predates the fix fo=
r dmraid and GPT, which is to use kpartx for activating partitions.

https://bugs.launchpad.net/ubuntu/+bug/777056

Another possibility is that Windows 7 is moving it, and is perfectly OK=
 with the move, but then that breaks everything else.
http://ubuntuforums.org/showpost.php?p=3D10449114&postcount=3D12



Chris

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
