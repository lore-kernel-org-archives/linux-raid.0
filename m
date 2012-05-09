From: Michael Peterson <Michael.Peterson@duke.edu>
Subject: tracking parity mismatches to a failing disk
Date: Wed, 09 May 2012 15:16:08 -0400
Message-ID: <4FAAC278.6080303@duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to identify the source of a non-zero mismatch_cnt on a
six-disk RAID6 md array.  I think I've identified it as /dev/sdf since
that is the only device with a non-zero value in
/sys/block/md0/md/dev-sd*/errors.  Is that the right way to track parity
mismatches back to a disk?

OS is CentOS 5.8 -> mdadm 2.6.9

Thanks,
Michael
