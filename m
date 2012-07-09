From: Jan Engelhardt <jengelh@inai.de>
Subject: mdadm crash with lots of devs
Date: Mon, 9 Jul 2012 16:38:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207091635040.1330@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Using mdadm-3.2.2 from openSUSE_12.1:

# modprobe brd rd_size=1 rd_nr=4096
# mdadm -C /dev/md9 -l 10 -n 384 /dev/ram{0..383}
mdadm: Defaulting to version 1.2 metadata
Segmentation fault (core dumped)

#1  Create (st=0xb4c600, mddev=0x7fff3bda64c0 "/dev/md9", chunk=512, level=10, 
    layout=12593328, size=4, raiddisks=384, sparedisks=0, 
    name=0x7fff3bda64c7 "9", homehost=0x7fff3bda6fe0 "seven", uuid=0x0, 
    subdevs=384, devlist=0xb49030, runstop=0, verbose=0, force=0, 
    assume_clean=0, bitmap_file=0x0, bitmap_chunk=65534, write_behind=0, 
    delay=5, autof=0) at Create.c:899
899                                     fprintf(stderr,
(gdb) l
894                                                info_new.uuid, chosen_name);
895                                     me = map_by_devnum(&map, st->container_dev);
896                             }
897
898                             if (st->ss->write_init_super(st)) {
899                                     fprintf(stderr,
900                                             Name ": Failed to write metadata to %s\n",
901                                             dv->devname);
902                                     st->ss->free_super(st);
903                                     goto abort;
(gdb) p dv
$1 = <optimized out>
