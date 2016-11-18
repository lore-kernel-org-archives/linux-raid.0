From: Glenn Enright <glenn.enright@gmail.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Fri, 18 Nov 2016 15:03:26 +1300
Message-ID: <CAN7jt20bDPmrm7rAGXnPzoNtfRYhcR3_k-gT=mouToRhN2svbA@mail.gmail.com>
References: <20161117035230.GG21587@bitfolk.com> <014d01d24129$7a9b2c20$6fd18460$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <014d01d24129$7a9b2c20$6fd18460$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Could the /usr/share/mdadm/mkconf script help? It can be used to print
out the running equivalent of mdadm.conf

It might be a good thing to use for comparisons, I use it a fair bit
in my scripting with good results.

Regards, Glenn

On 18 November 2016 at 12:22, Peter Sangas <pete@wnsdev.com> wrote:
> Andy, Your question as prompted me to think about the following:   I'm us=
ing Ubuntu 16 and have a running system with RAID1.   If I change the hostn=
ame of the system do I need to make any changes to /etc/mdadm/mdadm.conf fi=
le and if so how do I do that?
>
> I see the host name is listed at the end of /etc/mdadm/mdadm.conf (name=
=3Dhostname:0) for example.
>
> Thank you,
> Pete
>
>
> -----Original Message-----
> From: Andy Smith [mailto:andy@strugglers.net]
> Sent: Wednesday, November 16, 2016 7:53 PM
> To: linux-raid@vger.kernel.org
> Subject: Newly-created arrays don't auto-assemble - related to hostname c=
hange?
>
> Hi,
>
> I feel I am missing something very simple here, as I usually don't have t=
his issue, but here goes=E2=80=A6
>
> I've got a Debian jessie host on which I created four arrays during insta=
ll (md{0,1,2,3}), using the Debian installer and partman. These auto-assemb=
le fine.
>
> After install the name of the server was changed from "tbd" to "jfd". Ano=
ther array was then created (md5), added to /etc/mdadm/mdadm.conf and the i=
nitramfs was rebuilt (update-initramfs -u).
>
> md5 does not auto-assemble. It can be started fine after boot with:
>
>     # mdadm --assemble /dev/md5
>
> or:
>
>     # mdadm --incremental /dev/sdc
>     # mdadm --incremental /dev/sdd
>
> /etc/mdadm/mdadm.conf:
>
>     DEVICE /dev/sd*
>     CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>     HOMEHOST <ignore>
>     MAILADDR root
>     ARRAY /dev/md/0  metadata=3D1.2 UUID=3D400bac1d:e2c5d6ef:fea3b8c8:bcb=
70f8f
>     ARRAY /dev/md/1  metadata=3D1.2 UUID=3De29c8b89:705f0116:d888f77e:2b6=
e32f5
>     ARRAY /dev/md/2  metadata=3D1.2 UUID=3D039b3427:4be5157a:6e2d53bd:fe8=
98803
>     ARRAY /dev/md/3  metadata=3D1.2 UUID=3D30f745ce:7ed41b53:4df72181:740=
6ea1d
>     ARRAY /dev/md/5  metadata=3D1.2 UUID=3D957030cf:c09f023d:ceaebb27:e54=
6f095
>
> I've unpacked the initramfs and looked at the mdadm.conf in there and it =
is identical.
>
> Initially HOMEHOST was set to <system> (the default), but I noticed when =
looking at --detail that md5 has:
>
>            Name : jfd:5  (local to host jfd)
>
> whereas the others have:
>
>            Name : tbd:0
>
> =E2=80=A6so I changed it to <ignore> to see if that would help. It didn't=
.
>
> So, I'd really appreciate any hints as to what I've missed here!
>
> Here follows --detail and --examine of md5 and its members, then the cont=
ents of /proc/mdstat after I have manually assembled md5.
>
> $ sudo mdadm --detail /dev/md5
> /dev/md5:
>         Version : 1.2
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 1875243008 (1788.37 GiB 1920.25 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Thu Nov 17 02:35:15 2016
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>            Name : jfd:5  (local to host jfd)
>            UUID : 957030cf:c09f023d:ceaebb27:e546f095
>          Events : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       32        1      active sync   /dev/sdc
>
> $ sudo mdadm --examine /dev/sd{c,d}
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 957030cf:c09f023d:ceaebb27:e546f095
>            Name : jfd:5  (local to host jfd)
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>    Raid Devices : 2
>
>  Avail Dev Size : 3750486704 (1788.37 GiB 1920.25 GB)
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 3750486016 (1788.37 GiB 1920.25 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D688 sectors
>           State : clean
>     Device UUID : 4ac82c29:2d109465:7fff9b22:8c411c1e
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Thu Nov 17 02:35:15 2016
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 96d669f1 - correct
>          Events : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 957030cf:c09f023d:ceaebb27:e546f095
>            Name : jfd:5  (local to host jfd)
>   Creation Time : Thu Nov 17 02:35:15 2016
>      Raid Level : raid10
>    Raid Devices : 2
>  Avail Dev Size : 3750486704 (1788.37 GiB 1920.25 GB)
>      Array Size : 1875243008 (1788.37 GiB 1920.25 GB)
>   Used Dev Size : 3750486016 (1788.37 GiB 1920.25 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D688 sectors
>           State : clean
>     Device UUID : 3a067652:6e88afae:82722342:0036bae0
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Thu Nov 17 02:35:15 2016
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : eb608799 - correct
>          Events : 0
>
>          Layout : far=3D2
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
>
> $ cat /proc/mdstat
> Personalities : [raid1] [raid10]
> md5 : active (auto-read-only) raid10 sdd[0] sdc[1]
>       1875243008 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>       bitmap: 0/14 pages [0KB], 65536KB chunk
>
> md3 : active raid10 sda5[0] sdb5[1]
>       12199936 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>
> md2 : active (auto-read-only) raid10 sda3[0] sdb3[1]
>       975872 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>
> md1 : active raid10 sda2[0] sdb2[1]
>       1951744 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
>
> md0 : active raid1 sda1[0] sdb1[1]
>       498368 blocks super 1.2 [2/2] [UU]
>
> unused devices: <none>
>
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in =
the body of a message to majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
