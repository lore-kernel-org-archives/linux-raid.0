From: Steve Ungerer <steve@ungerer.us>
Subject: Read errors on raid5 device; array is still clean
Date: Wed, 13 Jan 2010 14:59:26 -0500
Message-ID: <4B4E261E.7070508@ungerer.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Hopefully this is an appropriate list to get a sanity check on my proposed actions to correct what I believe is a dying drive in my raid5 (4x1tb) array. If this is not the appropriate location, please feel free to heckle me.

A few days ago smartctl/smartmontools alerted me with a problem on /dev/sdc:
Device: /dev/sdc, 1 Offline uncorrectable sectors
Device: /dev/sdc, Self-Test Log error count increased from 0 to 1

I read the alert and promptly forgot about it until I was alerted last night to:
Device: /dev/sdc, 1 Currently unreadable (pending) sectors

My understanding of these messages is that there are bad sectors on the drive that cannot be reallocated. I took a look at the 'bad block howto' at http://smartmontools.sourceforge.net/badblockhowto.html but could not translate this information from the single device examples to a raid array.

From a read of the raid-administration page at http://www.linuxfoundation.org/collaborate/workgroups/linux-raid/raid_administration I issued a repair command to my array which I hoped would lead to sector reallocation. This led to lots of output like:
<snip>
Jan 13 10:50:28 RAID kernel: [3126305.778753] ata3.00: cmd 60/00:30:3f:39:4d/01:00:64:00:00/40 tag 6 ncq 131072 in
Jan 13 10:50:28 RAID kernel: [3126305.778754]          res 41/40:34:3f:39:4d/40:00:64:00:00/40 Emask 0x9 (media error)
Jan 13 10:50:28 RAID kernel: [3126305.778799] ata3.00: status: { DRDY ERR }
Jan 13 10:50:28 RAID kernel: [3126305.778812] ata3.00: error: { UNC }
Jan 13 10:50:28 RAID kernel: [3126305.778828] ata3: hard resetting link
Jan 13 10:50:29 RAID kernel: [3126306.680039] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 13 10:50:29 RAID kernel: [3126306.720221] ata3.00: configured for UDMA/133
Jan 13 10:50:29 RAID kernel: [3126306.720269] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
<snip>
Jan 13 10:50:29 RAID kernel: [3126306.720534] end_request: I/O error, dev sdc, sector 1682783039
Jan 13 10:50:29 RAID kernel: [3126306.720573] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 13 10:50:29 RAID kernel: [3126306.720576] sd 2:0:0:0: [sdc] Sense Key : Medium Error [current] [descriptor]
Jan 13 10:50:29 RAID kernel: [3126306.720578] Descriptor sense data with sense descriptors (in hex):
Jan 13 10:50:29 RAID kernel: [3126306.720580]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 13 10:50:29 RAID kernel: [3126306.720586]         64 4d 39 3f 
Jan 13 10:50:29 RAID kernel: [3126306.720588] sd 2:0:0:0: [sdc] Add. Sense: Unrecovered read error - auto reallocate failed
Jan 13 10:50:29 RAID kernel: [3126306.720591] end_request: I/O error, dev sdc, sector 1682782783
Jan 13 10:50:29 RAID kernel: [3126306.720631] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 13 10:50:29 RAID kernel: [3126306.720633] sd 2:0:0:0: [sdc] Sense Key : Medium Error [current] [descriptor]
Jan 13 10:50:29 RAID kernel: [3126306.720636] Descriptor sense data with sense descriptors (in hex):
Jan 13 10:50:29 RAID kernel: [3126306.720637]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 13 10:50:29 RAID kernel: [3126306.720643]         64 4d 39 3f 
Jan 13 10:50:29 RAID kernel: [3126306.720646] sd 2:0:0:0: [sdc] Add. Sense: Unrecovered read error - auto reallocate failed
Jan 13 10:50:29 RAID kernel: [3126306.720648] end_request: I/O error, dev sdc, sector 1682782527
Jan 13 10:50:29 RAID kernel: [3126306.720683] ata3: EH complete
Jan 13 10:50:29 RAID kernel: [3126306.720720] sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
Jan 13 10:50:29 RAID kernel: [3126306.720734] sd 2:0:0:0: [sdc] Write Protect is off
Jan 13 10:50:29 RAID kernel: [3126306.720736] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Jan 13 10:50:29 RAID kernel: [3126306.720755] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 13 10:50:29 RAID kernel: [3126306.733783] __ratelimit: 182 callbacks suppressed
Jan 13 10:50:29 RAID kernel: [3126306.733786] raid5:md0: read error corrected (8 sectors at 1682781184 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733790] raid5:md0: read error corrected (8 sectors at 1682781192 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733793] raid5:md0: read error corrected (8 sectors at 1682781200 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733795] raid5:md0: read error corrected (8 sectors at 1682781208 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733798] raid5:md0: read error corrected (8 sectors at 1682781216 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733800] raid5:md0: read error corrected (8 sectors at 1682781224 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733802] raid5:md0: read error corrected (8 sectors at 1682781232 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733809] raid5:md0: read error corrected (8 sectors at 1682781240 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733811] raid5:md0: read error corrected (8 sectors at 1682781248 on sdc1)
Jan 13 10:50:29 RAID kernel: [3126306.733814] raid5:md0: read error corrected (8 sectors at 1682781256 on sdc1)
</snip>

My first question: what exactly is going on here? /dev/sdc reports an unrecovered read error, md tries to reset the link, reattempts the read which still fails, recovers parity from the other drives in the array? Does anything happen to these bad sectors on sdc?

Seeing all these errors caused me to panic and issue the idle command to the repair. A check of the md array still shows it as clean with no drives failing. mdadm output:
/dev/md0:
        Version : 00.90
  Creation Time : Fri Jan  2 20:29:13 2009
     Raid Level : raid5
     Array Size : 2918399616 (2783.20 GiB 2988.44 GB)
  Used Dev Size : 972799872 (927.73 GiB 996.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 13 10:57:29 2010
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : b3352c3d:57e3388d:6efc78ec:daff395f (local to host RAID)
         Events : 0.54

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1


My plan is to replace this drive even though md has not failed it; better safe than sorry. To do so I will follow the steps outlined at http://www.linuxquestions.org/questions/linux-server-73/mdadm-raid-5-single-drive-failure-644325/#post3173822.

Is there anything I'm missing here? Is there the possibility I'm replacing a perfectly good drive and these errors are due to some software problem?

Your feedback is much appreciated.

--
Steve Ungerer
