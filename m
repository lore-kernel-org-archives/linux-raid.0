From: CAMTP guest <camtp.guest@uni-mb.si>
Subject: reconf RAID5 superblock corruption (cont.)
Date: Wed, 16 Oct 2002 18:55:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15789.39436.702725.363437@proizd.camtp.uni-mb.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to add that I did two resizing tests:
1) 3 disks, no spare -> 4 disks, no spare
2) 3 disks, 1 spare -> 4 disks, 1 spare

The first test went OK, the second failed, as reported
in my previous mail. I have noticed a similar problem
reported a few months ago on the list. If it helps
I can repeat the experiment and report all the details.

-Igor Mozetic

Please CC to me.
