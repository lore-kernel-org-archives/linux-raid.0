From: Phil Turmel <philip@turmel.org>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 13:39:42 -0400
Message-ID: <53CEA1DE.2040405@turmel.org>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net> <53CE7E70.2000800@turmel.org> <53CE89E1.10109@tesco.net> <7EA5355B-DE4B-4EEA-9592-8056FA9A7B7C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7EA5355B-DE4B-4EEA-9592-8056FA9A7B7C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Chris,

On 07/22/2014 12:57 PM, Chris Murphy wrote:
>=20
> On Jul 22, 2014, at 9:57 AM, Ron Leach <ronleach@tesco.net> wrote:
>>
>> D5s2:/# ./lsdrv
> [snip]
>> =E2=94=82 =E2=94=9Csda7 37.25g [8:7] MD raid1 (2) inactive {5bad4c7c=
:780696f4:e201a2f5:7bba85d7}
> [snip]
>>  =E2=94=9Csdb7 37.25g [8:23] MD raid1 (2) inactive {5bad4c7c:780696f=
4:e201a2f5:7bba85d7}
>=20
>=20
> They are in the lsdrv listing, but the raid is not activated. The pro=
blem is a RAID UUID mismatch between mdadm.conf and libblkid (I'm assum=
ing the tree lsdrv is generating ultimately comes from libblkid, I coul=
d be wrong.)

lsdrv calls out to udev's "vol_id" utility if present, otherwise calls
out to "blkid" in "probe" mode.  So yes, libblkid.

> 5bad4c7c:780696f4:fbaacbb9:204d67b9 ## mdadm.conf
> 5bad4c7c:780696f4:e201a2f5:7bba85d7 ## libblkid
>=20
> Therefore it's not being assembled.

Good catch.  UUIDs make my eyes cross.

In this case, since the initramfs is auto-assembling everything, its
getting a high minor number instead of the desired minor number.

Ron, while md126 is assembled, you should get a report from blkid for
that filesystem.  Then your fstab can pick it up by UUID instead of
device name.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
