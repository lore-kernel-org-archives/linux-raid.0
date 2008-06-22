From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Why can't I stop these arrays?
Date: Sun, 22 Jun 2008 18:35:17 -0400
Message-ID: <20080622223517.GD5474@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am experimenting with various array configurations.  I have several
arrays running and I want to stop them.  They are not mounted; indeed,
they don't even have filesystems on them.  As far as I can tell, nothing
on the system is using them.

I have tried stopping the monitoring mdadm process, but I still cannot
stop the arrays.  (Although, if it was necessary to stop the monitoring
process for all arrays just to stop one of them, that would be a bug.)

There is a raid5 resyncing, which might be causing the problem (although
it shouldn't), but it needs hours to finish the resync.  Also, none of
the components in the raid5 array are in the arrays I want to stop, so
again, I don't see why there should be a problem.

(Though, md3 is also a raid5 and md5 is comprised of md3, so in some
sense md5 also "has something to do with" raid5.  Problem?)

Aside, how can I stop the resync to test if it is interferring?  Note,
the system is running of the resyncing raid5, so I need to stop the
resync but *not* stop the array.

Any advice?  Probably I've missed something obvious..


[root@server ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] [raid1] 
md5 : active raid1 md3[0]
      1952475584 blocks [2/1] [U_]
      
md3 : active raid5 sdd2[0] sdg2[3](S) sdf2[2] sde2[1]
      1952475648 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      
md0 : active raid1 sda1[0] sdb1[1]
      521984 blocks [3/2] [UU_]
      
md1 : active raid5 sdc2[3] sda2[0] sdb2[1]
      1952475648 blocks level 5, 256k chunk, algorithm 2 [3/2] [UU_]
      [=======>.............]  recovery = 35.9% (351008004/976237824)
finish=163.5min speed=63727K/sec
      
unused devices: <none>
[root@server ~]# mdadm --stop /dev/md5
mdadm: fail to stop array /dev/md5: Device or resource busy
[root@server ~]# mdadm --stop /dev/md3
mdadm: fail to stop array /dev/md3: Device or resource busy


Thanks,
Richard
