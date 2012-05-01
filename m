From: Andrew Thrift <andrew@networklabs.co.nz>
Subject: Another corrupt RAID5
Date: Tue, 01 May 2012 18:34:10 +1200
Message-ID: <4F9F83E2.90407@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have had a working md raid5 configuration for a number of years now.  
Last year I rebuilt it in to a 2x Raid5 arrays as PV's for LVM2, which 
has been working great... Until I upgraded to Ubuntu 12.04 from 11.10.

I just noticed Christoph's post, and while my symptoms are very similar, 
they are also different. I will outline what happened below.

After the upgrade everything initially looked OK, however I noticed when 
I tried to list directory contents it would show nothing, and the logs 
would fill with IO errors e.g.:

Apr 30 22:54:41 blackbox kernel: [ 3648.798394] EXT4-fs error (device 
dm-0): __ext4_get_inode_loc:3657: inode #440926209: block 1763704864: 
comm smbd: unable to read itable block
Apr 30 22:54:41 blackbox kernel: [ 3648.799920] EXT4-fs (dm-0): previous 
I/O error to superblock detected
Apr 30 22:54:41 blackbox kernel: [ 3648.799935] EXT4-fs error (device 
dm-0): __ext4_get_inode_loc:3657: inode #440926209: block 1763704864: 
comm smbd: unable to read itable block
Apr 30 22:54:41 blackbox kernel: [ 3648.800026] EXT4-fs (dm-0): previous 
I/O error to superblock detected

I assumed that maybe the LSI2008 controller had maybe not spun up the 
drives properly, and gave the machine a reboot.  All appeared well now, 
so I left the machine.  However overnight the logs filled with:

