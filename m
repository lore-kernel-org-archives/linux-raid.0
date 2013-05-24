From: Matt Garman <matthew.garman@gmail.com>
Subject: raid10 physical layout?
Date: Fri, 24 May 2013 13:49:30 -0500
Message-ID: <20130524184930.GA9609@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I'm looking into building a six-disk raid10.  The six disks are
comprised of three from one manufacturer, and three from another.

My intuition says that for better statistical reliability, the
redundant data copies ought to fall on disks of different
manufacturers.  I know I could achieve this easily by building a
"classic" RAID1+0 system: three RAID-1 sets built by
manufacturerA+manufacturerB pairs, then striping those mirrored sets
in RAID-0.

But based on what I've been reading, looks like mdadm's more
sophisticated raid10 layout schemes give better performance.  For
example, can I create a raid10,f2 set in such a way as to meet my
"redundant copies on different manufacturer" criteria?

Thanks,
Matt

