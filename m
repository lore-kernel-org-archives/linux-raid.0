From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: strange performance of raid0
Date: Mon, 16 Feb 2004 00:58:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040215235834.GA21806@rap.rap.dk>
References: <20040215100432.GA19002@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040215100432.GA19002@rap.rap.dk>
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 15, 2004 at 11:04:32AM +0100, Keld J=F8rn Simonsen wrote:
> Hi
>=20
> I have some strange performance results on a raid0
> I have 4 IDE disks on two controllers, the one on the=20
> motherboard of the duron 1 GHz mackine, the other a promise TX2 plus=20
> SATA + PATA controller. I run kernel 2.4.22
>=20
> The disks and hdparm -t on each of them
>=20
> /dev/hdc1 seagate 80 GB                   16 MB/s
> /dev/sda1 maxtor sata 200 GB              50 MB/s
> /dev/sdb7 maxtor 160 GB                   54 MB/s

Changed my hdc1 disk with my hda1 disk, a seagate 40 GB
disk running at something like 40 GB/s.

On a cat Mandrake...iso >/dev/null  681 MB, I now got 102 MB/s
on the raid0. I am happy.

Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
