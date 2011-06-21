From: "Manny Street" <mann@groupmindexpress.com>
Subject: 10x2TB RAID6
Date: Tue, 21 Jun 2011 16:59:49 -0700 (PDT)
Message-ID: <63249.50.0.66.8.1308700789.squirrel@www.groupmindexpress.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20110621165949_35665"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_20110621165949_35665
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

linux-raid@vger.kernel.org

Neil Brown,

I've posted to your webpage (http://neil.brown.name/blog/20090817000931)
in the past, so I hope you don't mind too much if I ask you for advice...
even if your not overly interested since the array failed during "normal"
use and not a conversion or grow.

I have a 10x2TB RAID6 array and I notice three drives have a different
"Event id" than the other 7 drives does this imply I'm "out of luck?".
*UPDATE* just noticed one of the three drives was a "spare" (why the same
event id?)

Do you think the array will just "start up" if I try to assemble it? Minus
2drives?  Did the array not "freeze" after the 1st error?

I haven't tried anything yet... other than booting the machine after
renaming the mdadm.conf file (I expected this to prevent the array from
starting, however, a small 150G array started, maybe I needed to comment
out the entries rather than rename the file).

I have 8 ST32000542AS drives hanging off an "AOC-SASLP-MV8" card and 4
others on the motherboard ports (boot+spare) I think the 8 on the
raid-card drives went offline.  All drives appear to have come back after
reboot.

I can provide you with more details, logs or even a shell "login" if you
like.

Note: after the *update* comment (spare) things are looking less dire but
any reassurance is appreciated.

Thank you,
-mann

mdadm -Evs
ARRAY /dev/md/127 level=raid6 metadata=1.2 num-devices=10
UUID=1747a894:8c1b4ea6:78d906f1:e0012a25 name=midori:127
   spares=1  
devices=/dev/sdl1,/dev/sdk1,/dev/sdj1,/dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd3,/dev/sdb3,/dev/sdc3
ARRAY /dev/md/128 level=raid0 metadata=1.2 num-devices=6
UUID=b941a4ef:a119f0a7:5b9a19de:066487fd name=midori.gmind.org:128
   devices=/dev/sdl2,/dev/sdk2,/dev/sdj2,/dev/sdi2,/dev/sdh2,/dev/sdg2

cat /proc/mdstat
# at time of failure #
Personalities : [raid0] [raid6] [raid5] [raid4]
md128 : active raid0 sdk2[5] sdl2[3] sdi2[2] sdg2[0] sdh2[1] sdj2[4]
      154263552 blocks super 1.2 512k chunks

md127 : active raid6 sdk1[8](F) sdi1[3](F) sdl1[7](F) sdf1[4](F)
sdg1[6](F) sde1[2](F) sdh1[5](F) sdj1[0](F) sdb3[9] sdd3[11](S) sdc3[10]
      15422390272 blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/2]
[________UU]

unused devices: <none>

# after reboot #
Personalities : [raid0]
md126 : active raid0 sdl2[3] sdh2[1] sdk2[5] sdj2[4] sdg2[0] sdi2[2]
      154263552 blocks super 1.2 512k chunks

md127 : inactive sdf1[4](S) sdh1[5](S) sdb3[9](S) sdi1[3](S) sdj1[0](S)
sdd3[11](S) sdl1[7](S) sde1[2](S) sdg1[6](S) sdk1[8](S) sdc3[10](S)
      21205788389 blocks super 1.2

unused devices: <none>


/dev/mapper/vg_media-lv_repo01:
        Version : 1.2
  Creation Time : Sun Oct  3 18:37:02 2010
     Raid Level : raid6
     Array Size : 15422357504 (14707.91 GiB 15792.49 GB)
  Used Dev Size : unknown
   Raid Devices : 10
  Total Devices : 11
    Persistence : Superblock is persistent

    Update Time : Tue Jun 21 00:15:45 2011
          State : clean, FAILED
 Active Devices : 2
