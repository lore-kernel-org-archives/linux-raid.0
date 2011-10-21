From: Krzysztof Adamski <k@adamski.org>
Subject: Advice on build a RAID6
Date: Fri, 21 Oct 2011 17:17:42 -0400
Message-ID: <1319231862.3649.19262.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I have been tasked with creating a backup repository. I'm looking for
advice on building a (relatively) big RAID6 array. The array is to be
build with 12x 3T Hitachi drives. 
The plan is to have XFS on top of LVM on top of the RAID6 structure.
One requirement is to partition the drives at 99% for the RAID.
Majority of the RAID6 space will be used for the backups, ie files
larger then 4GB each in one LV, the rest will be minor and unimportant
for now. The read access will be sequential reading of the files via NFS
by a maximum of 5 processes.

Boot will be on a different array.

I know that to use larger then 2T partitions in the RAID I can't use
0.9, so which one to use?

This will be done on Debian Squeeze with standard packages.

Thanks in advance,
K


