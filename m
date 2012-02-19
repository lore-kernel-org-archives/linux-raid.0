From: eeeee <tw@qwe123.info>
Subject: mdadm segfaults on --grow
Date: Sun, 19 Feb 2012 07:35:08 +0400
Message-ID: <CAPkfHa4LzSC-mBrgKVCEGFuKg5ksOJmv6-ZMiqVnZHf+dRNeRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i'm doing
mdadm --grow /dev/md127 -l raid5 -n 6
and it segfaults!

mdadm-3.2.3

here is "bt full" from map_num which returns NULL to Grow.c:1298 and
causes a segfault from line 1300

#0  map_num (map=3D0x6822d0, num=3D18) at maps.c:136
No locals.
#1  0x00000000004235ba in analyse_change (info=3D0x7fffffffd750,
re=3D0x7fffffffd5a0) at Grow.c:1298
        layout =3D "\373zF\000\000\000\000\000\220\325\377\377\377\177"=
,
'\000' <repeats 18 times>"\230, \330\377\377\377\177\000"
        ls =3D 0x7fffffffd898 "md127"
        l =3D 32767
        new_disks =3D -10088
        delta_parity =3D -1
#2  0x0000000000424daa in reshape_array (container=3D0x0, fd=3D7,
devname=3D0x7fffffffe456 "/dev/md127", st=3D0x698270, info=3D0x7fffffff=
d750,
    force=3D0, devlist=3D0x0, backup_file=3D0x0, quiet=3D0, forked=3D0,
restart=3D0, freeze_reshape=3D0) at Grow.c:1919
        reshape =3D {level =3D 6, parity =3D 32767, before =3D {layout =
=3D 18,
data_disks =3D 5}, after =3D {layout =3D 118, data_disks =3D 0},
          backup_blocks =3D 34364313138, stripes =3D 127, new_size =3D =
4619003}
        spares_needed =3D 0
        msg =3D 0x698270 "\340'h"
        orig_level =3D 65534
        disks =3D 0
        odisks =3D 25008
        array =3D {major_version =3D 0, minor_version =3D 90, patch_ver=
sion
=3D 3, ctime =3D 1284750066, level =3D 6, size =3D 1953514496,
          nr_disks =3D 10, raid_disks =3D 7, md_minor =3D 127,
not_persistent =3D 0, utime =3D 1329619913, state =3D 1, active_disks =3D=
 7,
          working_disks =3D 10, failed_disks =3D 0, spare_disks =3D 3,
layout =3D 18, chunk_size =3D 524288}
        c =3D 0x0
        dv =3D 0x50000fffe
        added_disks =3D 0
        fdlist =3D 0x0
        offsets =3D 0x0
        d =3D 0
        nrdisks =3D 0
        err =3D 0
        blocks =3D 735819680
        cache =3D 1329620322
        array_size =3D 140737351862080
        done =3D 0
        sra =3D 0x0
#3  0x0000000000424b7d in Grow_reshape (devname=3D0x7fffffffe456
"/dev/md127", fd=3D7, quiet=3D0, backup_file=3D0x0, size=3D1953514496,
    level=3D5, layout_str=3D0x0, chunksize=3D0, raid_disks=3D6, devlist=
=3D0x0,
assume_clean=3D0, force=3D0) at Grow.c:1854
        array =3D {major_version =3D 0, minor_version =3D 90, patch_ver=
sion
=3D 3, ctime =3D 1284750066, level =3D 6, size =3D 1953514496,
          nr_disks =3D 10, raid_disks =3D 7, md_minor =3D 127,
not_persistent =3D 0, utime =3D 1329619913, state =3D 1, active_disks =3D=
 7,
          working_disks =3D 10, failed_disks =3D 0, spare_disks =3D 3,
layout =3D 18, chunk_size =3D 524288}
        rv =3D 0
        st =3D 0x698270
        subarray =3D 0x0
        frozen =3D 1
        changed =3D 0
        container =3D 0x0
        container_buf =3D '\000' <repeats 16 times>, "Xb\244",
<incomplete sequence \367>
        cfd =3D -1
        dv =3D 0x0
        added_disks =3D 0
        info =3D {array =3D {major_version =3D 0, minor_version =3D 90,
patch_version =3D 3, ctime =3D 1284750066, level =3D 6, size =3D 195351=
4496,
            nr_disks =3D 10, raid_disks =3D 7, md_minor =3D 127,
not_persistent =3D 0, utime =3D 1329619913, state =3D 1, active_disks =3D=
 7,
            working_disks =3D 10, failed_disks =3D 0, spare_disks =3D 3=
,
layout =3D 18, chunk_size =3D 524288}, disk =3D {number =3D 0, major =3D=
 0,
            minor =3D 0, raid_disk =3D 0, state =3D 0}, events =3D 0, u=
uid =3D
{0, 0, 0, 0}, name =3D '\000' <repeats 32 times>, data_offset =3D 0,
          component_size =3D 3907028992, custom_array_size =3D 0,
reshape_active =3D 0, reshape_progress =3D 0, recovery_blocked =3D 0, {
            resync_start =3D 0, recovery_start =3D 0}, bitmap_offset =3D=
 0,
safe_mode_delay =3D 0, new_level =3D 5, delta_disks =3D -1,
          new_layout =3D 18, new_chunk =3D 524288, errors =3D 0, cache_=
size
=3D 0, mismatch_cnt =3D 0,
          text_version =3D "0.90", '\000' <repeats 45 times>,
container_member =3D 0, container_enough =3D 0,
          sys_name =3D "md127", '\000' <repeats 14 times>, devs =3D 0x0=
,
next =3D 0x0, recovery_fd =3D 0, state_fd =3D 0, prev_state =3D 0,
          curr_state =3D 0, next_state =3D 0}
        sra =3D 0x698030
