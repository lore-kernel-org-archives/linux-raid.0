From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 0/2] Can't grow size twice for a super1.0 array
Date: Tue, 30 Jun 2020 15:55:35 +0800
Message-ID: <1593503737-5067-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

Hi all

This are the test steps:
[root@storageqe-54 ~]# mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 -e 1.0 --size=1G
[root@storageqe-54 ~]# mdadm --wait /dev/md0
[root@storageqe-54 ~]# mdadm -G /dev/md0 --size=5G
mdadm: component size of /dev/md0 has been set to 5242880K
[root@storageqe-54 ~]# mdadm --wait /dev/md0
[root@storageqe-54 ~]# mdadm -G /dev/md0 --size=6G
mdadm: Cannot set device size for /dev/md0: No space left on device

loop0                                    7:0    0   7.8G  0 loop  
└─md0                                    9:0    0     5G  0 raid1 
loop1                                    7:1    0   7.8G  0 loop  
└─md0                                    9:0    0     5G  0 raid1 

The reason is that it calcluates the max usable space in a wrong way for super1.0 array.
It uses rdev->sectors to calcuate the max usable space rather than the whole disk size.
At first it grow size and it's successful. Because rdev->sectors is set to the whole disk
size when creating raid device. super_1_load sets rdev->sectors to sb->data_size. In mdadm
it sets sb->data_size to the whole disk size rathan than the raid device size. I think it's
a wrong place too. Because of this error, it can grow size successfully at the first time.

It re-sets rdev->sectors to real raid device after reshaping to the new size. So it can't
grow size anymore.

Xiao Ni (2):
  super1.0 calculates max sectors in a wrong way
  Don't need to reset superblock start address for super1.0

 drivers/md/md.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

-- 
2.7.5
