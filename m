From: Richard Scobie <richard@sauce.co.nz>
Subject: 3dmd impact on performance.
Date: Wed, 03 Mar 2004 13:49:13 +1300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40452B89.1020305@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While testing a 4 disk hardware RAID 10 on a 3ware 7506LP, I have found 
a +- 10MB/s reduction in write performance with the 3dmd monitoring 
daemons running, all other parameters the same.

Dual 2.4 Xeon, 4 x 250GB, 1GB RAM, XFS, 2.2.25, latest 3dm software.

iozone -s 40000m -r 1244 -i0 -i1 -t1 -b test18.xls -f /usr/graphics/tmp

With 3dmd: Read 91.9MB/s   Write 78.0MB/s

Without 3dmd: Read 92.8MB/s Write 88.9MB/s

Repeatable over 3 trials of each.

Regards,

Richard

