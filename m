From: "bart@ardistech.com" <bart@ardistech.com>
Subject: RAID5 attempt rebuilding despite being incomplete
Date: Thu, 23 Jun 2005 13:31:19 +0200
Message-ID: <42BA9D87.B6808FFC@ardistech.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have the problem that my RAID5 (created with 4 drives) array is resyning
despite the fact I removed one drive. Any Idea what it is doing?

To trigger this:
- Created RAID5 array with 4 partitions (no spares).
- Set one drive to fail with 'mdadm --fail /dev/md3 /dev/hdf4'
- Removed this drive with 'mdadm --remove /dev/md3 /dev/hdf4'

After this I get:

---------------------------------------------------

# mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.01
  Creation Time : Thu Jun 23 11:43:59 2005
     Raid Level : raid5
     Array Size : 228151872 (217.58 GiB 233.63 GB)
    Device Size : 76050624 (72.53 GiB 77.88 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Jun 23 12:26:19 2005
          State : active, degraded, resyncing
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 24% complete

           UUID : b9e2b624:b9bef9df:dcdec561:0c3a8dfd
         Events : 0.9

    Number   Major   Minor   RaidDevice State
       0       3        4        0      active sync   /dev/.static/dev/hda4
       1       3       68        1      active sync   /dev/.static/dev/hdb4
       2      33        4        2      active sync   /dev/.static/dev/hde4
       3       0        0        -      removed

--------------------------------------------------

and in /proc/mdstat is says:

--------------------------------------------------

md3 : active raid5 hde4[2] hdb4[1] hda4[0]
      228151872 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [=====>...............]  resync = 25.5% (19442692/76050624) finish=101.0min speed=9332K/sec

--------------------------------------------------

Removing all the drives seem leads to the array resyncing with 0 drives in
a loop, causing the /var/log/messages to grow at a rate of > 100MByte/sec :(

Isn't it a bug that the array starts resyning whithout checking if the
drives needed for a synced state are present?

	Bart
