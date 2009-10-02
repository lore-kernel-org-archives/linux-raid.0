From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: A few remaining questions about installing to RAID-10
Date: Thu, 1 Oct 2009 18:27:57 -0700
Message-ID: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm setting up new linux boxes, hoping to install whatever OS I choose
to a software RAID array.

I've got 4 identical SATA drives, and would ideally like to use RAID-10.

I've read a bunch of slightly stale How-To docs, and have a few questions.

(1) Can Linux boot from /boot on RAID-10?  Oldest info I found said no
boot from RAID at all, then more recent docs said boot from RAID-1
works.  I found nothing on RAID-10.  What's the latest sccop on this?

(2) As far as I can tell, none of the installers in Centos, Ubuntu or
Opensuse are RAID-10 aware.  Seems like the sanest way to get setup
would be to boot from SystemRescueCD, do the partitioning and RAID
creation, then re-boot from an installer disk using the pre-setup
disks.

Am I missing some other, simpler approach?

(3) Assuming that I'll have to boot from RAID-1 (Just suspect that
RAID-10 is not yet an option for /boot, but willing to be shown
wrong!), I'm considering 3 partitioning/raid_config options,

  (a)
    DISK1      DISK2      DISK3      DISK4
   [ RAID-1  /boot                        ]
   [ RAID-1  swap                         ]
   [ RAID-10 LVM, /root & 'other' parts   ]

  (b)
    DISK1      DISK2      DISK3      DISK4
   [ RAID-1  /boot  ]    [ RAID-1  swap   ]
   [ RAID-10 LVM, /root & 'other' parts   ]

  (c)
    DISK1      DISK2      DISK3      DISK4
   [ RAID-1  /boot                        ]
   [ RAID-10 LVM, /root, swap & 'other'   ]

Are there any clear benefits/concerns of one config over the other?

(4) In setting up the RAID arrays, I've got a choice of metadata
versions.  It seems that the distros' installers default to "1.0", but
that "1.1" & "1.2" are both available, too.

Should I just use the newest, 1.2?  Any problems if I do?

(5) In whatever config is "best" in (3), above, is it still good
advice to install the bootlader into multiple MBRs? For example, if I
extend the RAID-1 over all 4-disks, then, I install the loader into
all four MBRs?

I think these are the last details I need to iron out before getting started.

Thanks for any help!

Ben
