From: Pallai Roland <dap@mail.index.hu>
Subject: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Thu, 24 May 2007 13:18:30 +0200
Message-ID: <200705241318.30711.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

 I wondering why the md raid5 does accept writes after 2 disks failed. I've an 
array built from 7 drives, filesystem is XFS. Yesterday, an IDE cable failed 
(my friend kicked it off from the box on the floor:) and 2 disks have been 
kicked but my download (yafc) not stopped, it tried and could write the file 
system for whole night!
 Now I changed the cable, tried to reassembly the array (mdadm -f --run), 
event counter increased from 4908158 up to 4929612 on the failed disks, but I 
cannot mount the file system and the 'xfs_repair -n' shows lot of errors 
there. This is expainable by the partially successed writes. Ext3 and JFS 
has "error=" mount option to switch filesystem read-only on any error, but 
XFS hasn't: why? It's a good question too, but I think the md layer could 
save dumb filesystems like XFS if denies writes after 2 disks are failed, and 
I cannot see a good reason why it's not behave this way.

 Do you have better idea how can I avoid such filesystem corruptions in the 
future? No, I don't want to use ext3 on this box. :)


my mount error:
XFS: Log inconsistent (didn't find previous header)
XFS: failed to find log head
XFS: log mount/recovery failed: error 5
XFS: log mount failed


--
 d

