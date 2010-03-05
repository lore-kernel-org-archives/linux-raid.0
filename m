From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Fri, 5 Mar 2010 10:24:55 -0500 (EST)
Message-ID: <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
    <20100305075016.51e98363@notabene.brown>
    <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
    <20100305123028.55a34c14@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100305102454_39885"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100305123028.55a34c14@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


------=_20100305102454_39885
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

On Thu, March 4, 2010 8:30 pm, Neil Brown wrote:
> Try this:
>
>
> cat /etc/fstab cat /etc/mdadm.conf mdadm -Esvv mdadm -Asv blkid -p /dev/md*
>
> And include all the output.

See attached.  Note that fstab is essentially irrelevant; I'd mounted by
hand, and was going to add the entry after I got the server back in the
server room.

> (sorry if I seem grumpy, but I'm a bit tired which makes it harder to
> appear polite).

Know what you mean; got four hours', myself, due to a virtualization
migration.

For the record, I've got my backup tapes ordered (again) -- if you can
tell me what I did wrong, that would be almost as satisfying as getting
the data back.

Thanks,

-Ken
-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


------=_20100305102454_39885
Content-Type: text/plain; name="fdisk.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="fdisk.txt"

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/md0: 4410.9 GB, 4410904805376 bytes
2 heads, 4 sectors/track, 1076881056 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

------=_20100305102454_39885
Content-Type: application/octet-stream; name="mdadm.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mdadm.conf"

IyBtZGFkbS5jb25mCiMKIyBQbGVhc2UgcmVmZXIgdG8gbWRhZG0uY29uZig1
KSBmb3IgaW5mb3JtYXRpb24gYWJvdXQgdGhpcyBmaWxlLgojCgojIGJ5IGRl
ZmF1bHQsIHNjYW4gYWxsIHBhcnRpdGlvbnMgKC9wcm9jL3BhcnRpdGlvbnMp
IGZvciBNRCBzdXBlcmJsb2Nrcy4KIyBhbHRlcm5hdGl2ZWx5LCBzcGVjaWZ5
IGRldmljZXMgdG8gc2NhbiwgdXNpbmcgd2lsZGNhcmRzIGlmIGRlc2lyZWQu
CkRFVklDRSBwYXJ0aXRpb25zCgojIGF1dG8tY3JlYXRlIGRldmljZXMgd2l0
aCBEZWJpYW4gc3RhbmRhcmQgcGVybWlzc2lvbnMKQ1JFQVRFIG93bmVyPXJv
b3QgZ3JvdXA9ZGlzayBtb2RlPTA2NjAgYXV0bz15ZXMKCiMgYXV0b21hdGlj
YWxseSB0YWcgbmV3IGFycmF5cyBhcyBiZWxvbmdpbmcgdG8gdGhlIGxvY2Fs
IHN5c3RlbQpIT01FSE9TVCA8c3lzdGVtPgoKIyBpbnN0cnVjdCB0aGUgbW9u
aXRvcmluZyBkYWVtb24gd2hlcmUgdG8gc2VuZCBtYWlsIGFsZXJ0cwpNQUlM
QUREUiByb290CgojIGRlZmluaXRpb25zIG9mIGV4aXN0aW5nIE1EIGFycmF5
cwoKQVJSQVkgL2Rldi9tZDAgbGV2ZWw9cmFpZDUgbnVtLWRldmljZXM9NCBV
VUlEPTFlODk2NDVhOjdlMjRkY2VmOjllNzdkNTRmOjA3N2E2YTZmCgojQVJS
QVkgL2Rldi9tZDAgbGV2ZWw9cmFpZDUgbnVtLWRldmljZXM9NCBkZXZpY2Vz
PXNkYTIsc2RiMixzZGQyLHNkYzIKCiMgVGhpcyBmaWxlIHdhcyBhdXRvLWdl
bmVyYXRlZCBvbiBUaHUsIDExIEZlYiAyMDEwIDIxOjU2OjE2ICswMDAwCiMg
YnkgbWtjb25mICRJZCQK