Working Devices : 3
 Failed Devices : 8
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : midori:127
           UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
         Events : 120973

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       0        0        2      removed
       3       0        0        3      removed
       4       0        0        4      removed
       5       0        0        5      removed
       6       0        0        6      removed
       7       0        0        7      removed
       9       8       19        8      active sync   /dev/sdb3
      10       8       35        9      active sync   /dev/sdc3

       0       8      145        -      faulty spare   /dev/sdj1
       2       8       65        -      faulty spare   /dev/sde1
       3       8      129        -      faulty spare   /dev/sdi1
       4       8       81        -      faulty spare   /dev/sdf1
       5       8      113        -      faulty spare   /dev/sdh1
       6       8       97        -      faulty spare   /dev/sdg1
       7       8      177        -      faulty spare   /dev/sdl1
       8       8      161        -      faulty spare   /dev/sdk1
      11       8       51        -      spare   /dev/sdd3


/dev/sdf1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 4d6a2158:b7fa56b2:214613af:69af783c
       Checksum : 2510e6ed - correct
         Events : 120904
   Device Role : Active device 4
/dev/sdh1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : b2a48e12:796b2c18:376beed8:74596771
       Checksum : a41d6455 - correct
         Events : 120904
   Device Role : Active device 5
/dev/sdb3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : e3834a2e:f8949e75:b26d1c5b:8631dbd9
       Checksum : 7e35341 - correct
         Events : 121003
   Device Role : Active device 8
/dev/sdi1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : d9b17712:cd167319:c17dcfc3:d847fcd2
       Checksum : f1c31a9c - correct
         Events : 120904
   Device Role : Active device 3
/dev/sdj1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : f1cb78ca:df118e47:57ade846:740e0c47
       Checksum : cf0825f5 - correct
         Events : 120904
   Device Role : Active device 0
/dev/sdd3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : a166f386:a6aa95dc:7f7ea369:3226d7ff
       Checksum : fc065128 - correct
         Events : 121003
/dev/sdl1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 7e5d9ed7:13fe2b3e:acbe1b4a:1ab3f660
       Checksum : efe959b8 - correct
         Events : 120904
   Device Role : Active device 1
/dev/sde1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 3ee69896:cea55b57:229052b4:f5ca02cf
       Checksum : a0567380 - correct
         Events : 120904
   Device Role : Active device 2
/dev/sdg1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 1035f17d:79452818:33fd5c41:dcab73ab
       Checksum : b1f6aff8 - correct
         Events : 120904
   Device Role : Active device 6
/dev/sdk1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : cafe0241:222eb745:0bf1d0f2:c66f0c09
       Checksum : b1a41a1f - correct
         Events : 120904
   Device Role : Active device 7
/dev/sdc3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 746265e7:475ba235:dc367ab3:82f482a4
       Checksum : a4078448 - correct
         Events : 121003
   Device Role : Active device 9



