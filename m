From: =?ISO-8859-1?Q?Tero_M=E4ntyvaara?= <termant@gmail.com>
Subject: Re: Removing physical disk from RAID & LVM
Date: Tue, 22 May 2012 05:12:46 +0300
Message-ID: <4FBAF61E.40002@gmail.com>
References: <4FB1E89F.5080407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB1E89F.5080407@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was going to remove the one permanently.


Tero

On 15.5.2012 8:24, Tero M=E4ntyvaara wrote:
> Hi,
>=20
> I have filesystem build up with 5 x 320 GB disks with identical=20
> partitions. Disks have 2 partitions and the first one is dedicated
> for RAID-1 (/dev/md0) and second one is dedicated for RAID-5
> (/dev/md1). The disk /dev/md0 is mounted as /boot and the /dev/md1
> is prepared for LVM. PE size is 32 MiB and there is 38035 PEs.
>=20
> I am going to remove one 320 GB disk and have already reduced the
> sizes of existing LV:s. 1) What is the sufficient free PE number
> before I can imagine shrinking of RAID-5 device? 2) How should I
> procede after having enough free PE:s?
>=20
>=20
> Tero
>=20
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org=20
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
