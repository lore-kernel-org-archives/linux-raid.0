From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: lsraid reports wrong device list with online RAID5 array
Date: Sun, 7 Nov 2004 12:53:16 -0500
Message-ID: <200411071753.iA7HrLN05327@www.watkins-home.com>
References: <Pine.LNX.4.61.0411071240340.13212@ge.kalou.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411071240340.13212@ge.kalou.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Olivier Kaloudoff' <kalou@kalou.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raidtools are not recommended.  You should learn and use mdadm.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Olivier Kaloudoff
Sent: Sunday, November 07, 2004 6:46 AM
To: linux-raid@vger.kernel.org
Subject: lsraid reports wrong device list with online RAID5 array

Hi,


 	I noticed a weird behaviour for lsraid today, that I'm unable to 
understand yet ... Are the raidtools still maintained, or at least bugs 
corrected ?

 	here is what happens, as you can see, my /dev/md2 is 
composed of /dev/hda3, /dev/hdb3, /dev/hdc3, that are reported right while 
offline, but /dev/hdc3 is shown as /dev/null while online :-(


[root@ge raidtools-1.00.3]# raidstop /dev/md2

[root@ge raidtools-1.00.3]# ./lsraid -R -p | grep md2 -A 13
# md device [dev 9, 2] /dev/md2 queried offline
# Authoritative device is [dev 22, 3] /dev/hdc3
raiddev /dev/md2
         raid-level              5
         nr-raid-disks           3
         nr-spare-disks          0
         persistent-superblock   1
         chunk-size              128

         device          /dev/hda3
         raid-disk               0
         device          /dev/hdb3
         raid-disk               1
         device          /dev/hdc3
         raid-disk               2

[root@ge raidtools-1.00.3]# raidstart /dev/md2

[root@ge raidtools-1.00.3]# ./lsraid -R -p | grep md2 -A 13
#       /dev/md2
#       /dev/sda
#       /dev/sda1
#       /dev/sda2
#       /dev/sda3
#       /dev/hdc
#       /dev/hdc1
#       /dev/hdc2
#       /dev/hdc3
#       /dev/hda
#       /dev/hda1
#       /dev/hda2
#       /dev/hda3
#       /dev/hdb
--
# md device [dev 9, 2] /dev/md2 queried online
raiddev /dev/md2
         raid-level              5
         nr-raid-disks           3
         nr-spare-disks          0
         persistent-superblock   1
         chunk-size              128

         device          /dev/hda3
         raid-disk               0
         device          /dev/hdb3
         raid-disk               1
         device          /dev/null
         failed-disk             2


Additionnaly, you can see clearly that /dev/hdc3 is not in a failed state:


kalou@ge cat /proc/mdstat  | grep -A1 md2
md2 : active raid5 hdc3[2] hdb3[1] hda3[0]
       120246272 blocks level 5, 128k chunk, algorithm 0 [3/3] [UUU]





Olivier
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

