From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: Import data from an array coming from another computer
Date: Thu, 6 Jun 2013 16:47:33 +0200
Message-ID: <CAO5znavAuteVhzarkVEDHPOxs4RFx9j0tB51QXj5LUcREJbn=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello guys,

I need some help to recover some data that resides on a disk that was
part of an array in an Iomega device. I connected the disk with a
SATA->USB connector to my computer. An mdadm --examine give me theses
informations:

############################################################
# $ mdadm --examine /dev/sdc1
# /dev/sdc1:
#           Magic : a92b4efc
#         Version : 0.90.00
#            UUID : 76fc436c:be43bed5:f0f41dd6:3e9e1b96
#   Creation Time : Fri Jun  8 04:21:19 2012
#     Raid Level : raid1
#   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
#     Array Size : 20980800 (20.01 GiB 21.48 GB)
#   Raid Devices : 2
#   Total Devices : 2
#  Preferred Minor : 0
#
#    Update Time : Thu May 23 14:55:13 2013
#          State : clean
#  Active Devices : 1
#  Working Devices : 2
#  Failed Devices : 0
#   Spare Devices : 1
#        Checksum : b0ae04f1 - correct
#          Events : 28935
#
#
#       Number   Major   Minor   RaidDevice State
# this     2       8        1        2      spare   /dev/sda1
#
#    0     0       0        0        0      removed
#    1     1       8       17        1      active sync   /dev/sdb1
#    2     2       8        1        2      spare   /dev/sda1
############################################################

What I cannot achieve is to create a newly empty array and insert that
existing disk inside of it, so I can backup the data elsewhere.

I tried with mdadm --assemble /dev/sdc1 but it says:
    mdadm: device /dev/sdc1 exists but is not an md array.

I someone have an idea? It would be really really great :)

--
Nicolas MICHEL
