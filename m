From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Why people recommend to disable NCQ for MD RAID ?
Date: Fri, 20 Mar 2015 18:52:59 -0500
Message-ID: <CAB-428nrsMc2Aeyq1WmLcSM54B=Yr4ZApVPjxQBkiwEG-Yr1tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have read multiple blog post that people recommend to disable
NCQ/TCQ features of individual drives that is in the RAID group [1] in
a hope to improve RAID speed. I guess there should be some observation
in the field that results such a conclusion. However, this idea does
not make sense in theory. While drives can handle multiple outstanding
scsi commands at the same time, why don't we take advantage of this to
increase the disk access throughput ?


Thanks
Alireza

[1] http://www.cyberciti.biz/tips/linux-raid-increase-resync-rebuild-speed.html
