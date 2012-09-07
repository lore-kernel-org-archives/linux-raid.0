From: Phil Turmel <philip@turmel.org>
Subject: Re: Howto avoid full re-sync
Date: Fri, 07 Sep 2012 08:41:27 -0400
Message-ID: <5049EB77.8070006@turmel.org>
References: <50497AE6.2010005@websitemanagers.com.au> <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFsZiBNw7xsbGVy?= <ralf@bj-ig.de>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Adam,

On 09/07/2012 05:41 AM, Ralf M=C3=BCller wrote:
>=20
> Am 07.09.2012 um 06:41 schrieb Adam Goryachev:
>=20
>> I have a MD raid6 with 5 drives, and every now and then one (random)
>> drive will fail. I've done all sorts of checks, and the drive is
>> actually working fine, so I suspect an issue with the Linux driver
>> and/or SATA controller (onboard).

In years on this list, most cases of "drive fails out of raid, but
checks out OK" has been a side effect of the mismatch between default
linux controller timeouts (in the drivers) and error recovery timeouts
in non-enterprise drives.

Really.  Search for "scterc" in the list archives.

A few solutions:
1)  Buy enterprise drives that have short timeouts by default.
2)  Buy desktop drives that support SCTERC, and use scripts to set it
every time they are plugged in or booted up.
3)  Change the driver timeouts.

>> It isn't really relevant to the question, but I'll run through the s=
ata
>> stuff, in case anyone can point out a simple solution to stop this f=
rom
>> happening (yes, a new server is on the way, but with budgets etc, th=
at
>> could be some time away. This issue has happened for years, but we a=
re
>> becoming more active with these failures now).

If the new server has enterprise drives, it'll all just work.  And
you'll have some physical reliability advantages, too.  My needs haven'=
t
justified the extra expense, though, so I do #2.  At the moment, only
Hitachi is supporting SCTERC in desktop models.

>> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controlle=
r
>> (rev a1)
>> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controlle=
r
>> (rev a1)
>> 01:07.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA =
SATA
>> HostRAID Controller (rev 02)
>>
>> cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md2 : active raid6 sdh1[5] sdg1[4] sdf1[0] sdd1[6](F) sde1[2] sda1[1=
]
>>      5860535808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U]
>>      [>....................]  recovery =3D  1.4% (28663240/195351193=
6)
>> finish=3D486.5min speed=3D65938K/sec
>>
>>
>>
>> Since I know sdh is actually almost up to date, is there some way to
>> re-add it, and only have to sync the portions of the disk which have
>> changed?
>=20
>=20
> Besides all the stuff about fix your server, a raid is not a backup a=
nd you risk your data - simply add a write intent bitmap:
>=20
> # mdadm /dev/md2 --grow bitmap=3Dinternal

Definitely add the bitmap.  But that's a band-aid.  If you have a
timeout mismatch, the odds of total failure of your raid6 array is very
high, even with perfectly good disks.  Most desktop drives quote one
unrecoverable read error per 1e14 bits read.  That's only 12TB.  Every
four complete passes through a 3T drive, or taken together, one pass
through four 3T drives.  Hmmm.  Precisely what happens rebuilding a
five-drive raid5 or raid6.

HTH,

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
