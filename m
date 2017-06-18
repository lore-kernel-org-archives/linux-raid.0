From: "r23@anchordrop.net" <r23@anchordrop.net>
Subject: Re: raid-1 starting with 1 drive after brief hiatus with cruddy
 controller.
Date: Sun, 18 Jun 2017 12:08:10 -0400
Message-ID: <20170618120810.1e3ffe2d@e20>
References: <20170618001410.6fa96469@e20>
        <5946867B.5010200@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5946867B.5010200@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I have 2 scenarios here:

scenario 1- I tried the argument 'missing'. I think its taking that as a literal device name. I'm
probably not doing it like your asking.

root@mars:~# 
root@mars:~# mdadm --manage --stop /dev/md0              
mdadm: error opening /dev/md0: No such file or directory
root@mars:~# ls -lR /dev | grep md
lrwxrwxrwx  1 root root            25 Jun 18 11:52 initctl -> /run/systemd/initctl/fifo
lrwxrwxrwx  1 root root            28 Jun 18 11:52 log -> /run/systemd/journal/dev-log
drwxr-xr-x  2 root root            40 Jun 18 07:52 md
/dev/md:
root@mars:~#  mdadm --assemble /dev/md/debian:0  -v --run /dev/sdb2 missing
mdadm: looking for devices for /dev/md/debian:0
mdadm: cannot open device missing: No such file or directory
mdadm: missing has no superblock - assembly aborted
root@mars:~#


Scenario 2: - trying to explicitly add the good disk:

1) examine /dev/sdb2 
2)  mdadm --assemble /dev/md/md0  -v --run /dev/sdb2  : result = failed to add /dev/sdb2 to /dev/md/md0: Invalid argument
3) mdadm --manage /dev/md0 -v --add  /dev/sdb2 : result  =  mdadm: Cannot get array info for /dev/md0
4) mdadm --detail -v /dev/md0  = result = raid0 ??

detail on above 4 steps:

root@mars:~# 
root@mars:~# mdadm --misc --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 2a3489a6:b430c744:2c89a792:98521913
           Name : debian:0
  Creation Time : Sat May  9 17:44:25 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 9765179392 (4656.40 GiB 4999.77 GB)
     Array Size : 4882589696 (4656.40 GiB 4999.77 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 4697b088:5d3b1ae5:55d30f65:516df63d

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jun 14 23:53:27 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1f245410 - expected 1f249410
         Events : 129099


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
root@mars:~# mdadm --assemble /dev/md/md0  -v --run /dev/sdb2
mdadm: looking for devices for /dev/md/md0
mdadm: /dev/sdb2 is identified as a member of /dev/md/md0, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md/md0
mdadm: failed to add /dev/sdb2 to /dev/md/md0: Invalid argument
mdadm: failed to RUN_ARRAY /dev/md/md0: Invalid argument
root@mars:~# ls -lR /dev | grep md
lrwxrwxrwx  1 root root            25 Jun 18 11:52 initctl -> /run/systemd/initctl/fifo
lrwxrwxrwx  1 root root            28 Jun 18 11:52 log -> /run/systemd/journal/dev-log
drwxr-xr-x  2 root root            40 Jun 18 07:52 md
brw-rw----  1 root disk        9,   0 Jun 18 11:57 md0
lrwxrwxrwx 1 root root 6 Jun 18 11:57 9:0 -> ../md0
/dev/md:
root@mars:~# mdadm --manage /dev/md0 -v --add  /dev/sdb2
mdadm: Cannot get array info for /dev/md0
root@mars:~# mdadm --detail -v /dev/md0
/dev/md0:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 0
    Persistence : Superblock is persistent

          State : inactive

    Number   Major   Minor   RaidDevice
root@mars:~# 





