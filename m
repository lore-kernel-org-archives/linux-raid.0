From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: auto-assembling arrays without a configuration file
Date: Sat, 8 Mar 2008 11:49:07 +0100
Message-ID: <20080308104907.GA16373@rap.rap.dk>
References: <20080308004009.GA32251@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080308004009.GA32251@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 08, 2008 at 01:40:09AM +0100, Keld J=F8rn Simonsen wrote:
> I want to assemble the root partition automatically, without having=20
> a configuration file. Is that possible?=20
>=20
> mdadm -A --scan=20
>=20
> does seem to require a configuration file.
>=20
> On the other hand, I think all info needed is available in the super
> blocks, and a traversal of the partitions present on the system (ala
> fdisk -l) could give consistent naming - there seems to be no /dev/md
> association available in the superblock.

I tried=20

mdadm -A --scan  --config partitions

But it did not work, error message something like raid array not found.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
