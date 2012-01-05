From: "Peter W. Morreale" <morreale@sgi.com>
Subject: implications of partitioning and raid
Date: Thu, 5 Jan 2012 08:40:34 -0700
Message-ID: <1325778034.4777.44.camel@hermosa.lnx.copansys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I'm wondering what the implications are for having multiple raid sets on
a partitioned disk wrt to disk failures. 

For example, suppose I create two partitions on a set of disks and
create raid sets on those partitions.  Further, not all raid sets
reference the same disks.  IOW, md0 references disks 1 and 2, and md1
references disk 1 and 3.  (overly simplistic for discussion purposes)

Assume a portion of disk 1 goes 'bad' (localized within one of those
partitions), is noticed by md and a rebuild is warranted.  

What is the behavior?  

Will both raid sets start a rebuild?  Or only the affected raid set?

IOW, would there be two rebuild tasks, one for each raid set?  Or a
single rebuild that encompasses all raid sets (within the same raid
level, of course) on the disk in question? 

What I am getting at is whether there would be any advantage to
partitioning disks for failure purposes.   

Thanks,
-PWM

