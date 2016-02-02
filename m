From: Sarah Newman <srn@prgmr.com>
Subject: Bogus entry in mdadm bad blocks list and question about particular
 commit
Date: Tue, 2 Feb 2016 12:34:59 -0800
Message-ID: <56B112F3.9010609@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I added some more drives to a raid 1 last night where some devices had existing bad block entries. There was nothing of particular interest in
/var/log/messages. Afterwards there is:

$ sudo /sbin/mdadm --examine-badblocks /dev/sdl1
Bad-blocks on /dev/sdl1:
   11986270392325491 for 51 sectors

The total number of sectors on the drive is 3907029168.

The start sector in the bad blocks list is 2a95730cea9573 in hex, I don't know if that string has any special significance or not.

$ sudo /sbin/mdadm --examine /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x8

     Raid Level : raid1
   Raid Devices : 11

 Avail Dev Size : 20971368 (10.00 GiB 10.74 GB)
     Array Size : 10485632 (10.00 GiB 10.74 GB)
  Used Dev Size : 20971264 (10.00 GiB 10.74 GB)
   Super Offset : 20971504 sectors
   Unused Space : before=0 sectors, after=232 sectors
          State : clean

    Update Time : Tue Feb  2 10:50:33 2016
  Bad Block Log : 512 entries available at offset -8 sectors - bad blocks present.
       Checksum : 4092aabf - correct
         Events : 143560


   Device Role : Active device 9
   Array State : AAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

The kernel is built from the Xen4CentOS 3.18.21-17 kernel, but there are no changes related to md in the code.

I looked for differences in between 3.18.21 and stable 3.18.y and the only interesting thing looked like e9206476ace "md/raid1: submit_bio_wait()
returns 0 on success". I don't think that's a smoking gun for the bogus bad blocks entry. But without that commit, mdadm with bad blocks enabled is
completely broken if there are write errors such that successful writes are reported as errors and vice versa, is that correct?

Thanks, Sarah
