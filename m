From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: Raid auto-assembly upon boot - device order
Date: Tue, 28 Jun 2011 12:18:16 +0200
Message-ID: <4E09AA68.2050302@ivitera.com>
References: <4E089067.8010904@ivitera.com> <4E08980B.5080002@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E08980B.5080002@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Dne 27.6.2011 16:47, Phil Turmel napsal(a):
> Hi Pavel,
> 
> On 06/27/2011 10:15 AM, Pavel Hofman wrote:
>> Hi,
>> 
>> 
>> Our mdadm.conf lists the raids in proper order, corresponding to
>> their dependency.
> 
> I would first check the copy of mdadm.conf in your initramfs.  If it
> specifies just the raid1, you can end up in this situation.
> Most distributions have an 'update-initramfs' script or something
> similar which must be run after any updates to files that are needed
> in early boot.

Hi Phil,

Thanks a lot for your reply. I update the initramfs image regularly.
Just to make sure I uncompressed the current image, mdadm.conf lists all
the raids correctly:

DEVICE /dev/sd[a-z][1-9] /dev/md1 /dev/md2 /dev/md3 /dev/md4 /dev/md5
/dev/md6 /dev/md7 /dev/md8 /dev/md9
ARRAY /dev/md5 level=raid1 metadata=1.0 num-devices=2
UUID=2f88c280:3d7af418:e8d459c5:782e3ed2
ARRAY /dev/md6 level=raid1 metadata=1.0 num-devices=2
UUID=1f83ea99:a9e4d498:a6543047:af0a3b38
ARRAY /dev/md7 level=raid1 metadata=1.0 num-devices=2
UUID=dde16cd5:2e17c743:fcc7926c:fcf5081e
ARRAY /dev/md3 level=raid0 num-devices=2
UUID=8c9c28dd:ac12a9ef:a6200310:fe6d9686
ARRAY /dev/md1 level=raid1 num-devices=5
UUID=588cbbfd:4835b4da:0d7a0b1c:7bf552bb
ARRAY /dev/md2 level=raid1 num-devices=2
UUID=28714b52:55b123f5:a6200310:fe6d9686
ARRAY /dev/md4 level=raid0 num-devices=2
UUID=ce213d01:e50809ed:a6200310:fe6d9686
ARRAY /dev/md8 level=raid0 num-devices=2 metadata=00.90
UUID=5d23817a:fde9d31b:05afacbb:371c5cc4
ARRAY /dev/md9 level=raid0 num-devices=2 metadata=00.90
UUID=9854dd7a:43e8f27f:05afacbb:371c5cc4


This is my rather complex setup:
Personalities : [raid1] [raid0]
md4 : active raid0 sdb1[0] sdd3[1]
      2178180864 blocks 64k chunks

md2 : active raid1 sdc2[0] sdd2[1]
      8787456 blocks [2/2] [UU]

md3 : active raid0 sda1[0] sdc3[1]
      2178180864 blocks 64k chunks

md7 : active raid1 md6[2] md5[1]
      2178180592 blocks super 1.0 [2/1] [_U]
      [===========>.........]  recovery = 59.3% (1293749868/2178180592)
finish=164746.8min speed=87K/sec

md6 : active raid1 md4[0]
      2178180728 blocks super 1.0 [2/1] [U_]

md5 : active raid1 md3[2]
      2178180728 blocks super 1.0 [2/1] [U_]
      bitmap: 9/9 pages [36KB], 131072KB chunk

md1 : active raid1 sdc1[0] sdd1[3]
      10739328 blocks [5/2] [U__U_]


You can see md7 recoverying, even though both md5 and md6 were present.

Here is the relevant part of dmesg at boot:


