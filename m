From: Alberto Alonso <alberto@ggsys.net>
Subject: Software RAID when it works and when it doesn't
Date: Sat, 13 Oct 2007 13:40:51 -0500
Message-ID: <1192300851.16416.265.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Over the past several months I have encountered 3
cases where the software RAID didn't work in keeping
the servers up and running.

In all cases, the failure has been on a single drive,
yet the whole md device and server become unresponsive.

(usb-storage)
In one situation a RAID 0 across 2 USB drives failed
when one of the drives accidentally got turned off.

(sata)
A second case a disk started generating reports like:
end_request: I/O error, dev sdb, sector 42644555

(sata)
The third case (which I'm living right now) is a disk
that I can see during the boot process but that I can't
get operations on it to come back (ie. fdisk -l /dev/sdc). 

(pata)
I have had at least 4 situations on old servers based
on pata disks where disk failures where successful in
being flagged and arrays where degraded automatically.

So, this is all making me wonder under what circumstances
software RAID may have problems detecting disk failures.

I need to come up with a best practices solution and also
need to understand more as I move into raid over local
network (ie. iscsi, AoE or NBD). Could a disk failure in
one of the servers or a server going offline bring the
whole array down?

Thanks for any information or comments,

Alberto


