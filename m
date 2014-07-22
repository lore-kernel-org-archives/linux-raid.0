From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 10:57:43 -0600
Message-ID: <7EA5355B-DE4B-4EEA-9592-8056FA9A7B7C@colorremedies.com>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net> <53CE7E70.2000800@turmel.org> <53CE89E1.10109@tesco.net>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE89E1.10109@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jul 22, 2014, at 9:57 AM, Ron Leach <ronleach@tesco.net> wrote:
>=20
> D5s2:/# ./lsdrv
[snip]
> =E2=94=82 =E2=94=9Csda7 37.25g [8:7] MD raid1 (2) inactive {5bad4c7c:=
780696f4:e201a2f5:7bba85d7}
[snip]
>  =E2=94=9Csdb7 37.25g [8:23] MD raid1 (2) inactive {5bad4c7c:780696f4=
:e201a2f5:7bba85d7}


They are in the lsdrv listing, but the raid is not activated. The probl=
em is a RAID UUID mismatch between mdadm.conf and libblkid (I'm assumin=
g the tree lsdrv is generating ultimately comes from libblkid, I could =
be wrong.)

5bad4c7c:780696f4:fbaacbb9:204d67b9 ## mdadm.conf
5bad4c7c:780696f4:e201a2f5:7bba85d7 ## libblkid

Therefore it's not being assembled.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