Jun 20 23:34:57 midori kernel: ata13: translated ATA stat/err 0x01/04 to
SCSI SK/ASC/ASCQ 0xb/00/00
Jun 20 23:34:57 midori kernel: ata13: status=0x01 { Error }
Jun 20 23:34:57 midori kernel: ata13: error=0x04 { DriveStatusError }
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Sense Key : Aborted
Command [current] [descriptor]
Jun 20 23:34:57 midori kernel: Descriptor sense data with sense
descriptors (in hex):
Jun 20 23:34:57 midori kernel:        72 0b 00 00 00 00 00 0c 00 0a 80 00
00 00 00 00
Jun 20 23:34:57 midori kernel:        00 00 00 56
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Add. Sense: No
additional sense information
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk] CDB: Write(10): 2a 00 a1
3f e0 3f 00 02 00 00
Jun 20 23:34:57 midori kernel: end_request: I/O error, dev sdk, sector
2705317951
Jun 20 23:34:57 midori kernel: md/raid:md127: Disk failure on sdk1,
disabling device.
Jun 20 23:34:57 midori kernel: <1>md/raid:md127: Operation continuing on 9
devices.
Jun 20 23:34:57 midori kernel: ata13: translated ATA stat/err 0x01/04 to
SCSI SK/ASC/ASCQ 0xb/00/00
Jun 20 23:34:57 midori kernel: ata13: status=0x01 { Error }
Jun 20 23:34:57 midori kernel: ata13: error=0x04 { DriveStatusError }
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Sense Key : Aborted
Command [current] [descriptor]
Jun 20 23:34:57 midori kernel: Descriptor sense data with sense
descriptors (in hex):
Jun 20 23:34:57 midori kernel:        72 0b 00 00 00 00 00 0c 00 0a 80 00
00 00 00 00
Jun 20 23:34:57 midori kernel:        00 00 00 56
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Add. Sense: No
additional sense information
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk] CDB: Read(10): 28 00 a1
3f de 5f 00 01 e0 00
Jun 20 23:34:57 midori kernel: end_request: I/O error, dev sdk, sector
2705317471
Jun 20 23:35:27 midori kernel: INFO: task kworker/u:7:345 blocked for more
than 120 seconds.
Jun 20 23:35:27 midori kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 23:35:27 midori kernel: kworker/u:7   D 0000000000000000     0  
345      2 0x00000000
Jun 20 23:35:27 midori kernel: ffff88003716ba10 0000000000000046
ffff88003965aa00 ffff88003716a010
Jun 20 23:35:27 midori kernel: ffff88003716bfd8 0000000000014940
ffff88003711ae60 ffff88003711b218
Jun 20 23:35:27 midori kernel: ffff88003711b210 0000000000014940
0000000000014940 ffff88003716bfd8
Jun 20 23:35:27 midori kernel: Call Trace:
Jun 20 23:35:27 midori kernel: [<ffffffffa030bb9a>]
get_active_stripe+0x2c2/0x660 [raid456]
Jun 20 23:35:27 midori kernel: [<ffffffff81048abb>] ?
default_wake_function+0x0/0x14
Jun 20 23:35:27 midori kernel: [<ffffffffa030f2ba>]
make_request+0x21e/0x487 [raid456]
Jun 20 23:35:27 midori kernel: [<ffffffff8106799b>] ?
autoremove_wake_function+0x0/0x39
Jun 20 23:35:27 midori kernel: [<ffffffff81347c06>]
md_make_request+0xd4/0x1dc
Jun 20 23:35:27 midori kernel: [<ffffffff810c8ebf>] ?
mempool_alloc_slab+0x15/0x17
Jun 20 23:35:27 midori kernel: [<ffffffff810c8fad>] ?
mempool_alloc+0x71/0x12a
Jun 20 23:35:27 midori kernel: [<ffffffff811e3d2c>]
generic_make_request+0x2da/0x35e
Jun 20 23:35:27 midori kernel: [<ffffffff813537b1>] __map_bio+0xa2/0xfe
Jun 20 23:35:27 midori kernel: [<ffffffff81354fad>]
__split_and_process_bio+0x2a2/0x55e
Jun 20 23:35:27 midori kernel: [<ffffffff8100a60e>] ?
apic_timer_interrupt+0xe/0x20
Jun 20 23:35:27 midori kernel: [<ffffffff8135560f>] dm_wq_work+0x151/0x182
Jun 20 23:35:27 midori kernel: [<ffffffff813554be>] ? dm_wq_work+0x0/0x182
Jun 20 23:35:27 midori kernel: [<ffffffff810627c4>]
process_one_work+0x1a5/0x2b3
Jun 20 23:35:27 midori kernel: [<ffffffff810642a8>] worker_thread+0x145/0x226
Jun 20 23:35:27 midori kernel: [<ffffffff81064163>] ? worker_thread+0x0/0x226
Jun 20 23:35:27 midori kernel: [<ffffffff81067501>] kthread+0x82/0x8a
Jun 20 23:35:27 midori kernel: [<ffffffff8100aa64>]
kernel_thread_helper+0x4/0x10
Jun 20 23:35:27 midori kernel: [<ffffffff8106747f>] ? kthread+0x0/0x8a
Jun 20 23:35:27 midori kernel: [<ffffffff8100aa60>] ?
kernel_thread_helper+0x0/0x10
Jun 20 23:35:27 midori kernel: INFO: task jbd2/dm-0-8:1246 blocked for
more than 120 seconds.
..
Jun 20 23:37:41 midori kernel: <1>md/raid:md127: Operation continuing on 8
devices.
..
Jun 20 23:37:45 midori kernel: <1>md/raid:md127: Operation continuing on 7
devices.

