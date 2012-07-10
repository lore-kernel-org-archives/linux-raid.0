From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Assembly failure
Date: Tue, 10 Jul 2012 19:38:51 +0200
Message-ID: <4FFC68AB.4010801@profitbricks.com>
References: <20120710163345.GB29855@nsrc.org> <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120710170646.GA29962@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your kernel is similar to v3.4 mainline. Your kernel has been compiled
one day after Linus tagged v3.4. This kernel has major issues. Please
reboot into the old 3.2 kernel.

Your kernel has no tag in the Ubuntu Git repos!

http://kernel.ubuntu.com/git?p=3Dubuntu/ubuntu-precise.git;a=3Dtags
http://kernel.ubuntu.com/git?p=3Dubuntu/ubuntu-quantal.git;a=3Dtags

Your kernel is absolutely unstable. Who built this kernel? Can't be
official release!

Cheers,
Sebastian


On 10.07.2012 19:06, Brian Candler wrote:
> On Tue, Jul 10, 2012 at 06:48:00PM +0200, Sebastian Riemer wrote:
>> 1. Are you crazy to do so? The kernel 3.2 is the stable for Ubuntu 1=
2.04.
> Possibly crazy :-) Specifically I had been testing out whether the
> direct-io-enable option for glusterfs would be helpful (it wasn't) - =
this
> required FUSE support for O_DIRECT which is not in 3.2.0.
>
>> 2. Please provide the complete Ubuntu version number of your kernel =
so
>> that we can look for the commits in the Ubuntu Git.
> brian@dev-storage1:~$ uname -a
> Linux dev-storage1.example.com 3.4.0-030400-generic #201205210521 SMP=
 Mon May 21 09:22:02 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> Packages:
>
> ii  linux-headers-3.4.0-030400         3.4.0-030400.201205210521     =
           Header files related to Linux kernel version 3.4.0
> ii  linux-headers-3.4.0-030400-generic 3.4.0-030400.201205210521     =
           Linux kernel headers for version 3.4.0 on 32 bit x86 SMP
> ii  linux-image-3.4.0-030400-generic   3.4.0-030400.201205210521     =
           Linux kernel image for version 3.4.0 on 32 bit x86 SMP
>
> It was downloaded from here:
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.4-precise/
>
> There doesn't seem to be any newer 3.4.x for precise.
>
>> Should be
>> git://kernel.ubuntu.com/ppisati/ubuntu-quantal.git.
>> There were some nasty bugs in 3.4.0 mainline - I don't know if the f=
ixes
>> for them are in your kernel.
> I have no problem rolling back into 3.2.0, but I'm also very happy to=
 do any
> diagnostics which may be helpful before I do so.
>
> Regards,
>
> Brian.
>
>> Cheers,
>> Sebastian
>>
>>
>> On 10.07.2012 18:33, Brian Candler wrote:
>>> An odd one here.
>>>
>>> Ubuntu 12.04 system, updated to 3.4.0 kernel from the mainline-ppa.=
 Machine
>>> has a boot disk plus 12 other disks in a RAID10 far2 array.
>>>
>>> System was working fine, but after most recent reboot mdraid failed=
 to
>>> assemble.
>>>
>>> root@dev-storage1:~# cat /proc/mdstat
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
] [raid4] [raid10]=20
>>> md127 : inactive sdk[9](S) sdl[10](S) sdj[8](S) sdg[5](S) sdc[1](S)=
 sdm[11](S) sdf[4](S) sde[3](S) sdi[7](S) sdd[2](S) sdb[0](S) sdh[6](S)
