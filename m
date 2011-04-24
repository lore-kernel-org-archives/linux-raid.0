From: NeilBrown <neilb@suse.de>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQ=?= RAID5-asking for some
 assistance
Date: Sun, 24 Apr 2011 12:58:48 +1000
Message-ID: <20110424125848.6730999e@notabene.brown>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<4DB370E1.5030602@anonymous.org.uk>
	<BANLkTikvevtAipmEtNEGdzG4rfVeOpbLxQ@mail.gmail.com>
	<4DB38726.2090805@anonymous.org.uk>
	<BANLkTi=X8hzx6TNkfJnoantkzOz5Dv4dGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=X8hzx6TNkfJnoantkzOz5Dv4dGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Apr 2011 20:28:34 -0600 John Valarti <mdadmuser@gmail.com> wrote:

> On Sat, Apr 23, 2011 at 8:12 PM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
> ..
> > That was the letter v twice, not the letter w - and I didn't mean you to
> > specify any devices, just `mdadm -Esvv` on its own.
> 
> Oops! sorry.
> Here you go (sdd is my USB thumb drive):
> 
> mdadm: No md superblock detected on /dev/sdd1.
> mdadm: No md superblock detected on /dev/sdd.
> mdadm: No md superblock detected on /dev/sdc.
> mdadm: No md superblock detected on /dev/sdb.
> /dev/sdc2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ddf4d448:36afa319:f0917855:03f8bbe8
>   Creation Time : Mon May 15 16:38:05 2006
>      Raid Level : raid5
>   Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
>      Array Size : 734925312 (700.88 GiB 752.56 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 1
> 
>     Update Time : Mon Apr 18 07:48:54 2011
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 5674ce4e - correct
>          Events : 28580020
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8        2        0      active sync   /dev/sda2
> 
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       0        0        3      faulty removed
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 79435baa:74a2b2c3:68d7e34f:d95ad478
>   Creation Time : Mon May 15 16:38:08 2006
>      Raid Level : raid1
>   Used Dev Size : 136448 (133.27 MiB 139.72 MB)
>      Array Size : 136448 (133.27 MiB 139.72 MB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
> 
>     Update Time : Mon Apr 18 07:36:56 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 6b5ae9fa - correct
>          Events : 4878
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8        1        0      active sync   /dev/sda1
> 
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       49        3      active sync   /dev/sdd1
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ddf4d448:36afa319:f0917855:03f8bbe8
>   Creation Time : Mon May 15 16:38:05 2006
>      Raid Level : raid5
>   Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
>      Array Size : 734925312 (700.88 GiB 752.56 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 1
> 
>     Update Time : Mon Apr 18 07:48:51 2011
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 5674ce6b - correct
>          Events : 28580018
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       34        2      active sync   /dev/sdc2
> 
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       0        0        3      faulty removed
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 79435baa:74a2b2c3:68d7e34f:d95ad478
>   Creation Time : Mon May 15 16:38:08 2006
>      Raid Level : raid1
>   Used Dev Size : 136448 (133.27 MiB 139.72 MB)
>      Array Size : 136448 (133.27 MiB 139.72 MB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
> 
>     Update Time : Mon Apr 18 07:36:56 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 6b5aea1e - correct
>          Events : 4878
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       33        2      active sync   /dev/sdc1
> 
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       49        3      active sync   /dev/sdd1
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ddf4d448:36afa319:f0917855:03f8bbe8
>   Creation Time : Mon May 15 16:38:05 2006
>      Raid Level : raid5
>   Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
>      Array Size : 73492531mdadm: No md superblock detected on /dev/sda.
> mdadm: No md superblock detected on /dev/loop0.
> 2 (700.88 GiB 752.56 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 1
> 
>     Update Time : Mon Apr 18 07:48:54 2011
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 5674ce60 - correct
>          Events : 28580020
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       18        1      active sync   /dev/sdb2
> 
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
>    3     3       0        0        3      faulty removed
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 79435baa:74a2b2c3:68d7e34f:d95ad478
>   Creation Time : Mon May 15 16:38:08 2006
>      Raid Level : raid1
>   Used Dev Size : 136448 (133.27 MiB 139.72 MB)
>      Array Size : 136448 (133.27 MiB 139.72 MB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
> 
>     Update Time : Mon Apr 18 07:36:56 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 6b5aea0c - correct
>          Events : 4878
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       17        1      active sync   /dev/sdb1
> 
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       49        3      active sync   /dev/sdd1
> 
> 
> >>> Please also try `mdadm --assemble --scan --verbose` and post the result.
> mdadm: No arrays found in config file
> 

I should have also asked for "mdadm --version".

However given that above, you want to:


   mdadm --assemble --verbose --force /dev/md1 /dev/sda2 /dev/sdb2 /dev/sdc2

NeilBrown