------=_20110621165949_35665
Content-Type: text/plain; name="mann_md127.parts2.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mann_md127.parts2.txt"

linux-raid@vger.kernel.org

Neil Brown,

I've posted to your webpage (http://neil.brown.name/blog/20090817000931) in the past, so I hope you don't mind too much if I ask you for advice... even if your not overly interested since the array failed during "normal" use and not a conversion or grow.

I have a 10x2TB RAID6 array and I notice three drives have a different "Event id" than the other 7 drives does this imply I'm "out of luck?". *UPDATE* just noticed one of the three drives was a "spare" (why the same event id?)

Do you think the array will just "start up" if I try to assemble it? Minus 2drives?  Did the array not "freeze" after the 1st error?

I haven't tried anything yet... other than booting the machine after renaming the mdadm.conf file (I expected this to prevent the array from starting, however, a small 150G array started, maybe I needed to comment out the entries rather than rename the file).

I have 8 ST32000542AS drives hanging off an "AOC-SASLP-MV8" card and 4 others on the motherboard ports (boot+spare) I think the 8 on the raid-card drives went offline.  All drives appear to have come back after reboot.

I can provide you with more details, logs or even a "login" if you like.

Note: after the *update* comment (spare) things are looking less dire but any reassurance is appreciated.

Thank you,
-mann

mdadm -Evs
ARRAY /dev/md/127 level=raid6 metadata=1.2 num-devices=10 UUID=1747a894:8c1b4ea6:78d906f1:e0012a25 name=midori:127
   spares=1   devices=/dev/sdl1,/dev/sdk1,/dev/sdj1,/dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd3,/dev/sdb3,/dev/sdc3
ARRAY /dev/md/128 level=raid0 metadata=1.2 num-devices=6 UUID=b941a4ef:a119f0a7:5b9a19de:066487fd name=midori.gmind.org:128
   devices=/dev/sdl2,/dev/sdk2,/dev/sdj2,/dev/sdi2,/dev/sdh2,/dev/sdg2
   
cat /proc/mdstat
# at time of failure #
Personalities : [raid0] [raid6] [raid5] [raid4] 
md128 : active raid0 sdk2[5] sdl2[3] sdi2[2] sdg2[0] sdh2[1] sdj2[4]
      154263552 blocks super 1.2 512k chunks
      
md127 : active raid6 sdk1[8](F) sdi1[3](F) sdl1[7](F) sdf1[4](F) sdg1[6](F) sde1[2](F) sdh1[5](F) sdj1[0](F) sdb3[9] sdd3[11](S) sdc3[10]
      15422390272 blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/2] [________UU]
      
unused devices: <none>

# after reboot #
Personalities : [raid0] 
md126 : active raid0 sdl2[3] sdh2[1] sdk2[5] sdj2[4] sdg2[0] sdi2[2]
      154263552 blocks super 1.2 512k chunks
      
md127 : inactive sdf1[4](S) sdh1[5](S) sdb3[9](S) sdi1[3](S) sdj1[0](S) sdd3[11](S) sdl1[7](S) sde1[2](S) sdg1[6](S) sdk1[8](S) sdc3[10](S)
      21205788389 blocks super 1.2
       
unused devices: <none>


/dev/mapper/vg_media-lv_repo01:
        Version : 1.2
  Creation Time : Sun Oct  3 18:37:02 2010
     Raid Level : raid6
     Array Size : 15422357504 (14707.91 GiB 15792.49 GB)
  Used Dev Size : unknown
   Raid Devices : 10
  Total Devices : 11
    Persistence : Superblock is persistent

    Update Time : Tue Jun 21 00:15:45 2011
          State : clean, FAILED
 Active Devices : 2