#4  0x0000000000407d78 in main (argc=3D7, argv=3D0x7fffffffe1a8) at mda=
dm.c:1688
        mode =3D 7
        opt =3D -1
        option_index =3D -1
        c =3D 0x7fffffffe46e ""
        rv =3D 0
        i =3D 0
        chunk =3D 0
        size =3D -1
        array_size =3D -1
        level =3D 5
        layout =3D 65534
        layout_str =3D 0x0
        raiddisks =3D 6
        sparedisks =3D 0
        ident =3D {devname =3D 0xffffefbd50d60000 <Address
0xffffefbd50d60000 out of bounds>, uuid_set =3D 0, uuid =3D {0, 0, 0,
-136424438},
          name =3D
"\000\177\000\000\000\000\000\000\000\000\000\000\240\336\377\377\377\1=
77\000\000\220\336\377\377\377\177\000\000Uu\307\001",
super_minor =3D 65534, devices =3D 0x0, level =3D 5, raid_disks =3D 6,
spare_disks =3D -136421905, st =3D 0x0, autof =3D 0,
          spare_group =3D 0x0, bitmap_file =3D 0x0, bitmap_fd =3D -1,
container =3D 0x0, member =3D 0x0, next =3D 0x7fffffffdf10, {
            assembled =3D -134227560}}
        configfile =3D 0x0
        cp =3D 0x7ffff7ffd998 ""
        update =3D 0x0
        scan =3D 0
        devmode =3D 0
        runstop =3D 0
        readonly =3D 0
        write_behind =3D 0
        bitmap_fd =3D -1
        bitmap_file =3D 0x0
        backup_file =3D 0x0
        invalid_backup =3D 0
        bitmap_chunk =3D 65534
        SparcAdjust =3D 0
        devlist =3D 0x698010
        devlistend =3D 0x698020
        dv =3D 0x698010
        devs_found =3D 1
        verbose =3D 0
        quiet =3D 0
        brief =3D 0
        force =3D 0
        test =3D 0
        export =3D 0
        assume_clean =3D 0
        symlinks =3D 0x0
        grow_continue =3D 0
        autof =3D 0
        homehost =3D 0x7fffffffdcd0 "localhost"
        sys_hostname =3D "localhost", '\000' <repeats 15 times>, "
\335\377\377\377\177\000\000\270\230\244\367\377\177\000\000\254\222\33=
6\367\377\177\000\000\000\001\001\367\377\177\000\000\003\000\000\000\0=
00\000\000\000\360\337\377\377\377\177\000\000=D2=9A\336\367\377\177\00=
0\000\230\331\377\367\377\177\000\000\000\000\000\000\000\000\000\000P\=
256\377\367\377\177\000\000X\246\377\367\377\177\000\000\364\307\335\36=
7\377\177\000\000\360\231\244\367\377\177\000\000\350\305\335\367\377\1=
77\000\000\000\000\000\000\001\000\000\000o\b\000\000\001\000\000\000\2=
40\337\377\377\377\177\000\000\260\337\377\377\377\177\000\000\000\346\=
377\367\377\177\000\000\360\336\377\377\377\177\000\000P\256\377\367\37=
7\177\000\000\260\337\377\377\377\177\000\000\207\360\226|\000\000\000\=
000\230\331\377\367\377\177\000\000R`\336\367\377\177\000\000\000\000\0=
00\000\000\000\000\000P\256\377\367\377\177\000\000\001",
'\000' <repeats 14 times>
        require_homehost =3D 1
        mailaddr =3D 0x0
        program =3D 0x0
        increments =3D 20
        delay =3D 0
        daemonise =3D 0
        pidfile =3D 0x0
        oneshot =3D 0
        spare_sharing =3D 1
        ss =3D 0x0
        writemostly =3D 0
        re_add =3D 0
        shortopt =3D 0x67d660
"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:"
        dosyslog =3D 0
        rebuild_map =3D 0
        subarray =3D 0x0
        remove_path =3D 0x0
        udev_filename =3D 0x0
        print_help =3D 0
        outf =3D 0x7ffff7ffab98
        mdfd =3D 7
        freeze_reshape =3D 0
        __func__ =3D "main"



raid configuration:


/dev/md127:
        Version : 0.90
  Creation Time : Fri Sep 17 23:01:06 2010
     Raid Level : raid6
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
   Raid Devices : 7
  Total Devices : 10
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Sun Feb 19 07:20:08 2012
          State : clean
 Active Devices : 7
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 3

         Layout : left-symmetric-6
     Chunk Size : 512K

           UUID : f863e0f0:f61a8534:26f86d66:2608b129
         Events : 0.2116614

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8      112        1      active sync   /dev/sdh
       2       8        0        2      active sync   /dev/sda
       3       8       48        3      active sync   /dev/sdd
       4       8       96        4      active sync   /dev/sdg
       5       8      160        5      active sync   /dev/sdk
       6       8       80        6      active sync   /dev/sdf

       7       8       64        -      spare   /dev/sde
       8       8      144        -      spare   /dev/sdj
       9       8       32        -      spare   /dev/sdc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
