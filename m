From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 00/24] Clustered MD RAID1
Date: Thu, 18 Dec 2014 10:14:57 -0600
Message-ID: <20141218161456.GA29504@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

This is an attempt to make MD-RAID cluster-aware. The advantage of
redundancy can help highly available systems to improve uptime.
Currently, the implementation is limited to RAID1 but with further work
(and some positive feedback), we could extend this to other compatible
RAID scenarios.

The design document (first patch) is pretty descriptive of how
the md has been made cluster-aware and how DLM is used to safeguard data
and communication.

This work requires some patches to the mdadm tool [1]

A quick howto:

1. With your corosync/pacemaker based cluster running execute:
# mdadm --create md0 --bitmap=clustered --raid-devices=2 --level=mirror --assume-clean /dev/sda /dev/sdb

2. On other nodes, issue:
# mdadm --assemble md0 /dev/sda /dev/sdb

References:
[1] mdadm tool changes: https://github.com/goldwynr/mdadm branch:cluster-md
[2] Patches against stable 3.14: https://github.com/goldwynr/linux branch: cluster-md-devel

Regards,

-- 
Goldwyn