Working Devices : 3
 Failed Devices : 8
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : midori:127
           UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
         Events : 120973

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       0        0        2      removed
       3       0        0        3      removed
       4       0        0        4      removed
       5       0        0        5      removed
       6       0        0        6      removed
       7       0        0        7      removed
       9       8       19        8      active sync   /dev/sdb3
      10       8       35        9      active sync   /dev/sdc3

       0       8      145        -      faulty spare   /dev/sdj1
       2       8       65        -      faulty spare   /dev/sde1
       3       8      129        -      faulty spare   /dev/sdi1
       4       8       81        -      faulty spare   /dev/sdf1
       5       8      113        -      faulty spare   /dev/sdh1
       6       8       97        -      faulty spare   /dev/sdg1
       7       8      177        -      faulty spare   /dev/sdl1
       8       8      161        -      faulty spare   /dev/sdk1
      11       8       51        -      spare   /dev/sdd3


/dev/sdf1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 4d6a2158:b7fa56b2:214613af:69af783c
       Checksum : 2510e6ed - correct
         Events : 120904
   Device Role : Active device 4
/dev/sdh1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : b2a48e12:796b2c18:376beed8:74596771
       Checksum : a41d6455 - correct
         Events : 120904
   Device Role : Active device 5
/dev/sdb3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : e3834a2e:f8949e75:b26d1c5b:8631dbd9
       Checksum : 7e35341 - correct
         Events : 121003
   Device Role : Active device 8
/dev/sdi1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : d9b17712:cd167319:c17dcfc3:d847fcd2
       Checksum : f1c31a9c - correct
         Events : 120904
   Device Role : Active device 3
/dev/sdj1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : f1cb78ca:df118e47:57ade846:740e0c47
       Checksum : cf0825f5 - correct
         Events : 120904
   Device Role : Active device 0
/dev/sdd3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : a166f386:a6aa95dc:7f7ea369:3226d7ff
       Checksum : fc065128 - correct
         Events : 121003
/dev/sdl1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 7e5d9ed7:13fe2b3e:acbe1b4a:1ab3f660
       Checksum : efe959b8 - correct
         Events : 120904
   Device Role : Active device 1
/dev/sde1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 3ee69896:cea55b57:229052b4:f5ca02cf
       Checksum : a0567380 - correct
         Events : 120904
   Device Role : Active device 2
/dev/sdg1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 1035f17d:79452818:33fd5c41:dcab73ab
       Checksum : b1f6aff8 - correct
         Events : 120904
   Device Role : Active device 6
/dev/sdk1:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : cafe0241:222eb745:0bf1d0f2:c66f0c09
       Checksum : b1a41a1f - correct
         Events : 120904
   Device Role : Active device 7
/dev/sdc3:
     Array UUID : 1747a894:8c1b4ea6:78d906f1:e0012a25
    Device UUID : 746265e7:475ba235:dc367ab3:82f482a4
       Checksum : a4078448 - correct
         Events : 121003
   Device Role : Active device 9