------=_20100305102454_39885
Content-Type: text/plain; name="mdadm-Asv.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mdadm-Asv.txt"

mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd1
mdadm: /dev/sdd1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: cannot open device /dev/loop1: Device or resource busy
mdadm: /dev/loop1 has wrong uuid.
mdadm: cannot open device /dev/loop0: Device or resource busy
mdadm: /dev/loop0 has wrong uuid.
mdadm: /dev/sdd2 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdc2 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdb2 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sda2 is identified as a member of /dev/md0, slot 2.
mdadm: added /dev/sdc2 to /dev/md0 as 1
mdadm: added /dev/sda2 to /dev/md0 as 2
mdadm: added /dev/sdd2 to /dev/md0 as 3
mdadm: added /dev/sdb2 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 4 drives.
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/block/9:0
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: cannot open device /dev/sdd2: Device or resource busy
mdadm: no recogniseable superblock on /dev/sdd1
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sdc2: Device or resource busy
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: cannot open device /dev/loop1: Device or resource busy
mdadm: cannot open device /dev/loop0: Device or resource busy
------=_20100305102454_39885
Content-Type: text/plain; name="mdadm-Esvv.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mdadm-Esvv.txt"

mdadm: No md superblock detected on /dev/block/9:0.
mdadm: No md superblock detected on /dev/sde1.
mdadm: No md superblock detected on /dev/sde.
mdadm: No md superblock detected on /dev/sdd1.
mdadm: No md superblock detected on /dev/sdd.
mdadm: No md superblock detected on /dev/sdc1.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdb1.
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sda1.
mdadm: No md superblock detected on /dev/sda.
mdadm: No md superblock detected on /dev/loop1.
mdadm: No md superblock detected on /dev/loop0.
/dev/sdd2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1e89645a:7e24dcef:9e77d54f:077a6a6f
  Creation Time : Thu Feb  4 20:54:58 2010
     Raid Level : raid5
  Used Dev Size : 1435841408 (1369.33 GiB 1470.30 GB)
     Array Size : 4307524224 (4107.98 GiB 4410.90 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar  5 07:04:06 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d85ef7b3 - correct
         Events : 35041

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       8        2        2      active sync   /dev/sda2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1e89645a:7e24dcef:9e77d54f:077a6a6f
  Creation Time : Thu Feb  4 20:54:58 2010
     Raid Level : raid5
  Used Dev Size : 1435841408 (1369.33 GiB 1470.30 GB)
     Array Size : 4307524224 (4107.98 GiB 4410.90 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar  5 07:04:06 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d85ef79f - correct
         Events : 35041

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       34        1      active sync   /dev/sdc2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       8        2        2      active sync   /dev/sda2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1e89645a:7e24dcef:9e77d54f:077a6a6f
  Creation Time : Thu Feb  4 20:54:58 2010
     Raid Level : raid5
  Used Dev Size : 1435841408 (1369.33 GiB 1470.30 GB)
     Array Size : 4307524224 (4107.98 GiB 4410.90 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar  5 07:04:06 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d85ef78d - correct
         Events : 35041

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       8        2        2      active sync   /dev/sda2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1e89645a:7e24dcef:9e77d54f:077a6a6f
  Creation Time : Thu Feb  4 20:54:58 2010
     Raid Level : raid5
  Used Dev Size : 1435841408 (1369.33 GiB 1470.30 GB)
     Array Size : 4307524224 (4107.98 GiB 4410.90 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Mar  5 07:04:06 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d85ef781 - correct
         Events : 35041

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8        2        2      active sync   /dev/sda2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8       34        1      active sync   /dev/sdc2
   2     2       8        2        2      active sync   /dev/sda2
   3     3       8       50        3      active sync   /dev/sdd2
------=_20100305102454_39885
Content-Type: text/plain; name="blkid.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="blkid.txt"

/dev/md0: UUID="d6158445-e38e-4942-9395-e1bd29935d22" TYPE="xfs" USAGE="filesystem" 
------=_20100305102454_39885--


