From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Tue, 16 Aug 2011 21:08:32 -0700
Message-ID: <4E4B3EC0.8070800@gmail.com>
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
> Hello Everyone,
> I am not that new to Linux, but I am quite far away from being an
> expert :) I am using linux for a few years now and everything worked
> just fine, but not this one with IMSM Raid. I googled for some weeks
> and asked everyone I know about the problem but without any luck. The
> last possibility to find a solution is this mailing list. I realy hop=
e
> someone can help me.
>=20

I've just gone through this myself.

(snip)

>=20
> I started the raid by entering the command:
>     # mdadm -I -e imsm /dev/md127
>     mdadm: Started /dev/md/raid with 4 devices
>=20
> Now mdstat has the following output:
>     # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md126 : active (read-only) raid5 sdd[3] sdc[2] sdb[1] sde[0]
>       2930280448 blocks super external:/md127/0 level 5, 128k chunk,
> algorithm 0 [4/4] [UUUU]
>       	resync=3DPENDING
>=20
> md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
>       9028 blocks super external:imsm
>=20
> unused devices: <none>
>=20

What you are seeing here is the imsm container (/dev/md127), which you
generally don't use unless you are trying to reconfigure arrays.

The other device (/dev/md126) is the actual raid5 array as defined in
the imsm BIOS. This is what you use in disk operations. Examples:

$ parted /dev/md126

Then create partitions on the device - you'll have to use something
compatible with gpt tables. When you do this, you'll have new devices
available to you, such as /dev/md126p1 (first partition), /dev/md126p2
(second partition), and so on.

However, if all you're doing is creating one big partition, you don't
necessarily need a partition table, you can create a filesystem right o=
n
the array itself (/dev/md126) as I did on my server.

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
> This is the first problem. I am not able to do anything on the raid d=
rive.
>=20

Try using:

`mkfs.ext4 -v -m .1 -b 4096 -E stride=3D32,stripe-width=3D64 /dev/md126=
`

This, of course, assumes you aren't using a partition table. Substitute
the correct partition device should you create one.

> The second problem is that the raid is gone after the reboot!

I'm not familiar with ubuntu, but you likely need to add a service to
the startup scripts in order to start the raid array and have it usable=
,
assuming that this is not the root device and is just being used for
storage. It may need kernel arguments to tell mdadm to find and assembl=
e
arrays. Hopefully someone with Ubuntu experience can answer this.

I know on my distribution (not Ubuntu!) I have to add a service to the
boot runlevel in order to assemble arrays that are not the root filesys=
tem.

Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
