From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Tue, 16 Aug 2011 21:15:49 -0700
Message-ID: <4E4B4075.2060400@gmail.com>
References: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Iwan Zarembo <iwan@zarembo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/16/11 13:19, Iwan Zarembo wrote:
> I also wanted to reuse my four old SAMSUNG HD103UJ 1 TB hard drives.
> In the past I used mdadm as fake raid level 5 and everything worked
> just fine. Now with the upgrade I wanted to use the Intel RAID
> Controller on my mainboard. The advantage is that I would be able to
> access the raid drive from my alternative windows system.

(snip)
>=20
> I learned that md126 is so long read only until it was used the first
> time. So I tried to create a partition with the documentation from th=
e
> wiki, but not with ext3. I used ext4 for this.
>=20
>  #  mkfs.ext4 -v -m .1 -b 4096 -E stride=3D32,stripe-width=3D64 /dev/=
md/raid
> The result was:
> mke2fs 1.41.14 (22-Dec-2010)
> fs_types f=C3=BCr mke2fs.conf L=C3=B6sung: 'ext4'
> /dev/md/raid: The operation is not allowed then creating Superblocks.
> Original message in German: Die Operation ist nicht erlaubt beim
> Erstellen des Superblocks
>=20

Are ext4 partitions even accessible in Windows? I remember trying that
myself and not finding a solution.

My comment in the previous message about creating the filesystem on the
raid directly is probably not a good idea in this case, Windows probabl=
y
won't like that. You'd have to create a partition.

Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
