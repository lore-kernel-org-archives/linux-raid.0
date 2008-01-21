From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: array doesn't run even with --force
Date: Mon, 21 Jan 2008 00:53:14 -0200
Message-ID: <18324.2330.580360.676531@fisica.ufpr.br>
References: <18323.53416.900135.357320@fisica.ufpr.br>
	<18323.61892.577574.287408@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18323.61892.577574.287408@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 21 January 2008 12:13:
 >On Sunday January 20, carlos@fisica.ufpr.br wrote:
 >> I've got a raid5 array with 5 disks where 2 failed. The failures are
 >> occasional and only on a few sectors so I tried to assemble it with 4
 >> disks anyway:
 >> 
 >> # mdadm -A -f -R /dev/md<number> /dev/disk1 /dev/disk2 /dev/disk3 /dev/disk4
 >> 
 >> However mdadm complains that one of the disks has an out-of-date
 >> superblock and kicks it out, and then it cannot run the array with
 >> only 3 disks.
 >> 
 >> Shouldn't it adjust the superblock and assemble-run it anyway? That's
 >> what -f is for, no? This is with kernel 2.6.22.16 and mdadm 2.6.4.
 >
 >Please provide actual commands and actual output.
 >Also add "--verbose" to the assemble command
 >Also provide "--examine" for all devices.
 >Also provide any kernel log messages.

The command is

mdadm -A --verbose -f -R /dev/md3 /dev/sda4 /dev/sdc4 /dev/sde4 /dev/sdd4

The failed areas are sdb4 (which I didn't include above) and sdd4. I
did a "dd if=/dev/sdb4 of=/dev/hda4 bs=512 conv=noerror" and it
complained about roughly 10 bad sectors. I did "dd if=/dev/sdd4
of=/dev/hdc4 bs=512 conv=noerror" and there were no errors, that's why
I used sdd4 above. I tried to substitute hdc4 for sdd4, and hda4 for
sdb4, to no avail.

I don't have kernel logs because the failed area has /home and /var.
The double fault occurred during the holidays, so I don't know which
happened first. Below are the output of the command above and of
--examine.

mdadm: looking for devices for /dev/md3
mdadm: /dev/sda4 is identified as a member of /dev/md3, slot 0.
mdadm: /dev/sdc4 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sde4 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sdd4 is identified as a member of /dev/md3, slot 5.
mdadm: no uptodate device for slot 1 of /dev/md3
mdadm: added /dev/sdc4 to /dev/md3 as 2
mdadm: no uptodate device for slot 3 of /dev/md3
mdadm: added /dev/sde4 to /dev/md3 as 4
mdadm: added /dev/sdd4 to /dev/md3 as 5
mdadm: added /dev/sda4 to /dev/md3 as 0
mdadm: failed to RUN_ARRAY /dev/md3: Input/output error
mdadm: Not enough devices to start the array.

On screen it shows "kicking out of date..." for sdd4.

/dev/sda4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2f2f8327:375b4306:94521055:e3dc373b
  Creation Time : Tue May 11 16:03:35 2004
     Raid Level : raid5
  Used Dev Size : 70454400 (67.19 GiB 72.15 GB)
     Array Size : 281817600 (268.76 GiB 288.58 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Jan 16 16:00:53 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 16119868 - correct
         Events : 0.14967284

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        4        0      active sync   /dev/sda4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       0        0        1      active sync              <-  note the difference compared to sdc4
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       0        0        3      faulty removed
   4     4       8       68        4      active sync   /dev/sde4

/dev/sdc4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2f2f8327:375b4306:94521055:e3dc373b
  Creation Time : Tue May 11 16:03:35 2004
     Raid Level : raid5
  Used Dev Size : 70454400 (67.19 GiB 72.15 GB)
     Array Size : 281817600 (268.76 GiB 288.58 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Jan 16 16:00:53 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 1611988f - correct
         Events : 0.14967284

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       36        2      active sync   /dev/sdc4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       0        0        1      faulty removed
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       0        0        3      faulty removed
   4     4       8       68        4      active sync   /dev/sde4

/dev/sdd4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2f2f8327:375b4306:94521055:e3dc373b
  Creation Time : Tue May 11 16:03:35 2004
     Raid Level : raid5
  Used Dev Size : 70454400 (67.19 GiB 72.15 GB)
     Array Size : 281817600 (268.76 GiB 288.58 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 3

    Update Time : Fri Jan 11 18:45:17 2008
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 160b27ce - correct
         Events : 0.14967266

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     5       8       52        5      spare   /dev/sdd4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       0        0        1      faulty removed
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       0        0        3      faulty removed
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8       52        5      spare   /dev/sdd4

/dev/sde4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2f2f8327:375b4306:94521055:e3dc373b
  Creation Time : Tue May 11 16:03:35 2004
     Raid Level : raid5
  Used Dev Size : 70454400 (67.19 GiB 72.15 GB)
     Array Size : 281817600 (268.76 GiB 288.58 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Jan 16 16:00:53 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 161198b3 - correct
         Events : 0.14967284

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8       68        4      active sync   /dev/sde4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       0        0        1      faulty removed
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       0        0        3      faulty removed
   4     4       8       68        4      active sync   /dev/sde4
