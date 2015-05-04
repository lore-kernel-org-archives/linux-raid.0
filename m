From: =?UTF-8?Q?J=C3=A9r=C3=B4me_Tytgat?= <jerome.tytgat@sioban.net>
Subject: Re: upgrade to jessie/newer kernel and mdadm problems
Date: Mon, 04 May 2015 15:07:32 +0200
Message-ID: <12c70e695369533b4e301872282ee045@webmail.sioban.net>
References: <55434A08.3050505@sioban.net> <5547691F.9060908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5547691F.9060908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I was leaving your case for people who know IMSM to pipe up, as I don't
> have any experience with it.  But the silence is deafening :-(

That's OK, a good guy (PascalHambourg) in the french debian forum was 
able to help me a lot.


> However, if you've been using the system in this degraded state, you
> will need to do the manual assembly with only the good partitions, then
> add the other partitions to rebuild each.

Yes, it was in use, but this what we done :

1. restoring the original mdadm.conf

2. modifying the DEVICE lines with this : DEVICE /dev/sdb?* /dev/sdc?*

3. updating initram: update-initramfs -u (got some errors but we ignored 
them, however I made two initrd to be failsafe)

4. rebooted, md126 was gone and md9 back. However all arrays had a 
partition marked as fail

5. rebuilded each partiton with mdadm /dev/mdX --add /dev/sdcX or mdadm 
/dev/mdX --add /dev/sdbX accordingly (sometimes, the failed partition 
was on sdb and sometimes on sdc, this scarried me as I thought I would 
loose everything if one drive failed).

6. rebuild was ok, I needed to remove the superblock on /dev/sdb and 
/dev/sdc because it looked like this (it contains Intel RAID data but my 
disk are softraid and we thought that was one origin of the problem):


<--------------------------------------------------------------------->
# mdadm -E /dev/sdb
mdmon: /dev/sdb is not attached to Intel(R) RAID controller.
mdmon: /dev/sdb is not attached to Intel(R) RAID controller.
/dev/sdb:
           Magic : Intel Raid ISM Cfg Sig.
         Version : 1.1.00
     Orig Family : 26b5a9e0
          Family : 26b5a9e0
      Generation : 00004db7
      Attributes : All supported
            UUID : d9cfa6d9:2a715e4f:1fbc2095:be342429
        Checksum : 261d2aed correct
     MPB Sectors : 1
           Disks : 2
    RAID Devices : 1

   Disk01 Serial : VFC100R10BE79D
           State : active
              Id : 00010000
     Usable Size : 488390862 (232.88 GiB 250.06 GB)

[raidlin]:
            UUID : 91449a9d:9242bfe9:d99bceb0:a59f9314
      RAID Level : 1
         Members : 2
           Slots : [UU]
     Failed disk : none
       This Slot : 1
      Array Size : 488390656 (232.88 GiB 250.06 GB)
    Per Dev Size : 488390656 (232.88 GiB 250.06 GB)
   Sector Offset : 0
     Num Stripes : 1907776
      Chunk Size : 64 KiB
        Reserved : 0
   Migrate State : idle
       Map State : normal
     Dirty State : dirty

   Disk00 Serial : VFC100R10BRKMD
           State : active
              Id : 00000000
     Usable Size : 488390862 (232.88 GiB 250.06 GB)
<--------------------------------------------------------------------->
# mdadm -E /dev/sdc
mdmon: /dev/sdc is not attached to Intel(R) RAID controller.
mdmon: /dev/sdc is not attached to Intel(R) RAID controller.
/dev/sdc:
           Magic : Intel Raid ISM Cfg Sig.
         Version : 1.1.00
     Orig Family : 26b5a9e0
          Family : 26b5a9e0
      Generation : 00004dbc
      Attributes : All supported
            UUID : d9cfa6d9:2a715e4f:1fbc2095:be342429
        Checksum : 261c2af2 correct
     MPB Sectors : 1
           Disks : 2
    RAID Devices : 1

   Disk00 Serial : VFC100R10BRKMD
           State : active
              Id : 00000000
     Usable Size : 488390862 (232.88 GiB 250.06 GB)

[raidlin]:
            UUID : 91449a9d:9242bfe9:d99bceb0:a59f9314
      RAID Level : 1
         Members : 2
           Slots : [UU]
     Failed disk : none
       This Slot : 0
      Array Size : 488390656 (232.88 GiB 250.06 GB)
    Per Dev Size : 488390656 (232.88 GiB 250.06 GB)
   Sector Offset : 0
     Num Stripes : 1907776
      Chunk Size : 64 KiB
        Reserved : 0
   Migrate State : idle
       Map State : normal
     Dirty State : clean

   Disk01 Serial : VFC100R10BE79D
           State : active
              Id : 00010000
     Usable Size : 488390862 (232.88 GiB 250.06 GB)
<--------------------------------------------------------------------->

7. So I rebooted into initramfs shell by editing GRUB command line to 
add "break" at the end of kernel line

8. stopped the raid (they was mounted accordingly to /proc/mdstat) : 
mdadm --stop --scan

9. removed the superblock on /dev/sdb and /dev/sdc : mdadm 
--zero-superblock --metadata=imsm /dev/sdb ; mdadm --zero-superblock 
--metadata=imsm /dev/sdc

This is what they look now :
<--------------------------------------------------------------------->
# mdadm -E /dev/sdb
/dev/sdb:
    MBR Magic : aa55
Partition[0] :       979902 sectors at           63 (type fd)
Partition[1] :      9767520 sectors at       979965 (type fd)
Partition[2] :      3903795 sectors at     10747485 (type fd)
Partition[3] :    473740785 sectors at     14651280 (type 05)
<--------------------------------------------------------------------->
# mdadm -E /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :       979902 sectors at           63 (type fd)
Partition[1] :      9767520 sectors at       979965 (type fd)
Partition[2] :      3903795 sectors at     10747485 (type fd)
Partition[3] :    473740785 sectors at     14651280 (type 05)
<--------------------------------------------------------------------->

10. rebooted, changed back DEVICE line in mdadm.conf to DEVICE 
partitions

The array looks like OK now.

Anyway, Should I upgrade to superblock 1.0 (or 1.2) ? If so, can I use 
your method do it in initramfs shell (because my system is live with 
active raid arrays) ?


Full thread there (in french, sorry): 
https://www.debian-fr.org/mise-a-jour-vers-jessie-et-mdadm-t51945.html
