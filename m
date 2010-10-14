From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Preventing a RAID device from starting until all disks are ready
Date: Thu, 14 Oct 2010 08:36:44 -0700 (PDT)
Message-ID: <385159.62204.qm@web65412.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having problems with a 56-drive fibre-channel software RAID-10 array.

During boot, mdadm starts the array before one of the two fibre-channel cards has started its disk detection.  The array comes up, but with only 28 of 56 drives, and I have to manually re-add the drives and cross my fingers that nothing will go wrong during the 10-hour rebuild.

Is there any way to tell mdadm to wait longer, or to not attempt to start the array if not all devices are present, or... (any other solution you can think of)?

I'm on Centos 5.2.

Thanks.

Andrew