Jun 20 23:34:57 midori kernel: ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Jun 20 23:34:57 midori kernel: ata13: status=0x01 { Error }
Jun 20 23:34:57 midori kernel: ata13: error=0x04 { DriveStatusError }
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Sense Key : Aborted Command [current] [descriptor]
Jun 20 23:34:57 midori kernel: Descriptor sense data with sense descriptors (in hex):
Jun 20 23:34:57 midori kernel:        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jun 20 23:34:57 midori kernel:        00 00 00 56 
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Add. Sense: No additional sense information
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk] CDB: Write(10): 2a 00 a1 3f e0 3f 00 02 00 00
Jun 20 23:34:57 midori kernel: end_request: I/O error, dev sdk, sector 2705317951
Jun 20 23:34:57 midori kernel: md/raid:md127: Disk failure on sdk1, disabling device.
Jun 20 23:34:57 midori kernel: <1>md/raid:md127: Operation continuing on 9 devices.
Jun 20 23:34:57 midori kernel: ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Jun 20 23:34:57 midori kernel: ata13: status=0x01 { Error }
Jun 20 23:34:57 midori kernel: ata13: error=0x04 { DriveStatusError }
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Sense Key : Aborted Command [current] [descriptor]
Jun 20 23:34:57 midori kernel: Descriptor sense data with sense descriptors (in hex):
Jun 20 23:34:57 midori kernel:        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jun 20 23:34:57 midori kernel:        00 00 00 56 
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk]  Add. Sense: No additional sense information
Jun 20 23:34:57 midori kernel: sd 6:0:6:0: [sdk] CDB: Read(10): 28 00 a1 3f de 5f 00 01 e0 00
Jun 20 23:34:57 midori kernel: end_request: I/O error, dev sdk, sector 2705317471
Jun 20 23:35:27 midori kernel: INFO: task kworker/u:7:345 blocked for more than 120 seconds.
Jun 20 23:35:27 midori kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 23:35:27 midori kernel: kworker/u:7   D 0000000000000000     0   345      2 0x00000000
Jun 20 23:35:27 midori kernel: ffff88003716ba10 0000000000000046 ffff88003965aa00 ffff88003716a010
Jun 20 23:35:27 midori kernel: ffff88003716bfd8 0000000000014940 ffff88003711ae60 ffff88003711b218
Jun 20 23:35:27 midori kernel: ffff88003711b210 0000000000014940 0000000000014940 ffff88003716bfd8
Jun 20 23:35:27 midori kernel: Call Trace:
Jun 20 23:35:27 midori kernel: [<ffffffffa030bb9a>] get_active_stripe+0x2c2/0x660 [raid456]
Jun 20 23:35:27 midori kernel: [<ffffffff81048abb>] ? default_wake_function+0x0/0x14
Jun 20 23:35:27 midori kernel: [<ffffffffa030f2ba>] make_request+0x21e/0x487 [raid456]
Jun 20 23:35:27 midori kernel: [<ffffffff8106799b>] ? autoremove_wake_function+0x0/0x39
Jun 20 23:35:27 midori kernel: [<ffffffff81347c06>] md_make_request+0xd4/0x1dc
Jun 20 23:35:27 midori kernel: [<ffffffff810c8ebf>] ? mempool_alloc_slab+0x15/0x17
Jun 20 23:35:27 midori kernel: [<ffffffff810c8fad>] ? mempool_alloc+0x71/0x12a
Jun 20 23:35:27 midori kernel: [<ffffffff811e3d2c>] generic_make_request+0x2da/0x35e
Jun 20 23:35:27 midori kernel: [<ffffffff813537b1>] __map_bio+0xa2/0xfe
Jun 20 23:35:27 midori kernel: [<ffffffff81354fad>] __split_and_process_bio+0x2a2/0x55e
Jun 20 23:35:27 midori kernel: [<ffffffff8100a60e>] ? apic_timer_interrupt+0xe/0x20
Jun 20 23:35:27 midori kernel: [<ffffffff8135560f>] dm_wq_work+0x151/0x182
Jun 20 23:35:27 midori kernel: [<ffffffff813554be>] ? dm_wq_work+0x0/0x182
Jun 20 23:35:27 midori kernel: [<ffffffff810627c4>] process_one_work+0x1a5/0x2b3
Jun 20 23:35:27 midori kernel: [<ffffffff810642a8>] worker_thread+0x145/0x226
Jun 20 23:35:27 midori kernel: [<ffffffff81064163>] ? worker_thread+0x0/0x226
Jun 20 23:35:27 midori kernel: [<ffffffff81067501>] kthread+0x82/0x8a
Jun 20 23:35:27 midori kernel: [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
Jun 20 23:35:27 midori kernel: [<ffffffff8106747f>] ? kthread+0x0/0x8a
Jun 20 23:35:27 midori kernel: [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
Jun 20 23:35:27 midori kernel: INFO: task jbd2/dm-0-8:1246 blocked for more than 120 seconds.
..
Jun 20 23:37:41 midori kernel: <1>md/raid:md127: Operation continuing on 8 devices.
..
Jun 20 23:37:45 midori kernel: <1>md/raid:md127: Operation continuing on 7 devices.
------=_20110621165949_35665--


