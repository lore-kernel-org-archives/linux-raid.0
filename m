From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid0: device does not exist with examine and scan
Date: Thu, 27 Jul 2017 18:07:30 +0100
Message-ID: <597A1DD2.50906@youngman.org.uk>
References: <1f4ad2b8-70f4-12e1-16e9-40550a05fd96@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f4ad2b8-70f4-12e1-16e9-40550a05fd96@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/07/17 17:11, Nigel Croxon wrote:
> 
> Hello all,
> 
> The device name referenced in the mdadm --examine --scan does not exist
> when using metadata=1.2 and --name on the creation.
> I am using metadata 0.9 as a bases to test against 1.2.
> Am I fighting a udev rule? Did the symlink from /dev/md/TEST_MD to
> /dev/md0 disappear?
> 
> 
> If I start with METADATA=0.9 and specifying a --name
> 
> # mdadm --create --verbose /dev/md0 --level=0 --metadata=0.9
> --raid-devices=2 --name=TEST_MD /dev/sdd /dev/sde
> 
> with METADATA=0.9, there is no NAME field printed on DETAIL

I don't think 0.9 metadata supports names ...
> 
> # mdadm -D /dev/md0
> /dev/md0:
>            Version : 0.90
>      Creation Time : Thu Jul 27 10:36:02 2017
>         Raid Level : raid0
>         Array Size : 293045760 (279.47 GiB 300.08 GB)
>       Raid Devices : 2
>      Total Devices : 2
>    Preferred Minor : 0
>        Persistence : Superblock is persistent
> 
>        Update Time : Thu Jul 27 10:36:02 2017
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
> 
>         Chunk Size : 512K
> 
> Consistency Policy : none
> 
>               UUID : 623d8bac:8819491b:e9034e5d:acd14f01
>             Events : 0.1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       64        1      active sync   /dev/sde
> 
> 
> The --examine --scan shows /dev/md0, and not /dev/md/TEST_MD.
> # mdadm --examine --scan
> ARRAY /dev/md0 UUID=65cb66eb:d8a0d9ff:85609b40:89383835
> 
> 
> Next, change the METADATA=1.2 and specifying a --name
> # mdadm --create --verbose /dev/md0 --level=0 --metadata=1.2
> --raid-devices=2 --name=TEST_MD /dev/sdd /dev/sde
> 
> With METADATA=1.2, there is a NAME field printed:
> thinkstation:TEST_MD  (local to host thinkstation)
> 
> # mdadm -D /dev/md0
> /dev/md0:
>            Version : 1.2
>      Creation Time : Thu Jul 27 11:13:02 2017
>         Raid Level : raid0
>         Array Size : 292784128 (279.22 GiB 299.81 GB)
>       Raid Devices : 2
>      Total Devices : 2
>        Persistence : Superblock is persistent
> 
>        Update Time : Thu Jul 27 11:13:02 2017
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
> 
>         Chunk Size : 512K
> 
> Consistency Policy : none
> 
>               Name : thinkstation:TEST_MD  (local to host thinkstation)
>               UUID : 591d68eb:5182a6e2:ead93be0:812f7fc6
>             Events : 0
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       64        1      active sync   /dev/sde
> 
> The --examine --scan is shows /dev/md/TEST_MD and not /dev/md0.
> 
> # mdadm --examine --scan
> ARRAY /dev/md/TEST_MD  metadata=1.2
> UUID=413a8ca9:a1edb21b:9eb8876d:784349ed name=thinkstation:TEST_MD
> 
> This problem is, /dev/md/TEST_MD does not exist. /dev/md0 does.

Is the array running? This is an educated guess on my part, but I think
it's running the array that creates the symlink.
> 
> mdadm --version
> mdadm - v4.0-158-gcb91230 - 2017-07-10
> 
> Am I fighting udev rules?
> 
Cheers,
Wol

