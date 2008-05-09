From: Eric Sandeen <sandeen@sandeen.net>
Subject: partitioned mirror vs. mirrors of partitions?
Date: Thu, 08 May 2008 20:00:40 -0500
Message-ID: <4823A238.4080205@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I hope this isn't a FAQ, I did do a little searching first...

I'm looking at using a couple of large disks to mirror a system which
currently has a few different filesystems; I'll use partitions on the
disks to contain the different fileystems.

It looks like I could mirror sda and sdb, and partition the resulting
md_d0.  Or, I could partition sda and sdb, and create mirrors md0, md1,
etc from the partitions on the underlying disks.

Is there any technical reason to choose one method vs the other?  It
seems to me that perhaps on a system with several active partitions from
the same disk, partitioning a single large raid device might allow
better read balancing?

Thanks,

-Eric
