From: "Schmidt, Annemarie" <Annemarie.Schmidt@stratus.com>
Subject: md resync looping
Date: Fri, 20 May 2011 14:51:34 -0400
Message-ID: <5AA430FFE4486C448003201AC83BC85E01B03542@EXHQ.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On RH 6.1 system, I have a raid1 2-disk array:

>>[root@typhon ~]# mdadm --detail /dev/md21
/dev/md21:
        Version : 1.2
  Creation Time : Thu May 19 09:15:56 2011
   Raid Level : raid1
   Array Size : 5241844 (5.00 GiB 5.37 GB)
  Used Dev Size : 5241844 (5.00 GiB 5.37 GB)
   Raid Devices : 2
  Total Devices : 2
   Persistence : Superblock is persistent

  Intent Bitmap : Internal
...
    Number   Major   Minor   RaidDevice State
       0      65       18        0      active sync   /dev/sdc2
       1      65       50        1      active sync   /dev/sdk2

After starting I/O to the array, I pulled one of the disks. After
getting an error from the lower level scsi driver regarding an aborted
I/O, the array then went into a tight loop claiming to be resyncing:

05-20 11:01:57 end_request: I/O error, dev sdt, sector 11457968
05-20 11:01:57 md/raid1:md21: Disk failure on sdt2, disabling device.
05-20 11:01:57 md/raid1:md21: Operation continuing on 1 devices.
05-20 11:01:57 md: recovery of RAID array md21
05-20 11:01:57 md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
05-20 11:01:57 md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
05-20 11:01:57 md: using 128k window, over a total of 5241844 blocks.
05-20 11:01:57 md: resuming recovery of md21 from checkpoint.
05-20 11:01:57 md: md21: recovery done.
05-20 11:01:57 md: recovery of RAID array md21
05-20 11:01:57 md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
05-20 11:01:57 md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
05-20 11:01:57 md: using 128k window, over a total of 5241844 blocks.
05-20 11:01:57 md: resuming recovery of md21 from checkpoint.
05-20 11:01:57 md: md21: recovery done.
05-20 11:01:57 md: recovery of RAID array md21
05-20 11:01:57 md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
05-20 11:01:57 md: using maximum available idle IO bandwidth (but not
more than  200000 KB/sec) for recovery.
05-20 11:01:57 md: using 128k window, over a total of 5241844 blocks.
05-20 11:01:57 md: resuming recovery of md21 from checkpoint.
05-20 11:01:57 md: md21: recovery done.
05-20 11:01:57 md: recovery of RAID array md21
05-20 11:01:57 md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
05-20 11:01:57 md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
05-20 11:01:57 md: using 128k window, over a total of 5241844 blocks.
05-20 11:01:57 md: resuming recovery of md21 from checkpoint.
05-20 11:01:57 md: md21: recovery done.
05-20 11:01:57 md: recovery of RAID array md21
...
And on and on.

Has anyone else run into this?

I see that there were changes made to the remove_and_add_spares function
in md.c in RHEL 6.  I believe that one of these changes may be causing
the loop, specifically the first "if" statement.  The disk that was
pulled has been marked 'faulty' in the rdev->flags and its raid_disk
value is >= 0.  Since it is neither In-sync nor Blocked, spares gets
incremented and so md thinks there is a spare when in fact there is not.
In previous revs of md.c, the only way spares got incremented was
through the 2nd "if" statement which would not have been true in my
case:

 remove_and_add_spares:
               list_for_each_entry(rdev, &mddev->disks, same_set) {

                      ***********************************
                      if (rdev->raid_disk >= 0 &&
                            !test_bit(In_sync, &rdev->flags) &&
                            !test_bit(Blocked, &rdev->flags))
                                spares++;
                      ***********************************

                        if (rdev->raid_disk < 0
                            && !test_bit(Faulty, &rdev->flags)) {
                                rdev->recovery_offset = 0;
                                if (mddev->pers->
                                    hot_add_disk(mddev, rdev) == 0) {
                                        char nm[20];
                                        sprintf(nm, "rd%d",
rdev->raid_disk);
                                        if
(sysfs_create_link(&mddev->kobj,
 
&rdev->kobj, nm))
                                                /* failure here is OK
*/;
                                        spares++;
                                        md_new_event(mddev);
                                        set_bit(MD_CHANGE_DEVS,
&mddev->flags);
                                } else
                                        break;
                        }

Any comments on this?

Thanks,
Annemarie

