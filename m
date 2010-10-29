From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm / RAID, a few questions
Date: Sat, 30 Oct 2010 07:44:08 +1100
Message-ID: <20101030074408.05392452@notabene>
References: <AANLkTi=QRfQhNy5jDdtq2FsjENZk-ihNas=D4QrS2XMd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=QRfQhNy5jDdtq2FsjENZk-ihNas=D4QrS2XMd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Oct 2010 15:18:09 +0100
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> Question 3: Before I created this RAID5 array I did a quick RAID0 tes=
t
> array just for fun, using 2 full devices (not partitions). Now I have
> this:
>=20
> mdadm  --examine --verbose --scan
> ARRAY /dev/md/raid0-test level=3Draid0 metadata=3D1.2 num-devices=3D2
> UUID=3Db84cc081:1ae27b49:d5ae466c:377ba300 name=3Dion:raid0-test
>    devices=3D/dev/sdf,/dev/sdb
> ARRAY /dev/md/0 level=3Draid5 metadata=3D1.2 num-devices=3D6
> UUID=3De6595c64:b3ae90b3:f01133ac:3f402d20 name=3Dion:0
>    devices=3D/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/s=
db1
>=20
> Is it safe to erase the raid0-test superblocks on device /dev/sdb and
> /dev/sdc or will it interfere with my RAID5 array (which is lying on
> top of partitions) ?

It should be safe to
  mdadm --zero-superblock /dev/sdf /dev/sdb

As you have 1.2 metadata, that info will be 4K from the start of the de=
vice.
Depending on how you partitioned the devices, that is either in dead sp=
ace
between the partition table and the first partition, or it is in dead s=
pace
in the first partition just before the md metadata.

So the old metadata is still visible, creating the new arrays clearly d=
idn't
over-write it, so they don't really care what is there...

That statement isn't 100% general. A block in the data area of the new =
array
could be unchanged by creating an array, yet changing it could still co=
rrupt
parity.  However you can be certain that the metadata for a whole-devic=
e
array does not lie in the data area for a partitioned array of the same
metadata type.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
