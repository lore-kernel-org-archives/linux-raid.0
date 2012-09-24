From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 14:18:27 -0600
Message-ID: <C21D75CB-9991-4FE2-8B9C-DD7F53AE60F1@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <4838005.Z2kBBljtsi@techz> <2F14DB42-E5C0-43F1-9EE6-CA4859F39756@colorremedies.com> <3192749.CyYuocktFM@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3192749.CyYuocktFM@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 24, 2012, at 1:06 PM, G=FCnther J. Niederwimmer wrote:
>=20
> Disk /dev/sda: 320.1 GB, 320072933376 bytes
> 256 K=F6pfe, 63 Sektoren/Spur, 38761 Zylinder, zusammen 625142448 Sek=
toren
> Einheiten =3D Sektoren von 1 =D7 512 =3D 512 Bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>=20
>   Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id  System
> /dev/sda1               1  4294967295  2147483647+  ee  GPT

Well that's screwy. But at least the PMBR is protecting all sectors (an=
d quite a bit more that don't exist) of this disk.

Last time we checked, the array state was dirty. Is that still the case=
? Report the results from these two:

mdadm -D /dev/md126

mdadm -Ds


Chris Murphy


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
