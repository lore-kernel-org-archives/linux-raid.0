From: Erich Newell <erich.newell@gmail.com>
Subject: Data errors on clean, degraded Raid5. Help Please.
Date: Fri, 2 Dec 2005 02:52:08 +0000
Message-ID: <d39ad6430512011852g47d155a7i3f03db36996c01b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I apologize for being so verbose in my last post...it was late. My
problem again, in a more succinct form:

After a system crash during bootup, I attempted:
     > mdadm --add /dev/md0 /dev/sdb3

This caused the following:
  Number   Major   Minor   RaidDevice State
     0       8       51        0     active sync   /dev/sdd3
     1       8       35        1     active sync   /dev/sdc3
     2       0        0         -      removed
     3       0        0         -      removed
     4       8       19        -      spare   /dev/sdb3
     5       8        3         -      faulty   /dev/sda3

I then did:
     >mdadm --assemble --force /dev/md0

Which gave me:
    Number   Major   Minor   RaidDevice State
       0       8       51        0      active sync   /dev/sdd3
       1       8       35        1      active sync   /dev/sdc3
       0       0        0        0      removed
       3       8        3        3      active sync   /dev/sda3


Which generates errors when I try and copy off large amounts of data:
     About ten of these:
          ata1: translated ATA stat/err 0x25/00 to SCSI SK/ASC/ASCQ 0x4/00/00
          ata1: status=0x25 { DeviceFault CorrectedError Error }
          SCSI error : <0 0 0 0> return code = 0x8000002
          sda: Current: sense key: Hardware Error
          Additional sense: No additional sense information
          end_request: I/O error, dev sda, sector 489794513

     And a ton of these:
          EXT3-fs error (device md0): ext3_get_inode_loc: unable to
read inode block - inode=229379, block=458799

Yet fsck reports clean:
     > fsck -n /dev/md0
     fsck 1.38 (30-Jun-2005)
     e2fsck 1.38 (30-Jun-2005)
      /: clean, 514472/90718208 files, 114796878/181417968 blocks

Should I do this:
    > fsck -n -c /dev/md0
    > mdadm --assemble /dev/md0
    > mdadm --add /dev/md0 /dev/sdb3

or this:
     > mdadm -c /dev/md0 -l 5 -n 4 -x 0 -f /dev/sdd3 /dev/sdc3
/dev/sdb3 /dev/sda3
     > mdadm -S /dev/md0
     > mdadm --assemble --update=resync /dev/md0

or ???

If anyone has this knowledge, please share. I'm in over my head on this one.

Thanks in advance!

P.S. I am currently running a non-distructive badblock check while I
wait for expert advice:
> fsck -n -c -c /dev/md0
fsck 1.38 (30-Jun-2005)
e2fsck 1.38 (30-Jun-2005)
Checking for bad blocks (non-destructive read-write test)
Testing with random pattern:         4964224/      181417968
