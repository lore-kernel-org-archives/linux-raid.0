From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 16:41:00 +0200
Message-ID: <4E7F3D7C.3060705@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <4E7F297C.9070403@turmel.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F297C.9070403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/11 3:15 PM, Phil Turmel wrote:


> I'm sorry, Marcin, but you shouldn't expect to get your data back.  Per your "mdadm -D" report, the rebuild was already 63% done, so the destruction of your data is certainly complete now.

What I don't understand is I still have the LVM info. It's just the LVs 
don't have partition table stored anymore:

# pvdisplay
     Logging initialised at Sun Sep 25 16:38:43 2011
     Set umask from 0022 to 0077
     Scanning for physical volume names
   --- Physical volume ---
   PV Name               /dev/md0
   VG Name               fridge
   PV Size               5.46 TiB / not usable 3.00 MiB
   Allocatable           yes
   PE Size               4.00 MiB
   Total PE              1430793
   Free PE               102153
   Allocated PE          1328640
   PV UUID               Ubx1OW-jCyN-Vcy2-4p2W-L6Qb-u6W8-cVkrE4

# vgdisplay
     Logging initialised at Sun Sep 25 16:40:12 2011
     Set umask from 0022 to 0077
     Finding all volume groups
     Finding volume group "fridge"
   --- Volume group ---
   VG Name               fridge
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  33
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                7
   Open LV               0
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               5.46 TiB
   PE Size               4.00 MiB
   Total PE              1430793
   Alloc PE / Size       1328640 / 5.07 TiB
   Free  PE / Size       102153 / 399.04 GiB
   VG UUID               ZD2fsN-dFq4-PcMB-owRh-WxGs-ciK8-PPwPbd

# lvdisplay
     Logging initialised at Sun Sep 25 16:40:30 2011
     Set umask from 0022 to 0077
     Finding all logical volumes
   --- Logical volume ---
   LV Name                /dev/fridge/storage
   VG Name                fridge
   LV UUID                kIhbSq-hePX-UIVv-uuiP-iK6w-djcz-iQ3cEI
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                4.88 TiB
   Current LE             1280000
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:0

   --- Logical volume ---
   LV Name                /dev/fridge/webstorage
   VG Name                fridge
   LV UUID                PuCGo1-LkRa-doEI-n8qU-mqS3-20Cw-SICWPk
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                100.00 GiB
   Current LE             25600
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:1

   --- Logical volume ---
   LV Name                /dev/fridge/mailstorage
   VG Name                fridge
   LV UUID                538TGs-fRYt-VT1n-r8jE-Uvv3-nNXl-Cf8ojP
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                30.00 GiB
   Current LE             7680
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:2

   --- Logical volume ---
   LV Name                /dev/fridge/web01
   VG Name                fridge
   LV UUID                NsABmI-ok5I-GCaE-yGV6-Dqp6-Qedz-jVDS6Y
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                10.00 GiB
   Current LE             2560
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:3

   --- Logical volume ---
   LV Name                /dev/fridge/db01
   VG Name                fridge
   LV UUID                qa88nB-MqX8-25YN-MEqf-ln81-vNtP-w2yVMW
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                10.00 GiB
   Current LE             2560
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:4

   --- Logical volume ---
   LV Name                /dev/fridge/mail01
   VG Name                fridge
   LV UUID                qxUbLd-SaDq-wCwd-Z5M6-2llk-8SJh-vTlruR
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                10.00 GiB
   Current LE             2560
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:5

   --- Logical volume ---
   LV Name                /dev/fridge/win8
   VG Name                fridge
   LV UUID                TPsBeN-Nj2o-w1mt-pkS8-d9zu-wCMm-vRv3e7
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                30.00 GiB
   Current LE             7680
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:6



-- 

Marcin M. Jessa