[   11.957040] device-mapper: uevent: version 1.0.3
[   11.957040] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18)
initialised: dm-devel@redhat.com
[   12.017047] md: md1 still in use.
[   12.017047] md: md1 still in use.
[   12.017821] md: md5 stopped.
[   12.133051] md: md6 stopped.
[   12.134968] md: md7 stopped.
[   12.141042] md: md3 stopped.
[   12.193037] md: bind<sdc3>
[   12.193037] md: bind<sda1>
[   12.237037] md: raid0 personality registered for level 0
[   12.237037] md3: setting max_sectors to 128, segment boundary to 32767
[   12.237037] raid0: looking at sda1
[   12.237037] raid0:   comparing sda1(732571904) with sda1(732571904)
[   12.237037] raid0:   END
[   12.237037] raid0:   ==> UNIQUE
[   12.237037] raid0: 1 zones
[   12.237037] raid0: looking at sdc3
[   12.237037] raid0:   comparing sdc3(1445608960) with sda1(732571904)
[   12.237037] raid0:   NOT EQUAL
[   12.237037] raid0:   comparing sdc3(1445608960) with sdc3(1445608960)
[   12.237037] raid0:   END
[   12.237037] raid0:   ==> UNIQUE
[   12.237037] raid0: 2 zones
[   12.237037] raid0: FINAL 2 zones
[   12.237037] raid0: zone 1
[   12.237037] raid0: checking sda1 ... nope.
[   12.237037] raid0: checking sdc3 ... contained as device 0
[   12.237037]   (1445608960) is smallest!.
[   12.237037] raid0: zone->nb_dev: 1, size: 713037056
[   12.237037] raid0: current zone offset: 1445608960
[   12.237037] raid0: done.
[   12.237037] raid0 : md_size is 2178180864 blocks.
[   12.237037] raid0 : conf->hash_spacing is 1465143808 blocks.
[   12.237037] raid0 : nb_zone is 2.
[   12.237037] raid0 : Allocating 16 bytes for hash.
[   12.241039] md: md2 stopped.
[   12.261038] md: bind<sdd2>
[   12.261038] md: bind<sdc2>
[   12.305037] raid1: raid set md2 active with 2 out of 2 mirrors
[   12.305037] md: md4 stopped.
[   12.317037] md: bind<sdd3>
[   12.317037] md: bind<sdb1>
[   12.361036] md4: setting max_sectors to 128, segment boundary to 32767
[   12.361036] raid0: looking at sdb1
[   12.361036] raid0:   comparing sdb1(732571904) with sdb1(732571904)
[   12.361036] raid0:   END
[   12.361036] raid0:   ==> UNIQUE
[   12.361036] raid0: 1 zones
[   12.361036] raid0: looking at sdd3
[   12.361036] raid0:   comparing sdd3(1445608960) with sdb1(732571904)
[   12.361036] raid0:   NOT EQUAL
[   12.361036] raid0:   comparing sdd3(1445608960) with sdd3(1445608960)
[   12.361036] raid0:   END
[   12.361036] raid0:   ==> UNIQUE
[   12.361036] raid0: 2 zones
[   12.361036] raid0: FINAL 2 zones
[   12.361036] raid0: zone 1
[   12.361036] raid0: checking sdb1 ... nope.
[   12.361036] raid0: checking sdd3 ... contained as device 0
[   12.361036]   (1445608960) is smallest!.
[   12.361036] raid0: zone->nb_dev: 1, size: 713037056
[   12.361036] raid0: current zone offset: 1445608960
[   12.361036] raid0: done.
[   12.361036] raid0 : md_size is 2178180864 blocks.
[   12.361036] raid0 : conf->hash_spacing is 1465143808 blocks.
[   12.361036] raid0 : nb_zone is 2.
[   12.361036] raid0 : Allocating 16 bytes for hash.
[   12.361036] md: md8 stopped.
[   12.413036] md: md9 stopped.
[   12.429036] md: bind<md3>
[   12.469035] raid1: raid set md5 active with 1 out of 2 mirrors
[   12.473035] md5: bitmap initialized from disk: read 1/1 pages, set
5027 bits
[   12.473035] created bitmap (9 pages) for device md5
[   12.509036] md: bind<md5>
[   12.549035] raid1: raid set md7 active with 1 out of 2 mirrors
[   12.573039] md: md6 stopped.
[   12.573039] md: bind<md4>
[   12.573039] md: md6: raid array is not clean -- starting background
reconstruction
[   12.617034] raid1: raid set md6 active with 1 out of 2 mirrors

Please notice that md7 is being assembled before even mentioning md6,
its component. Upon that, md6 is marked as not clean, eventhough both
md5 and md6 are degraded (the missing drives are connected weekly via
eSATA from external enclosure and used for offline backups).

Plus how can can a background reconstruction be started on md6, if it is
degraded and the other mirroring part is not even present?

Thanks a lot,

Pavel.

