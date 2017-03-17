From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH 0/2] mdadm: setting device role of raid1 disk with failfast
Date: Fri, 17 Mar 2017 17:47:00 +0100
Message-ID: <1489769222-31855-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-raid.ids

Hi,

I've found a case that failfast option of mdadm set a disk faulty wrongly.
Following is my test case.

mdadm --create /dev/md100 -l 1 --failfast -e 1.2 -n 2 /dev/vdb /dev/vdc
mdadm /dev/md100 -a --failfast /dev/vdd

If I use failfast option, the vdd disk was faulty wrongly.
If not, it was spare.

This patch fixes a corner case for setting device role and
prints device role if it's faulty.
This patch is based on "mdadm - v4.0-8-g72b616a - 2017-03-07".

Gioh Kim (1):
  super1: ignore failfast flag for setting device role

Jack Wang (1):
  super1: check and output faulty dev role

 super1.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
2.5.0
