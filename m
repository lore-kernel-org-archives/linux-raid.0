From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID-6 horizontal grow
Date: Fri, 10 Apr 2009 23:54:35 +0200
Message-ID: <20090410215435.GA10451@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

is it possible to grow a RAID-6, not by adding
more drives, but by extending the partions which
are composing the array?

In other words, let's say I've "n" partitions of
"x" GB forming a RAID-6 array. After some time I
increase the size of each partition to "y" GB, of
course y > x.
Is it then possible to use the complete space
growing the array?
How?

Thanks,

bye,

-- 

piergiorgio