>>>       35163186720 blocks super 1.2
>>>       =20
>>> unused devices: <none>
>>>
>>> dmesg shows periodic "export_rdev" messages:
>>>
>>> root@dev-storage1:~# dmesg | grep md:
>>> [  953.986401] md: export_rdev(sdo)
>>> [  953.988515] md: export_rdev(sdo)
>>> [  960.237392] md: export_rdev(sdp)
>>> [  960.241928] md: export_rdev(sdp)
>>> [  960.965132] md: export_rdev(sdr)
>>> [  960.967265] md: export_rdev(sdr)
>>> [ 1012.573415] md: export_rdev(sdo)
>>> [ 1012.575650] md: export_rdev(sdo)
>>> [ 1012.829690] md: export_rdev(sdp)
>>> [ 1012.831493] md: export_rdev(sdp)
>>> ...
>>> [19378.332473] md: export_rdev(sds)
>>> [19378.333764] md: export_rdev(sds)
>>> [19417.220171] md: export_rdev(sdr)
>>> [19417.221748] md: export_rdev(sdr)
>>> [23739.824227] md: export_rdev(sdr)
>>> [23739.825554] md: export_rdev(sdr)
>>> [23740.568940] md: export_rdev(sds)
>>> [23740.570079] md: export_rdev(sds)
>>>
>>> metadata (see below) suggests that some drives think members 1/3/4 =
are
>>> missing, but those drives think the array is fine.  The "Events" co=
unts are
>>> different on some members though.
>>>
>>> What's the best thing to do here - attempt to force assembly? Any i=
deas how
>>> it got into this state?
>>>
>>> The machine was rebooted a couple of times but in what should have =
been a
>>> clean way, i.e.  sudo reboot or sudo halt -p.
>>>
>>> Many thanks,
>>>
>>> Brian.
>>>
>>>
>>> root@dev-storage1:~# for i in /dev/sd{j..u}; do echo "=3D=3D=3D $i =
=3D=3D=3D"; mdadm --examine $i; done
>>> =3D=3D=3D /dev/sdj =3D=3D=3D
>>> /dev/sdj:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : e96965d5:bf8986b7:fa83b813:e27aa17f
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : 5673ac95 - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 8
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdk =3D=3D=3D
>>> /dev/sdk:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : f15bb47f:85ca59b1:cad42dec:f8b1b63c
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : 9020674a - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 9
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdl =3D=3D=3D
>>> /dev/sdl:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : e2d82a4c:8409d883:cf2d9b7c:83829aad
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : 30664ccb - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 10
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdm =3D=3D=3D
>>> /dev/sdm:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : e3603570:8e767487:63f3131b:afe358ea
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : 33446897 - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 11
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdn =3D=3D=3D
>>> /dev/sdn:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : 549a5230:005cedf8:b37a0d7e:36648ff0
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : ce0a8f46 - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 0
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdo =3D=3D=3D
>>> /dev/sdo:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : active
>>>     Device UUID : b09f3869:09ce8a89:31ed7097:d3621064
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Sat Jul  7 14:02:07 2012
>>>        Checksum : 246eb119 - correct
>>>          Events : 29355
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 2
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdp =3D=3D=3D
>>> /dev/sdp:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : active
>>>     Device UUID : 71494ee2:1504b35a:00a1d927:543db7c6
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Sat Jul  7 14:00:55 2012
>>>        Checksum : 61c11eeb - correct
>>>          Events : 29352
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 3
>>>    Array State : A.AA.AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdq =3D=3D=3D
>>> /dev/sdq:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : 17fcd5b8:97fc715f:0877d022:3770d08b
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : fd1699fc - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 7
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdr =3D=3D=3D
>>> /dev/sdr:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : e0565412:a68cf236:9da9a141:e89f935a
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul  3 04:21:50 2012
>>>        Checksum : 1ba72ec1 - correct
>>>          Events : 20228
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 1
>>>    Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sds =3D=3D=3D
>>> /dev/sds:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : active
>>>     Device UUID : c0f3bbab:70f3e69e:1314cdca:072d5ad9
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul  3 06:37:33 2012
>>>        Checksum : 24f36d4c - correct
>>>          Events : 29312
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 5
>>>    Array State : A.AA.AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdt =3D=3D=3D
>>> /dev/sdt:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : clean
>>>     Device UUID : 6b4f9595:4de46aa8:fa695fe8:59b797e7
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul 10 10:46:19 2012
>>>        Checksum : 44250f1b - correct
>>>          Events : 29374
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 6
>>>    Array State : A.A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>> =3D=3D=3D /dev/sdu =3D=3D=3D
>>> /dev/sdu:
>>>           Magic : a92b4efc
>>>         Version : 1.2
>>>     Feature Map : 0x1
>>>      Array UUID : 16b260fd:e49bd157:da886cd0:5394e194
>>>            Name : storage1:storage1
>>>   Creation Time : Thu Jun  7 13:51:21 2012
>>>      Raid Level : raid10
>>>    Raid Devices : 12
>>>
>>>  Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>      Array Size : 35163168768 (16767.11 GiB 18003.54 GB)
>>>   Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>>>     Data Offset : 2048 sectors
>>>    Super Offset : 8 sectors
>>>           State : active
>>>     Device UUID : 46f03854:de80bec8:b44b062c:dd265ba3
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Update Time : Tue Jul  3 06:36:18 2012
>>>        Checksum : 22812848 - correct
>>>          Events : 29272
>>>
>>>          Layout : far=3D2
>>>      Chunk Size : 1024K
>>>
>>>    Device Role : Active device 4
>>>    Array State : A.AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
10405 Berlin, Germany

Tel.:  +49 - 30 - 60 98 56 991 - 303
=46ax:   +49 - 30 - 51 64 09 22
Email: sebastian.riemer@profitbricks.com
Web:   http://www.profitbricks.com/

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
