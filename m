From: Claude Nobs <claudenobs@blunet.cc>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow. Recoverable?
Date: Thu, 24 Feb 2011 05:06:08 +0100
Message-ID: <AANLkTik=_WyyK-f94S+85moZKez=VKD2L6z1dRWk9YLr@mail.gmail.com>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
 <AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
 <20110220162509.2eb85a03@notabene.brown> <AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
 <20110221115303.4862e093@notabene.brown> <AANLkTimaemNqVwaLmqYCS+6fHCTVmAqzUe9RUh3rdhvc@mail.gmail.com>
 <20110223125338.2179dd78@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223125338.2179dd78@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 23, 2011 at 02:53, NeilBrown <neilb@suse.de> wrote:
> No - just the things you suggest.
> The Reshape pos'n is the address in the array where reshape was up to=
=2E
> You could try using 'debugfs' to have a look at the context of those =
blocks.
> Remember to divide this number by 4 to get an ext4fs block number (as=
suming
> 4K blocks).
>
> Use: =C2=A0 testb BLOCKNUMBER COUNT
>
> to see if the blocks were even allocated.
> Then
> =C2=A0 =C2=A0 =C2=A0 icheck BLOCKNUM
> on a few of the blocks to see what inode was using them.
> Then
> =C2=A0 =C2=A0 =C2=A0 ncheck INODE
> to find a path to that inode number.
>
>
> Feel free to report your results - particularly if you find anything =
helpful.

So... the reshape went through fine... /dev/md1 failed once more but
doing the same thing over seemed to work fine. i then instantly went
on to resync the array. this however did not go so well... it failed
twice at the exact same point (/dev/m1 failing again)... looking at
dmesg i got repeated :

[66289.326235] ata2.00: exception Emask 0x0 SAct 0x1fe1ff SErr 0x0 acti=
on 0x0
[66289.326247] ata2.00: irq_stat 0x40000008
[66289.326257] ata2.00: failed command: READ FPDMA QUEUED
[66289.326273] ata2.00: cmd 60/20:a0:20:64:5c/00:00:07:00:00/40 tag 20
ncq 16384 in
[66289.326276]          res 41/40:00:36:64:5c/00:00:07:00:00/40 Emask
0x409 (media error) <F>
[66289.326284] ata2.00: status: { DRDY ERR }
[66289.326290] ata2.00: error: { UNC }
[66289.334377] ata2.00: configured for UDMA/133
[66289.334478] sd 2:0:0:0: [sdf] Unhandled sense code
[66289.334486] sd 2:0:0:0: [sdf] Result: hostbyte=3DDID_OK driverbyte=3D=
DRIVER_SENSE
[66289.334499] sd 2:0:0:0: [sdf] Sense Key : Medium Error [current] [de=
scriptor]
[66289.334515] Descriptor sense data with sense descriptors (in hex):
[66289.334522]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[66289.334552]         07 5c 64 36
[66289.334566] sd 2:0:0:0: [sdf] Add. Sense: Unrecovered read error -
auto reallocate failed
[66289.334582] sd 2:0:0:0: [sdf] CDB: Read(10): 28 00 07 5c 64 20 00 00=
 20 00
[66289.334611] end_request: I/O error, dev sdf, sector 123495478

and smartctl data confirmed a dying /dev/sdf (part of /dev/md1) :

  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       10
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       2

did some further digging and copied (dd) the whole /dev/md1 to another
disk (/dev/sdd1). unearthing a total of 5 unrecoverable 4K blocks. if
only i had gone with the less secure non-degraded option you gave me.
:-)
however assembly with the copied disk fails :

bernstein@server:~$ sudo mdadm/mdadm -Avv /dev/md2 /dev/sda1 /dev/md0
/dev/sdd1 /dev/sdc1

mdadm: looking for devices for /dev/md2
mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/md0 is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md2, slot 2.

mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md2
mdadm: failed to add /dev/sdd1 to /dev/md2: Invalid argument
mdadm: added /dev/md0 to /dev/md2 as 3
mdadm: added /dev/sda1 to /dev/md2 as 4
mdadm: added /dev/sdc1 to /dev/md2 as 0

mdadm: /dev/md2 assembled from 3 drives - not enough to start the array=
=2E

and dmesg shows :

[22728.265365] md: md2 stopped.
[22728.271142] md: sdd1 does not have a valid v1.2 superblock, not impo=
rting!
[22728.271167] md: md_import_device returned -22
[22728.271524] md: bind<md0>
[22728.271854] md: bind<sda1>
[22728.272135] md: bind<sdc1>
[22728.295812] md: sdd1 does not have a valid v1.2 superblock, not impo=
rting!
[22728.295838] md: md_import_device returned -22

but mdadm --examine /dev/md1 /dev/sdd1 outputs exactly the same
superblock information for both devices (and apart from device uuid,
checksum, array slot, array state its identical to sdc1 & sda1) :

/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0

     Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
           Name : master:public
  Creation Time : Sat Jan 22 00:15:43 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
     Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3c7e2c3f:8b6c7c43:a0ce7e33:ad680bed

    Update Time : Wed Feb 23 19:34:36 2011
       Checksum : 2132964 - correct
         Events : 137715


         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 3 (0, 1, failed, 2, 3, 4)
   Array State : uuUuu 1 failed

does it fail because the device size of /dev/sdd1 & /dev/md1 differs
(normally reflected in the superblock) :
/dev/sdd1:

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
/dev/md1:

 Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)

or any other idea why it complains about an incorrect superblock?

i really hoped that cloning the defective device would get me back in
the game (guessing this is completely transparent to md and the
defective blocks will only corrupt the filesystem blocks and don't
interfere with md operation) but at this point it seems that restoring
from backup might be faster still.

thanks
claude

@neil sorry about the multiple messages...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