May  1 00:09:37 blackbox kernel: [ 3712.741980] sd 9:0:3:0: [sdf] Device 
not ready
May  1 00:09:37 blackbox kernel: [ 3712.741985] sd 9:0:3:0: [sdf]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 00:09:37 blackbox kernel: [ 3712.741990] sd 9:0:3:0: [sdf]  Sense 
Key : Not Ready [current]
May  1 00:09:37 blackbox kernel: [ 3712.741995] sd 9:0:3:0: [sdf]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 00:09:37 blackbox kernel: [ 3712.742000] sd 9:0:3:0: [sdf] CDB: 
Read(10): 28 00 a9 d5 56 47 00 00 08 00
May  1 00:09:37 blackbox kernel: [ 3712.742011] end_request: I/O error, 
dev sdf, sector 2849330759
May  1 00:09:37 blackbox kernel: [ 3712.742120] sd 9:0:4:0: [sdg] Device 
not ready
May  1 00:09:37 blackbox kernel: [ 3712.742122] sd 9:0:4:0: [sdg]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 00:09:37 blackbox kernel: [ 3712.742126] sd 9:0:4:0: [sdg]  Sense 
Key : Not Ready [current]
May  1 00:09:37 blackbox kernel: [ 3712.742132] sd 9:0:4:0: [sdg]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 00:09:37 blackbox kernel: [ 3712.742136] sd 9:0:4:0: [sdg] CDB: 
Read(10): 28 00 a9 d5 56 47 00 00 08 00
May  1 00:09:37 blackbox kernel: [ 3712.742145] end_request: I/O error, 
dev sdg, sector 2849330759
May  1 00:09:37 blackbox kernel: [ 3712.742187] sd 9:0:5:0: [sdh] Device 
not ready
May  1 00:09:37 blackbox kernel: [ 3712.742189] sd 9:0:5:0: [sdh]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 00:09:37 blackbox kernel: [ 3712.742192] sd 9:0:5:0: [sdh]  Sense 
Key : Not Ready [current]
May  1 00:09:37 blackbox kernel: [ 3712.742196] sd 9:0:5:0: [sdh]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 00:09:37 blackbox kernel: [ 3712.742200] sd 9:0:5:0: [sdh] CDB: 
Read(10): 28 00 a9 d5 56 47 00 00 08 00
May  1 00:09:37 blackbox kernel: [ 3712.742208] end_request: I/O error, 
dev sdh, sector 2849330759
May  1 00:09:37 blackbox kernel: [ 3712.756852] md/raid:md0: Disk 
failure on sdh1, disabling device.
May  1 00:09:37 blackbox kernel: [ 3712.756854] md/raid:md0: Operation 
continuing on 3 devices.
May  1 00:09:37 blackbox kernel: [ 3712.756925] md/raid:md0: Disk 
failure on sdg1, disabling device.
May  1 00:09:37 blackbox kernel: [ 3712.756926] md/raid:md0: Operation 
continuing on 2 devices.
May  1 00:09:37 blackbox kernel: [ 3712.756985] md/raid:md0: Disk 
failure on sdf1, disabling device.
May  1 00:09:37 blackbox kernel: [ 3712.756986] md/raid:md0: Operation 
continuing on 1 devices.
May  1 00:09:37 blackbox kernel: [ 3712.757038] EXT4-fs error (device 
dm-0): ext4_read_inode_bitmap:161: comm nfsd: Cannot read inode bitmap - 
block_group = 32609, inode_bitmap = 1068498961
May  1 00:09:37 blackbox kernel: [ 3712.757083] EXT4-fs error (device 
dm-0) in ext4_new_inode:937: IO failure
May  1 00:09:37 blackbox kernel: [ 3712.863217] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.863222]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.863225]  disk 0, o:0, dev:sdf1
May  1 00:09:37 blackbox kernel: [ 3712.863227]  disk 1, o:0, dev:sdg1
May  1 00:09:37 blackbox kernel: [ 3712.863229]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.863231]  disk 3, o:0, dev:sdh1
May  1 00:09:37 blackbox kernel: [ 3712.864483] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.864487]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.864491]  disk 0, o:0, dev:sdf1
May  1 00:09:37 blackbox kernel: [ 3712.864493]  disk 1, o:0, dev:sdg1
May  1 00:09:37 blackbox kernel: [ 3712.864495]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.864501] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.864503]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.864505]  disk 0, o:0, dev:sdf1
May  1 00:09:37 blackbox kernel: [ 3712.864507]  disk 1, o:0, dev:sdg1
May  1 00:09:37 blackbox kernel: [ 3712.864508]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.869463] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.869467]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.869471]  disk 0, o:0, dev:sdf1
May  1 00:09:37 blackbox kernel: [ 3712.869473]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.869477] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.869479]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.869481]  disk 0, o:0, dev:sdf1
May  1 00:09:37 blackbox kernel: [ 3712.869483]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.869554] RAID conf printout:
May  1 00:09:37 blackbox kernel: [ 3712.869559]  --- level:5 rd:4 wd:1
May  1 00:09:37 blackbox kernel: [ 3712.869562]  disk 2, o:1, dev:sdi1
May  1 00:09:37 blackbox kernel: [ 3712.869578] Buffer I/O error on 
device dm-0, logical block 0
May  1 00:09:37 blackbox kernel: [ 3712.869613] lost page write due to 
I/O error on dm-0
May  1 00:09:42 blackbox kernel: [ 3718.213744] Aborting journal on 
device dm-0-8.
May  1 00:09:42 blackbox kernel: [ 3718.213828] Buffer I/O error on 
device dm-0, logical block 976781312
May  1 00:09:42 blackbox kernel: [ 3718.213867] lost page write due to 
I/O error on dm-0
May  1 00:09:42 blackbox kernel: [ 3718.213876] JBD2: I/O error detected 
when updating journal superblock for dm-0-8.
May  1 00:09:43 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md0, component device /dev/sdf1
May  1 00:09:49 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md0, component device /dev/sdg1
May  1 00:09:54 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md0, component device /dev/sdh1
May  1 05:55:38 blackbox kernel: [24453.921252] EXT4-fs (dm-0): previous 
I/O error to superblock detected
May  1 05:55:38 blackbox kernel: [24453.966924] Buffer I/O error on 
device dm-0, logical block 0
May  1 05:55:38 blackbox kernel: [24453.966960] lost page write due to 
I/O error on dm-0
May  1 05:55:38 blackbox kernel: [24453.966970] EXT4-fs error (device 
dm-0): ext4_journal_start_sb:327: Detected aborted journal
May  1 05:55:38 blackbox kernel: [24453.967025] EXT4-fs (dm-0): 
Remounting filesystem read-only
May  1 05:55:38 blackbox kernel: [24453.967057] EXT4-fs (dm-0): previous 
I/O error to superblock detected
May  1 05:55:38 blackbox kernel: [24453.967107] Buffer I/O error on 
device dm-0, logical block 0
May  1 05:55:38 blackbox kernel: [24453.967140] lost page write due to 
I/O error on dm-0
May  1 06:25:14 blackbox kernel: [26228.988963] Buffer I/O error on 
device dm-0, logical block 9250
May  1 06:25:14 blackbox kernel: [26228.989008] Buffer I/O error on 
device dm-0, logical block 9251
May  1 06:25:14 blackbox kernel: [26228.989044] Buffer I/O error on 
device dm-0, logical block 9252
May  1 06:25:14 blackbox kernel: [26228.989080] Buffer I/O error on 
device dm-0, logical block 9253
May  1 06:25:14 blackbox kernel: [26228.989116] Buffer I/O error on 
device dm-0, logical block 9254
May  1 06:25:14 blackbox kernel: [26228.989151] Buffer I/O error on 
device dm-0, logical block 9255
May  1 06:25:14 blackbox kernel: [26228.989186] Buffer I/O error on 
device dm-0, logical block 9256
May  1 06:25:14 blackbox kernel: [26228.989221] Buffer I/O error on 
device dm-0, logical block 9257
May  1 06:25:14 blackbox kernel: [26228.989256] Buffer I/O error on 
device dm-0, logical block 9258
May  1 06:25:14 blackbox kernel: [26228.989291] Buffer I/O error on 
device dm-0, logical block 9259
May  1 06:25:14 blackbox kernel: [26228.989345] EXT4-fs (dm-0): previous 
I/O error to superblock detected
May  1 06:25:14 blackbox kernel: [26229.070433] EXT4-fs error (device 
dm-0): ext4_readdir:173: inode #11: comm standard: path 
/media/store0/lost+found: directory contains a hole at offset 0
May  1 08:28:59 blackbox kernel: [33646.969601] journal commit I/O error
May  1 08:28:59 blackbox kernel: [33647.017036] Buffer I/O error on 
device dm-0, logical block 902299653
May  1 08:28:59 blackbox kernel: [33647.017107] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.017123] sd 9:0:2:0: [sde] Device 
not ready
May  1 08:28:59 blackbox kernel: [33647.017125] sd 9:0:2:0: [sde]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 08:28:59 blackbox kernel: [33647.017129] sd 9:0:2:0: [sde]  Sense 
Key : Not Ready [current]
May  1 08:28:59 blackbox kernel: [33647.017136] sd 9:0:2:0: [sde]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 08:28:59 blackbox kernel: [33647.017141] sd 9:0:2:0: [sde] CDB: 
Write(10): 2a 00 74 70 59 3f 00 00 08 00
May  1 08:28:59 blackbox kernel: [33647.017153] end_request: I/O error, 
dev sde, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.017188] end_request: I/O error, 
dev sde, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.017221] md: super_written gets 
error=-5, uptodate=0
May  1 08:28:59 blackbox kernel: [33647.017225] md/raid:md1: Disk 
failure on sde1, disabling device.
May  1 08:28:59 blackbox kernel: [33647.017226] md/raid:md1: Operation 
continuing on 2 devices.
May  1 08:28:59 blackbox kernel: [33647.017298] sd 9:0:0:0: [sdc] Device 
not ready
May  1 08:28:59 blackbox kernel: [33647.017300] sd 9:0:0:0: [sdc]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 08:28:59 blackbox kernel: [33647.017303] sd 9:0:0:0: [sdc]  Sense 
Key : Not Ready [current]
May  1 08:28:59 blackbox kernel: [33647.017307] sd 9:0:0:0: [sdc]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 08:28:59 blackbox kernel: [33647.017312] sd 9:0:0:0: [sdc] CDB: 
Write(10): 2a 00 74 70 59 3f 00 00 08 00
May  1 08:28:59 blackbox kernel: [33647.017320] end_request: I/O error, 
dev sdc, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.017354] end_request: I/O error, 
dev sdc, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.017386] md: super_written gets 
error=-5, uptodate=0
May  1 08:28:59 blackbox kernel: [33647.017389] md/raid:md1: Disk 
failure on sdc1, disabling device.
May  1 08:28:59 blackbox kernel: [33647.017390] md/raid:md1: Operation 
continuing on 1 devices.
May  1 08:28:59 blackbox kernel: [33647.017455] sd 9:0:1:0: [sdd] Device 
not ready
May  1 08:28:59 blackbox kernel: [33647.017457] sd 9:0:1:0: [sdd]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  1 08:28:59 blackbox kernel: [33647.017461] sd 9:0:1:0: [sdd]  Sense 
Key : Not Ready [current]
May  1 08:28:59 blackbox kernel: [33647.017464] sd 9:0:1:0: [sdd]  Add. 
Sense: Logical unit not ready, initializing command required
May  1 08:28:59 blackbox kernel: [33647.017468] sd 9:0:1:0: [sdd] CDB: 
Write(10): 2a 00 74 70 59 3f 00 00 08 00
May  1 08:28:59 blackbox kernel: [33647.017476] end_request: I/O error, 
dev sdd, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.017509] end_request: I/O error, 
dev sdd, sector 1953519935
May  1 08:28:59 blackbox kernel: [33647.018544] md: super_written gets 
error=-5, uptodate=0
May  1 08:28:59 blackbox kernel: [33647.018547] md/raid:md1: Disk 
failure on sdd1, disabling device.
May  1 08:28:59 blackbox kernel: [33647.018548] md/raid:md1: Operation 
continuing on 0 devices.
May  1 08:28:59 blackbox kernel: [33647.020709] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.020714]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.020718]  disk 0, o:0, dev:sdc1
May  1 08:28:59 blackbox kernel: [33647.020722]  disk 1, o:0, dev:sde1
May  1 08:28:59 blackbox kernel: [33647.020726]  disk 2, o:0, dev:sdd1
May  1 08:28:59 blackbox kernel: [33647.067507] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.067512]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.067515]  disk 0, o:0, dev:sdc1
May  1 08:28:59 blackbox kernel: [33647.067517]  disk 2, o:0, dev:sdd1
May  1 08:28:59 blackbox kernel: [33647.067523] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.067525]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.067527]  disk 0, o:0, dev:sdc1
May  1 08:28:59 blackbox kernel: [33647.067529]  disk 2, o:0, dev:sdd1
May  1 08:28:59 blackbox kernel: [33647.127449] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.127453]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.127456]  disk 2, o:0, dev:sdd1
May  1 08:28:59 blackbox kernel: [33647.127461] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.127463]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.127465]  disk 2, o:0, dev:sdd1
May  1 08:28:59 blackbox kernel: [33647.167454] RAID conf printout:
May  1 08:28:59 blackbox kernel: [33647.167459]  --- level:5 rd:3 wd:0
May  1 08:28:59 blackbox kernel: [33647.167474] Buffer I/O error on 
device dm-0, logical block 1714946056
May  1 08:28:59 blackbox kernel: [33647.168557] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.168641] Buffer I/O error on 
device dm-0, logical block 1714946057
May  1 08:28:59 blackbox kernel: [33647.170230] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.170298] Buffer I/O error on 
device dm-0, logical block 1714946058
May  1 08:28:59 blackbox kernel: [33647.171896] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.171962] Buffer I/O error on 
device dm-0, logical block 1714946059
May  1 08:28:59 blackbox kernel: [33647.173396] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.173486] Buffer I/O error on 
device dm-0, logical block 1714946061
May  1 08:28:59 blackbox kernel: [33647.174512] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.174575] Buffer I/O error on 
device dm-0, logical block 1714946060
May  1 08:28:59 blackbox kernel: [33647.174605] Buffer I/O error on 
device dm-0, logical block 902467307
May  1 08:28:59 blackbox kernel: [33647.174608] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.176545] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.176646] Buffer I/O error on 
device dm-0, logical block 999292932
May  1 08:28:59 blackbox kernel: [33647.177560] lost page write due to 
I/O error on dm-0
May  1 08:28:59 blackbox kernel: [33647.177738] EXT4-fs (dm-0): previous 
I/O error to superblock detected
May  1 08:28:59 blackbox kernel: [33647.178680] EXT4-fs error (device 
dm-0): ext4_put_super:818: Couldn't clean up the journal
May  1 08:29:06 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md1, component device /dev/sdc1
May  1 08:29:11 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md1, component device /dev/sde1
May  1 08:29:17 blackbox mdadm[1876]: Fail event detected on md device 
/dev/md1, component device /dev/sdd1

And the /dev/md0 array is now corrupt.   The /dev/md1 array appears 
fine, but obviously without the /dev/md0 that the LV was spanned across 
it is not usable.

Each drive that was previously in /dev/md0 has the following output:

mdadm --examine /dev/sdh1
/dev/sdh1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 00000000:00000000:00000000:00000000
   Creation Time : Tue May  1 14:44:06 2012
      Raid Level : -unknown-
    Raid Devices : 0
   Total Devices : 2
Preferred Minor : 0

     Update Time : Tue May  1 16:24:56 2012
           State : active
  Active Devices : 0
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 2
        Checksum : bccafbfb - correct
          Events : 1


       Number   Major   Minor   RaidDevice State
this     0       8      113        0      spare   /dev/sdh1

    0     0       8      113        0      spare   /dev/sdh1
    1     1       8       81        1      spare   /dev/sdf1


e.g. Raid Level is -unknown- and the UUID is 
00000000:00000000:00000000:00000000

This appears to be a quite major bug, is this known, and is there any 
way I can recover my data ?



Regards,








Andrew


