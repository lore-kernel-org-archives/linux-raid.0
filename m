From: Raz <raziebe@gmail.com>
Subject: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 15:59:47 +0200
Message-ID: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Hello
I need to configure 3xDAS'es, each with 12 disks.
All three DAS'es are connected to a single machine.
I have the following requirements (in this order of importance)
from the storage:

1. redundancy.
   having two disks failing in one raid5 breaks the entire raid. when
you have 30TB storage
   it is a disaster.

2. performance.
   My code eliminates Linux raid5/6 write penalty. I managed to do by
   manipulating xfs and patching linux raid5 a bit.

3. modularity ( a "grow" and it will be nice to have "shrink" )
   file system and volume must be able to grow. shrinking is possible
by unifying multiple file systems
   under unionfs or aufs.

4. Utilize storage size.

I assume each disk is 1TB.

Solution #1
			     raid0
 DAS1: raid5: D,D,D,D,D,D     |
       raid5: D,D,D,D,D,D     |
   			      |
 DAS2: raid5: D,D,D,D,D,D     |   xfs
       raid5: D,D,D,D,D,D     |
                              |
 DAS3: raid5: D,D,D,D,D,D     |
       raid5: D,D,D,D,D,D     |


1. redundancy. no. if a single raid fails, 30 TB fails.
2. performance. good.
3. modularity. no. raid0 does not grow.
4. Size.      30TB.

Solution #2
			     raid0
 DAS1: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |
   			      |
 DAS2: raid6: D,D,D,D,D,D     | xfs.
       raid6: D,D,D,D,D,D     |
                              |
 DAS3: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |


1. redundancy. fair. less likely three disks will break in a single raid.
2. performance. good.
3. modularity. no. raid0 does not grow.
4. size. 24 TB

Solution #3
			          unionfs/aufs
 DAS1: raid5: D,D,D,D,D,D     xfs   | 	
       raid5: D,D,D,D,D,D     xfs   |
   			            |
 DAS2: raid5: D,D,D,D,D,D     xfs   |
       raid5: D,D,D,D,D,D     xfs   |
                                    |
 DAS3: raid5: D,D,D,D,D,D     xfs   |
       raid5: D,D,D,D,D,D     xfs   |

1. redundancy. fair. if a single raid fails, only this raid fails.
2. performance. fair.
     unionfs is not mainline and does not support write balancing.
     aufs is not mature enough.
3. modularity. yes. grow and shrinks.
4. Size. 30TB.

Solution #4
			       xfs over Linux LVM
 DAS1: raid6: D,D,D,D,D,D         | 	
       raid6: D,D,D,D,D,D         |
   			          |
 DAS2: raid6: D,D,D,D,D,D         |
       raid6: D,D,D,D,D,D         |
                                  |
 DAS3: raid6: D,D,D,D,D,D         |
       raid6: D,D,D,D,D,D         |

1. redundancy. fair. less likely three disks will break in a single raid
2. performance. bad.
3. modularity. yes. grows
4. Size 24TB

Any other ideas ?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
