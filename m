From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: clustered MD - beyond RAID1
Date: Fri, 2 Dec 2016 11:12:52 -0700
Message-ID: <CAB9NSeV2A+BZzUbzj516e24CL05k6zF6tgZ+vpNptSO30ipyug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Excuse me for being late to the party on this subject, but is the idea of
clustered RAID5/6 alive or dead?

I have a need for such a feature. I'm in development on SAS JBODs with
large drive counts, 60 and 90 drives per JBOD. We would like to support
multi-host connectivity in an active/active fashion with MD RAID60.  This
clustered MD RAID can and should be a nice alternative to HW RAID solutions
like LSI/Avago "Syncro" MegaRAID.

I currently have the hardware and time to help develop and test the
clustered RAID5/6.
I just finished up building a test cluster of 2 nodes with the cluster-md
RAID1.  Worked fine with gfs2 on top.


My current real job is firmware on these SAS JBODS. I have many years of
Linux experience and have developed (years ago) some kernel modules for a
custom FPGA based PCIe cards.
