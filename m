From: David Dougall <davidd@et.byu.edu>
Subject: Re: Postgres on RAID5
Date: Wed, 16 Mar 2005 09:47:35 -0700 (MST)
Message-ID: <Pine.LNX.4.58.0503160947080.11922@lewis.et.byu.edu>
References: <4231F5F2.6000509@m-cam.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <4231F5F2.6000509@m-cam.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arshavir Grigorian <ag@m-cam.com>
Cc: linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

In my experience, if you are concerned about filesystem performance, don't
use ext3.  It is one of the slowest filesystems I have ever used
especially for writes.  I would suggest either reiserfs or xfs.
--David Dougall


On Fri, 11 Mar 2005, Arshavir Grigorian wrote:

> Hi,
>
> I have a RAID5 array (mdadm) with 14 disks + 1 spare. This partition has
> an Ext3 filesystem which is used by Postgres. Currently we are loading a
> 50G database on this server from a Postgres dump (copy, not insert) and
> are experiencing very slow write performance (35 records per second).
>
> Top shows that the Postgres process (postmaster) is being constantly put
> into D state for extended periods of time (2-3 seconds) which I assume
> is because it's waiting for disk io. I have just started gathering
> system statistics and here is what sar -b shows: (this is while the db
> is being loaded - pg_restore)
>
>   	       tps        rtps     wtps      bread/s  bwrtn/s
> 01:35:01 PM    275.77     76.12    199.66    709.59   2315.23
> 01:45:01 PM    287.25     75.56    211.69    706.52   2413.06
> 01:55:01 PM    281.73     76.35    205.37    711.84   2389.86
> 02:05:01 PM    282.83     76.14    206.69    720.85   2418.51
> 02:15:01 PM    284.07     76.15    207.92    707.38   2443.60
> 02:25:01 PM    265.46     75.91    189.55    708.87   2089.21
> 02:35:01 PM    285.21     76.02    209.19    709.58   2446.46
> Average:       280.33     76.04    204.30    710.66   2359.47
>
> This is a Sun e450 with dual TI UltraSparc II processors and 2G of RAM.
> It is currently running Debian Sarge with a 2.4.27-sparc64-smp custom
> compiled kernel. Postgres is installed from the Debian package and uses
> all the configuration defaults.
>
> I am also copying the pgsql-performance list.
>
> Thanks in advance for any advice/pointers.
>
>
> Arshavir
>
> Following is some other info that might be helpful.
>
> /proc/scsi# mdadm -D /dev/md1
> /dev/md1:
>          Version : 00.90.00
>    Creation Time : Wed Feb 23 17:23:41 2005
>       Raid Level : raid5
>       Array Size : 123823616 (118.09 GiB 126.80 GB)
>      Device Size : 8844544 (8.43 GiB 9.06 GB)
>     Raid Devices : 15
>    Total Devices : 17
> Preferred Minor : 1
>      Persistence : Superblock is persistent
>
>      Update Time : Thu Feb 24 10:05:38 2005
>            State : active
>   Active Devices : 15
> Working Devices : 16
>   Failed Devices : 1
>    Spare Devices : 1
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
>             UUID : 81ae2c97:06fa4f4d:87bfc6c9:2ee516df
>           Events : 0.8
>
>      Number   Major   Minor   RaidDevice State
>         0       8       64        0      active sync   /dev/sde
>         1       8       80        1      active sync   /dev/sdf
>         2       8       96        2      active sync   /dev/sdg
>         3       8      112        3      active sync   /dev/sdh
>         4       8      128        4      active sync   /dev/sdi
>         5       8      144        5      active sync   /dev/sdj
>         6       8      160        6      active sync   /dev/sdk
>         7       8      176        7      active sync   /dev/sdl
>         8       8      192        8      active sync   /dev/sdm
>         9       8      208        9      active sync   /dev/sdn
>        10       8      224       10      active sync   /dev/sdo
>        11       8      240       11      active sync   /dev/sdp
>        12      65        0       12      active sync   /dev/sdq
>        13      65       16       13      active sync   /dev/sdr
>        14      65       32       14      active sync   /dev/sds
>
>        15      65       48       15      spare   /dev/sdt
>
> # dumpe2fs -h /dev/md1
> dumpe2fs 1.35 (28-Feb-2004)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          1bb95bd6-94c7-4344-adf2-8414cadae6fc
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal dir_index needs_recovery large_file
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              15482880
> Block count:              30955904
> Reserved block count:     1547795
> Free blocks:              28767226
> Free inodes:              15482502
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         16384
> Inode blocks per group:   512
> Filesystem created:       Wed Feb 23 17:27:13 2005
> Last mount time:          Wed Feb 23 17:45:25 2005
> Last write time:          Wed Feb 23 17:45:25 2005
> Mount count:              2
> Maximum mount count:      28
> Last checked:             Wed Feb 23 17:27:13 2005
> Check interval:           15552000 (6 months)
> Next check after:         Mon Aug 22 18:27:13 2005
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      c35c0226-3b52-4dad-b102-f22feb773592
> Journal backup:           inode blocks
>
> # lspci | grep SCSI
> 0000:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 14)
> 0000:00:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 14)
> 0000:00:04.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 14)
> 0000:00:04.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 14)
> 0000:04:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 03)
> 0000:04:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875
> (rev 03)
>
> /proc/scsi# more scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>    Vendor: SEAGATE  Model: ST39103LCSUN9.0G Rev: 034A
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>    Vendor: SEAGATE  Model: ST39103LCSUN9.0G Rev: 034A
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>    Vendor: SEAGATE  Model: ST39103LCSUN9.0G Rev: 034A
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>    Vendor: SEAGATE  Model: ST39103LCSUN9.0G Rev: 034A
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 01 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi1 Channel: 00 Id: 02 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi1 Channel: 00 Id: 03 Lun: 00
>    Vendor: SEAGATE  Model: ST39103LCSUN9.0G Rev: 034A
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi2 Channel: 00 Id: 01 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi2 Channel: 00 Id: 02 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi2 Channel: 00 Id: 03 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi3 Channel: 00 Id: 01 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi3 Channel: 00 Id: 02 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi3 Channel: 00 Id: 03 Lun: 00
>    Vendor: SEAGATE  Model: ST39204LCSUN9.0G Rev: 4207
>    Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi4 Channel: 00 Id: 06 Lun: 00
>    Vendor: TOSHIBA  Model: XM6201TASUN32XCD Rev: 1103
>    Type:   CD-ROM                           ANSI SCSI revision: 02
> Host: scsi5 Channel: 00 Id: 00 Lun: 00
>    Vendor: FUJITSU  Model: MAG3091L SUN9.0G Rev: 1111
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi5 Channel: 00 Id: 01 Lun: 00
>    Vendor: FUJITSU  Model: MAG3091L SUN9.0G Rev: 1111
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi5 Channel: 00 Id: 02 Lun: 00
>    Vendor: FUJITSU  Model: MAG3091L SUN9.0G Rev: 1111
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi5 Channel: 00 Id: 03 Lun: 00
>    Vendor: FUJITSU  Model: MAG3091L SUN9.0G Rev: 1111
>    Type:   Direct-Access                    ANSI SCSI revision: 02
>
>
>
>
>
>
> --
> Arshavir Grigorian
> Systems Administrator/Engineer
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
