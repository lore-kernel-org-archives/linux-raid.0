From: Kevin W Monroe <kwmonroe@linux.vnet.ibm.com>
Subject: mdadm --grow on raid1 returns nonzero
Date: Wed, 12 Oct 2011 18:27:46 -0500
Message-ID: <4E962272.8020003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

I'm trying to grow a raid1 array of 2 loop devices as a test. I created 
the array and successfully grew it, but mdadm --grow exits with a 
non-zero return code (1). I see the following in Grow.c's analyse_change():

if (info->new_level == 1) {
     if (info->delta_disks == UnSet)
         /* Don't know what to do */
         return "no change requested for Growing RAID1";
     re->level = 1;
     re->backup_blocks = 0;
     re->parity = 0;
     return NULL;
}

So my situation happens because info->delta_disks is UnSet. Is growing a 
raid1 array on the same underlying devices not a valid use case? Here's 
my setup/results:

[root@test-lpar01 ~]# mdadm --version
mdadm - v3.2.1 - 28th March 2011

[root@test-lpar01 ~]# dd if=/dev/zero of=1 bs=1024 count=10000
10000+0 records in
10000+0 records out
10240000 bytes (10 MB) copied, 0.341808 s, 30.0 MB/s
[root@test-lpar01 ~]# dd if=/dev/zero of=2 bs=1024 count=10000
10000+0 records in
10000+0 records out
10240000 bytes (10 MB) copied, 0.351076 s, 29.2 MB/s

[root@test-lpar01 ~]# losetup --show -f 1
/dev/loop0
[root@test-lpar01 ~]# losetup --show -f 2
/dev/loop1

[root@test-lpar01 ~]# mdadm -Cv /dev/md0 -l1 -n2 -z 5000 /dev/loop0 
/dev/loop1
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
mdadm: largest drive (/dev/loop0) exceeds size (5000K) by more than 1%
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

[root@test-lpar01 ~]# cat /proc/mdstat
Personalities : [raid0] [raid1]
md0 : active raid1 loop1[1] loop0[0]
       5000 blocks super 1.2 [2/2] [UU]

unused devices: <none>

[root@test-lpar01 ~]# mdadm --grow -z 7500 /dev/md0
mdadm: component size of /dev/md0 has been set to 7500K
mdadm: no change requested for Growing RAID1

[root@test-lpar01 ~]# echo $?
1

[root@test-lpar01 ~]# cat /proc/mdstat
Personalities : [raid0] [raid1]
md0 : active raid1 loop1[1] loop0[0]
       7500 blocks super 1.2 [2/2] [UU]

unused devices: <none>


You can see the array has grown, so I'm curious if the message "no 
change requested for Growing RAID1" from analyse_change should really be 
returned. Thanks,
-- 
Kevin Monroe

