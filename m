From: Bryan Carmula <bryancarmula@gmail.com>
Subject: evacuating drives in a RAID10 array
Date: Tue, 20 May 2014 00:22:33 -0400
Message-ID: <CAN7CiWh6rR-iT6Bicqpt-R4ohVJwg_6sTzA8eQnajAP-5-Rd=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Can anyone provide insight (or point toward appropriate documentation)
on how to evacuate/decommission a drive that is a member of a complex
(non-nested) RAID10 array while keeping data intact? Number of
replicas can be reduced to 1 if necessary; this is a temporary state
as part of a data migration.

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid10 sdd1[2] sde1[3] sda1[0] sdc1[1]
      3907023872 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/233 pages [0KB], 8192KB chunk

Thanks in advance,
B.C.
