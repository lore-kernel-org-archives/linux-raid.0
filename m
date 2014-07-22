From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 12:12:48 -0600
Message-ID: <5610FF26-A3E8-4A2A-A1BE-099696D6874C@colorremedies.com>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net> <53CE7E70.2000800@turmel.org> <53CE89E1.10109@tesco.net> <7EA5355B-DE4B-4EEA-9592-8056FA9A7B7C@colorremedies.com> <53CEA1DE.2040405@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CEA1DE.2040405@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jul 22, 2014, at 11:39 AM, Phil Turmel <philip@turmel.org> wrote:

> Hi Chris,
>=20
> On 07/22/2014 12:57 PM, Chris Murphy wrote:
>>=20
>> On Jul 22, 2014, at 9:57 AM, Ron Leach <ronleach@tesco.net> wrote:
>>>=20
>>> D5s2:/# ./lsdrv
>> [snip]
>>> =E2=94=82 =E2=94=9Csda7 37.25g [8:7] MD raid1 (2) inactive {5bad4c7=
c:780696f4:e201a2f5:7bba85d7}
>> [snip]
>>> =E2=94=9Csdb7 37.25g [8:23] MD raid1 (2) inactive {5bad4c7c:780696f=
4:e201a2f5:7bba85d7}
>>=20
>>=20
>> They are in the lsdrv listing, but the raid is not activated. The pr=
oblem is a RAID UUID mismatch between mdadm.conf and libblkid (I'm assu=
ming the tree lsdrv is generating ultimately comes from libblkid, I cou=
ld be wrong.)
>=20
> lsdrv calls out to udev's "vol_id" utility if present, otherwise call=
s
> out to "blkid" in "probe" mode.  So yes, libblkid.
>=20
>> 5bad4c7c:780696f4:fbaacbb9:204d67b9 ## mdadm.conf
>> 5bad4c7c:780696f4:e201a2f5:7bba85d7 ## libblkid
>>=20
>> Therefore it's not being assembled.
>=20
> Good catch.  UUIDs make my eyes cross.
>=20
> In this case, since the initramfs is auto-assembling everything, its
> getting a high minor number instead of the desired minor number.
>=20
> Ron, while md126 is assembled, you should get a report from blkid for
> that filesystem.  Then your fstab can pick it up by UUID instead of
> device name.

Right. Once the raid is active, libblkid will become aware of the files=
ystem/volume UUID, and it's that UUID to put in fstab. So two different=
 UUIDs: raid goes in mdadm.conf, and volume goes in fstab.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
