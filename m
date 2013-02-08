From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 17:25:42 +1100
Message-ID: <51149A66.6000308@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com> <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 11:02, Chris Murphy wrote:
>=20
> On Feb 7, 2013, at 4:48 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>>=20
>> ***On Feb 7, 2013, at 6:08 AM, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>>=20
>>> Basically, on occasion, when a user copies a large file from disk
>>> to disk,
>=20
>> Why did you reject NFS =85
>=20
> A sign of brain deficiency, responding to myself=85
>=20
> Maybe this is an array to array transfer (?) and not LV to LV
> transfer where both LVs are on this SSD array? If it's the latter,
> geez, use NFS. This transaction is reduced to a rename (i.e. a move).
> Super fast.
>=20
> Even if it's the former, with different block devices on the same
> server, I'm pretty sure NFSv4 can reduce this to a cp between
> devices, rather than piping the data all the way to the client, just
> to have the client pipe it back to the server. Although I'm sure
> someone will correct me if I'm wrong.

OK, so again, currently I have:
RAID5
DRBD
LVM2
iSCSI

On the remote machine...
iSCSI connects to server and presents block device /dev/sdX
Xen which passes through the block device to domU (Windows)
disk partition
partition is formatted NTFS


Now, alternatives to the above involving NFS I imagine are:
RAID5
DRBD
ext4 (or whatever filesystem format) to create a large file
NFS (export the large files to the xen physical machine

On the remote machine....
NFS mount
loop to present the NFS file as a block device
Xen which passes through the block device to domU (Windows)
disk partition
partition is formatted NTFS


LVM offers some advantages:
snapshots (disabled to try to improve performance, but in theory...)
easy to increase allocated space to a single VM
Keeps the entire system as simple block devices. There is only one
filesystem (NTFS), everything else is just block devices translated
through from layer to lower layer.

I'm not sure, but it was my understanding that using block devices was
the most efficient way to do this....

Potentially, if the block devices are mis-aligned in some way, I assume
this could result in some performance loss, but again I'm not sure it
should be this dramatic.

Any comments?

Thanks,
Adam

--=20
Adam Goryachev
Website Managers
www.websitemanagers.com.au
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
